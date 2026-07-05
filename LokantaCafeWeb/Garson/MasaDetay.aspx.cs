using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Garson
{
    public partial class MasaDetay : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        int MasaId
        {
            get
            {
                int id;
                int.TryParse(Request.QueryString["masaId"], out id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (MasaId <= 0)
            {
                lblMesaj.Text = "Geçersiz masa.";
                return;
            }

            if (!IsPostBack)
            {
                MasaBilgisiYukle();
                UrunleriYukle();
                SiparisVeDetayYukle();
            }
        }

        private void MasaBilgisiYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT MasaNo, Durum FROM Masa WHERE MasaId = @MasaId", conn))
            {
                cmd.Parameters.AddWithValue("@MasaId", MasaId);
                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblMasaNo.Text = dr["MasaNo"].ToString();
                        lblMasaDurum.Text = dr["Durum"].ToString();
                    }
                }
            }
        }

        private void UrunleriYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT UrunId, UrunAdi, Fiyat FROM Urun WHERE AktifMi = 1 ORDER BY UrunAdi", conn))
            {
                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlUrunler.Items.Clear();
                    while (dr.Read())
                    {
                        string text = $"{dr["UrunAdi"]} ( {Convert.ToDecimal(dr["Fiyat"]):C} )";
                        string value = dr["UrunId"].ToString();
                        ddlUrunler.Items.Add(new ListItem(text, value));
                    }
                }
            }
        }

        private void SiparisVeDetayYukle()
        {
            // Aktif sipariş bul (ödenmemiş)
            int siparisId = 0;
            DateTime? siparisTarihi = null;
            string durum = "";
            decimal toplamTutar = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 1 SiparisId, SiparisTarihi, Durum, ToplamTutar
                FROM Siparis
                WHERE MasaId = @MasaId
                  AND OdendiMi = 0
                  AND Durum IN (N'Alindi', N'Hazirlaniyor', N'Yolda')
                ORDER BY SiparisTarihi DESC;", conn))
            {
                cmd.Parameters.AddWithValue("@MasaId", MasaId);
                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        siparisId = Convert.ToInt32(dr["SiparisId"]);
                        siparisTarihi = (DateTime)dr["SiparisTarihi"];
                        durum = dr["Durum"].ToString();
                        toplamTutar = Convert.ToDecimal(dr["ToplamTutar"]);
                    }
                }
            }

            hfSiparisId.Value = siparisId.ToString();

            if (siparisId == 0)
            {
                lblSiparisBilgi.Text = "Bu masaya ait aktif sipariş yok. Ürün eklediğinizde yeni sipariş açılacaktır.";
                lblToplamTutar.Text = "";
                gvSiparisDetay.DataSource = null;
                gvSiparisDetay.DataBind();
                return;
            }

            lblSiparisBilgi.Text = $"Sipariş No: {siparisId} - Tarih: {siparisTarihi} - Durum: {durum}";
            lblToplamTutar.Text = $"Toplam Tutar: {toplamTutar:C}";

            // Sipariş detaylarını yükle
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmdDetay = new SqlCommand(@"
                SELECT sd.SiparisDetayId, u.UrunAdi, sd.Adet, sd.BirimFiyat, sd.Tutar
                FROM SiparisDetay sd
                JOIN Urun u ON u.UrunId = sd.UrunId
                WHERE sd.SiparisId = @SiparisId", conn))
            {
                cmdDetay.Parameters.AddWithValue("@SiparisId", siparisId);
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmdDetay))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvSiparisDetay.DataSource = dt;
                    gvSiparisDetay.DataBind();
                }
            }
        }

        // Ürün ekle butonu
        protected void btnUrunEkle_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";

            int urunId = Convert.ToInt32(ddlUrunler.SelectedValue);
            int adet = 1;
            int.TryParse(txtAdet.Text, out adet);
            if (adet <= 0) adet = 1;

            int siparisId;
            int.TryParse(hfSiparisId.Value, out siparisId);

            // Eğer aktif sipariş yoksa önce sp_SiparisAc ile aç
            if (siparisId == 0)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_SiparisAc", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MusteriId", DBNull.Value);
                    cmd.Parameters.AddWithValue("@MasaId", MasaId);
                    cmd.Parameters.AddWithValue("@AdresId", DBNull.Value);
                    cmd.Parameters.AddWithValue("@TeslimatTipi", "Masa");
                    cmd.Parameters.AddWithValue("@Notlar", DBNull.Value);

                    SqlParameter pOut = new SqlParameter("@YeniSiparisId", SqlDbType.Int);
                    pOut.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(pOut);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    siparisId = Convert.ToInt32(pOut.Value);
                    hfSiparisId.Value = siparisId.ToString();
                }

                // Sipariş açılınca masa trigger ile 'Dolu' olur; tekrar yükleyelim
                MasaBilgisiYukle();
            }

            // Sepete (siparişe) ürün ekle → sp_SiparisDetayEkle
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmdDetay = new SqlCommand("sp_SiparisDetayEkle", conn))
                {
                    cmdDetay.CommandType = CommandType.StoredProcedure;
                    cmdDetay.Parameters.AddWithValue("@SiparisId", siparisId);
                    cmdDetay.Parameters.AddWithValue("@UrunId", urunId);
                    cmdDetay.Parameters.AddWithValue("@Adet", adet);

                    conn.Open();
                    cmdDetay.ExecuteNonQuery();
                }

                txtAdet.Text = "1";
                SiparisVeDetayYukle();
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Ürün eklenirken hata: " + ex.Message;
            }
        }

        // Ödeme al butonu
        protected void btnOdemeAl_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";

            int siparisId;
            int.TryParse(hfSiparisId.Value, out siparisId);

            if (siparisId == 0)
            {
                lblMesaj.Text = "Bu masaya ait ödenmemiş sipariş bulunmuyor.";
                return;
            }

            // Toplam tutarı siparişten çek
            decimal toplamTutar = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT ToplamTutar FROM Siparis WHERE SiparisId = @SiparisId", conn))
            {
                cmd.Parameters.AddWithValue("@SiparisId", siparisId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    toplamTutar = Convert.ToDecimal(result);
            }

            if (toplamTutar <= 0)
            {
                lblMesaj.Text = "Toplam tutar 0, ödeme alınamaz.";
                return;
            }

            string odemeTipi = ddlOdemeTipi.SelectedValue;
            string aciklama = txtOdemeAciklama.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Odeme (SiparisId, OdemeTarihi, OdemeTutari, OdemeTipi, Aciklama)
                    VALUES (@SiparisId, GETDATE(), @OdemeTutari, @OdemeTipi, @Aciklama);", conn))
                {
                    cmd.Parameters.AddWithValue("@SiparisId", siparisId);
                    cmd.Parameters.AddWithValue("@OdemeTutari", toplamTutar);
                    cmd.Parameters.AddWithValue("@OdemeTipi", odemeTipi);
                    cmd.Parameters.AddWithValue("@Aciklama", (object)aciklama ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Burada trigger tr_Odeme_Insert_SiparisOdendiMasaBosalt:
                // - Siparis.OdendiMi = 1
                // - Masa.Durum = 'Bos'

                hfSiparisId.Value = "0";
                SiparisVeDetayYukle();
                MasaBilgisiYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Ödeme alındı, masa boşaltıldı.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Ödeme alınırken hata: " + ex.Message;
            }
        }
    }
}
