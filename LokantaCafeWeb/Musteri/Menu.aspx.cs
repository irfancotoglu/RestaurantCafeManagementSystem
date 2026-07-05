using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;


namespace LokantaCafeWeb.Musteri
{
    public partial class Menu : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kullanıcı adını header'da göster (Login'de Session'a atmıştık)
                if (Session["AdSoyad"] != null)
                {
                    lblHosgeldin.Text = "Hoş geldiniz, " + Session["AdSoyad"].ToString();
                }

                KategorileriYukle();
                UrunleriYukle();
                SepetOzetGoster();
            }
        }

        private void KategorileriYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT KategoriId, KategoriAdi FROM Kategori WHERE AktifMi = 1 ORDER BY KategoriAdi";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlKategori.Items.Clear();

                        // 0 = Tümü
                        ddlKategori.Items.Add(new System.Web.UI.WebControls.ListItem("Tüm Kategoriler", "0"));

                        while (dr.Read())
                        {
                            ddlKategori.Items.Add(new System.Web.UI.WebControls.ListItem(
                                dr["KategoriAdi"].ToString(),
                                dr["KategoriId"].ToString()
                            ));
                        }
                    }
                }
            }
        }

        private void UrunleriYukle()
        {
            lblMesaj.Text = "";

            int seciliKategoriId = int.Parse(ddlKategori.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT UrunId, UrunAdi, Fiyat, Aciklama
                    FROM Urun
                    WHERE AktifMi = 1";

                if (seciliKategoriId > 0)
                {
                    sql += " AND KategoriId = @KategoriId";
                }

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (seciliKategoriId > 0)
                    {
                        cmd.Parameters.AddWithValue("@KategoriId", seciliKategoriId);
                    }

                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count == 0)
                        {
                            lblMesaj.Text = "Bu kategori için ürün bulunamadı.";
                        }

                        rptUrunler.DataSource = dt;
                        rptUrunler.DataBind();
                    }
                }
            }
        }

        protected void ddlKategori_SelectedIndexChanged(object sender, EventArgs e)
        {
            UrunleriYukle();
        }

        // =======================
        // SEPET İŞLEMLERİ
        // =======================

        // Session'da DataTable olarak sepet tutacağız
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

        private void SepeteEkle(int urunId, int adet)
        {
            if (adet <= 0) adet = 1;

            DataTable sepet = GetSepetTable();

            string urunAdi = "";
            decimal fiyat = 0;

            // Ürün bilgilerini DB'den çek
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT UrunAdi, Fiyat FROM Urun WHERE UrunId = @UrunId AND AktifMi = 1";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UrunId", urunId);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            urunAdi = dr["UrunAdi"].ToString();
                            fiyat = Convert.ToDecimal(dr["Fiyat"]);
                        }
                        else
                        {
                            lblMesaj.Text = "Ürün bulunamadı.";
                            return;
                        }
                    }
                }
            }

            // Sepette aynı üründen var mı?
            DataRow mevcutSatir = null;
            foreach (DataRow row in sepet.Rows)
            {
                if ((int)row["UrunId"] == urunId)
                {
                    mevcutSatir = row;
                    break;
                }
            }

            if (mevcutSatir == null)
            {
                // Yeni satır ekle
                DataRow yeni = sepet.NewRow();
                yeni["UrunId"] = urunId;
                yeni["UrunAdi"] = urunAdi;
                yeni["Fiyat"] = fiyat;
                yeni["Adet"] = adet;
                yeni["Tutar"] = fiyat * adet;
                sepet.Rows.Add(yeni);
            }
            else
            {
                // Mevcut satırın adedini artır
                int eskiAdet = (int)mevcutSatir["Adet"];
                int yeniAdet = eskiAdet + adet;
                mevcutSatir["Adet"] = yeniAdet;
                mevcutSatir["Tutar"] = fiyat * yeniAdet;
            }

            Session["Sepet"] = sepet;
            SepetOzetGoster();
        }

        private void SepetOzetGoster()
        {
            DataTable sepet = Session["Sepet"] as DataTable;
            if (sepet == null || sepet.Rows.Count == 0)
            {
                lblSepetOzet.Text = "Sepetiniz boş.";
            }
            else
            {
                int toplamAdet = 0;
                decimal toplamTutar = 0;

                foreach (DataRow row in sepet.Rows)
                {
                    toplamAdet += (int)row["Adet"];
                    toplamTutar += (decimal)row["Tutar"];
                }

                lblSepetOzet.Text = $"Sepette {toplamAdet} adet ürün, toplam {toplamTutar:C}.";
            }
        }

        protected void rptUrunler_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SepeteEkle")
            {
                int urunId = Convert.ToInt32(e.CommandArgument);

                // Satır içindeki adet textbox'unu bul
                var txtAdet = (TextBox)e.Item.FindControl("txtAdet");
                int adet = 1;
                int.TryParse(txtAdet.Text, out adet);

                SepeteEkle(urunId, adet);
            }
        }

    }
}
