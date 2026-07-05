using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LokantaCafeWeb.Musteri
{
    public partial class Sepet : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["AdSoyad"] != null)
                {
                    lblHosgeldin.Text = "Hoş geldiniz, " + Session["AdSoyad"].ToString();
                }

                SepetiBagla();
            }
        }

        // Session'dan sepet DataTable'ını al
        private DataTable GetSepetTable()
        {
            if (Session["Sepet"] == null)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("UrunId", typeof(int));
                dt.Columns.Add("UrunAdi", typeof(string));
                dt.Columns.Add("Fiyat", typeof(decimal));
                dt.Columns.Add("Adet", typeof(int));
                dt.Columns.Add("Tutar", typeof(decimal));
                Session["Sepet"] = dt;
            }

            return (DataTable)Session["Sepet"];
        }

        private void SepetiBagla()
        {
            DataTable sepet = GetSepetTable();
            gvSepet.DataSource = sepet;
            gvSepet.DataBind();

            decimal toplam = 0;
            int toplamAdet = 0;

            foreach (DataRow row in sepet.Rows)
            {
                toplam += (decimal)row["Tutar"];
                toplamAdet += (int)row["Adet"];
            }

            if (sepet.Rows.Count == 0)
            {
                lblToplam.Text = "Sepetiniz boş.";
            }
            else
            {
                lblToplam.Text = $"Toplam {toplamAdet} adet ürün, genel toplam: {toplam:C}";
            }
        }

        // GridView'de "Sil" butonu
        protected void gvSepet_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Sil")
            {
                int index = Convert.ToInt32(e.CommandArgument); // satır index'i
                DataTable sepet = GetSepetTable();

                if (index >= 0 && index < sepet.Rows.Count)
                {
                    sepet.Rows.RemoveAt(index);
                    Session["Sepet"] = sepet;
                }

                SepetiBagla();
            }
        }

        // Siparişi ver butonu
        protected void btnSiparisiOnayla_Click(object sender, EventArgs e)
        {
            lblMesaj.ForeColor = System.Drawing.Color.Red;
            lblMesaj.Text = "";

            DataTable sepet = GetSepetTable();

            if (sepet.Rows.Count == 0)
            {
                lblMesaj.Text = "Sepetiniz boş, sipariş verilemez.";
                return;
            }

            if (Session["KullaniciId"] == null)
            {
                lblMesaj.Text = "Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.";
                return;
            }

            int kullaniciId = Convert.ToInt32(Session["KullaniciId"]);

            // 1) KullaniciId'den MusteriId'yi bul
            int musteriId = GetMusteriIdByKullaniciId(kullaniciId);
            if (musteriId == 0)
            {
                lblMesaj.Text = "Müşteri kaydınız bulunamadı.";
                return;
            }

            // 2) Adres bilgilerini Adres tablosuna kaydet
            int adresId = EkleAdresVeGetId(musteriId);

            if (adresId == 0)
            {
                lblMesaj.Text = "Adres kaydedilirken hata oluştu.";
                return;
            }

            // 3) sp_SiparisAc ile yeni sipariş oluştur
            int yeniSiparisId = 0;
            string notlar = txtNotlar.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_SiparisAc", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MusteriId", musteriId);
                cmd.Parameters.AddWithValue("@MasaId", DBNull.Value);
                cmd.Parameters.AddWithValue("@AdresId", adresId);
                cmd.Parameters.AddWithValue("@TeslimatTipi", "Online");
                cmd.Parameters.AddWithValue("@Notlar", (object)notlar ?? DBNull.Value);

                SqlParameter pOut = new SqlParameter("@YeniSiparisId", SqlDbType.Int);
                pOut.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(pOut);

                conn.Open();
                cmd.ExecuteNonQuery();

                yeniSiparisId = Convert.ToInt32(pOut.Value);
            }

            if (yeniSiparisId <= 0)
            {
                lblMesaj.Text = "Sipariş oluşturulurken hata oluştu.";
                return;
            }

            // 4) Sepetteki her ürün için sp_SiparisDetayEkle çağır
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    foreach (DataRow row in sepet.Rows)
                    {
                        int urunId = (int)row["UrunId"];
                        int adet = (int)row["Adet"];

                        using (SqlCommand cmdDetay = new SqlCommand("sp_SiparisDetayEkle", conn))
                        {
                            cmdDetay.CommandType = CommandType.StoredProcedure;
                            cmdDetay.Parameters.AddWithValue("@SiparisId", yeniSiparisId);
                            cmdDetay.Parameters.AddWithValue("@UrunId", urunId);
                            cmdDetay.Parameters.AddWithValue("@Adet", adet);

                            cmdDetay.ExecuteNonQuery();
                        }
                    }
                }

                // 5) Sepeti temizle
                sepet.Rows.Clear();
                Session["Sepet"] = sepet;
                SepetiBagla();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = $"Siparişiniz başarıyla oluşturuldu. Sipariş Numaranız: {yeniSiparisId}";
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Sipariş detayları eklenirken hata oluştu: " + ex.Message;
            }
        }

        private int GetMusteriIdByKullaniciId(int kullaniciId)
        {
            int musteriId = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT MusteriId FROM Musteri WHERE KullaniciId = @KullaniciId", conn))
            {
                cmd.Parameters.AddWithValue("@KullaniciId", kullaniciId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    musteriId = Convert.ToInt32(result);
                }
            }

            return musteriId;
        }

        private int EkleAdresVeGetId(int musteriId)
        {
            string baslik = txtAdresBaslik.Text.Trim();
            string adresMetni = txtAdresMetni.Text.Trim();
            string il = txtIl.Text.Trim();
            string ilce = txtIlce.Text.Trim();
            string postaKodu = txtPostaKodu.Text.Trim();

            if (string.IsNullOrWhiteSpace(baslik) || string.IsNullOrWhiteSpace(adresMetni) ||
                string.IsNullOrWhiteSpace(il) || string.IsNullOrWhiteSpace(ilce))
            {
                // Basit kontrol, daha önce bakmıştık ama yine de
                lblMesaj.Text = "Adres alanlarını eksiksiz doldurunuz.";
                return 0;
            }

            int adresId = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                INSERT INTO Adres (MusteriId, Baslik, AdresMetni, Il, Ilce, PostaKodu, AktifMi)
                VALUES (@MusteriId, @Baslik, @AdresMetni, @Il, @Ilce, @PostaKodu, 1);
                SELECT SCOPE_IDENTITY();
            ", conn))
            {
                cmd.Parameters.AddWithValue("@MusteriId", musteriId);
                cmd.Parameters.AddWithValue("@Baslik", baslik);
                cmd.Parameters.AddWithValue("@AdresMetni", adresMetni);
                cmd.Parameters.AddWithValue("@Il", il);
                cmd.Parameters.AddWithValue("@Ilce", ilce);
                cmd.Parameters.AddWithValue("@PostaKodu", (object)postaKodu ?? DBNull.Value);

                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    adresId = Convert.ToInt32(result);
                }
            }

            return adresId;
        }
    }
}
