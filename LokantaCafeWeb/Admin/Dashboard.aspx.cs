using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace LokantaCafeWeb.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Basit rol kontrolü (Admin olmayanı engelle)
            if (Session["Rol"] == null || Session["Rol"].ToString() != "Admin")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Session["AdSoyad"] != null)
                {
                    lblAdmin.Text = "Hoş geldiniz, " + Session["AdSoyad"].ToString();
                }

                GunlukCiroGetir();
                AylikCiroGetir();
                TopMusterileriGetir();
            }
        }

        private void GunlukCiroGetir()
        {
            DateTime bugun = DateTime.Today;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_GunlukCiroGetir", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Tarih", bugun.Date);

                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        int odemeSayisi = dr["OdemeSayisi"] != DBNull.Value ? Convert.ToInt32(dr["OdemeSayisi"]) : 0;
                        decimal toplamCiro = dr["ToplamCiro"] != DBNull.Value ? Convert.ToDecimal(dr["ToplamCiro"]) : 0;

                        lblGunlukCiro.Text = toplamCiro.ToString("C");
                        lblGunlukDetay.Text = $"Ödeme sayısı: {odemeSayisi}";
                    }
                }
            }
        }

        private void AylikCiroGetir()
        {
            DateTime bugun = DateTime.Today;
            int yil = bugun.Year;
            int ay = bugun.Month;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT dbo.fn_AylikCiro(@Yil, @Ay)", conn))
            {
                cmd.Parameters.AddWithValue("@Yil", yil);
                cmd.Parameters.AddWithValue("@Ay", ay);

                conn.Open();
                object result = cmd.ExecuteScalar();
                decimal aylikCiro = 0;
                if (result != null && result != DBNull.Value)
                {
                    aylikCiro = Convert.ToDecimal(result);
                }

                lblAylikCiro.Text = aylikCiro.ToString("C");
                lblAylikDetay.Text = $"{ay}.{yil} ayı toplam cirosu";
            }
        }

        private void TopMusterileriGetir()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 10 *
                FROM v_MusteriSiparisOzet
                ORDER BY ToplamOdeme DESC;", conn))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvTopMusteriler.DataSource = dt;
                    gvTopMusteriler.DataBind();
                }
            }
        }
    }
}
