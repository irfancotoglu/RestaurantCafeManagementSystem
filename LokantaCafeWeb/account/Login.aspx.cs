using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace LokantaCafeWeb.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";

            string email = txtEmail.Text.Trim();
            string parola = txtParola.Text.Trim();

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(parola))
            {
                lblMesaj.Text = "E-posta ve şifre zorunludur.";
                return;
            }

            string sifreHash = Sha256Hash(parola);
            string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"
                        SELECT k.KullaniciId, k.AdSoyad, r.RolAdi
                        FROM Kullanici k
                        INNER JOIN Rol r ON r.RolId = k.RolId
                        WHERE k.Email = @Email
                          AND k.SifreHash = @SifreHash
                          AND k.AktifMi = 1";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@SifreHash", sifreHash);

                        conn.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                int kullaniciId = Convert.ToInt32(dr["KullaniciId"]);
                                string adSoyad = dr["AdSoyad"].ToString();
                                string rol = dr["RolAdi"].ToString(); // 'Admin', 'Garson', 'Müşteri'

                                // Session'a at
                                Session["KullaniciId"] = kullaniciId;
                                Session["AdSoyad"] = adSoyad;
                                Session["Rol"] = rol;

                                // Role göre yönlendir
                                if (rol == "Müşteri")
                                {
                                    Response.Redirect("~/Musteri/Menu.aspx");
                                }
                                else if (rol == "Garson")
                                {
                                    Response.Redirect("~/Garson/Masalar.aspx");
                                }
                                else if (rol == "Admin")
                                {
                                    Response.Redirect("~/Admin/Dashboard.aspx");
                                }
                                else
                                {
                                    // Beklenmeyen rol (ama CHECK sebebiyle olmaz)
                                    lblMesaj.Text = "Rol tanımsız, yönlendirme yapılamadı.";
                                }
                            }
                            else
                            {
                                lblMesaj.Text = "E-posta veya şifre hatalı.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

        private string Sha256Hash(string raw)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(raw);
                byte[] hash = sha.ComputeHash(bytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
            }
        }
    }
}
