using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LokantaCafeWeb.Genel
{
    public partial class MekanMenu : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // DİKKAT: Burada login/rol kontrolü yok. Herkese açık.
            if (!IsPostBack)
            {
                KategorileriYukle();
                UrunleriYukle();
            }
        }

        private void KategorileriYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                    SELECT KategoriId, KategoriAdi
                    FROM Kategori
                    WHERE AktifMi = 1
                    ORDER BY KategoriAdi;", conn))
            {
                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlKategori.Items.Clear();
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

        private void UrunleriYukle()
        {
            lblMesaj.Text = "";

            int seciliKategoriId = 0;
            int.TryParse(ddlKategori.SelectedValue, out seciliKategoriId);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT UrunId, UrunAdi, Fiyat, Aciklama, ResimYolu
                    FROM Urun
                    WHERE AktifMi = 1";

                if (seciliKategoriId > 0)
                {
                    sql += " AND KategoriId = @KategoriId";
                }

                sql += " ORDER BY UrunAdi";

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
                            lblMesaj.Text = "Bu kategori için henüz ürün tanımlanmamıştır.";
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
    }
}
