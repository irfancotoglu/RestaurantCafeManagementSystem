using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace LokantaCafeWeb.Account
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnKayitOl_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";

            string adSoyad = txtAdSoyad.Text.Trim();
            string email = txtEmail.Text.Trim();
            string parola = txtParola.Text.Trim();
            string parolaTekrar = txtParolaTekrar.Text.Trim();
            string telefon = txtTelefon.Text.Trim();

            // Basit kontroller
            if (string.IsNullOrWhiteSpace(adSoyad) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(parola))
            {
                lblMesaj.Text = "Lütfen zorunlu alanları doldurun.";
                return;
            }

            if (parola != parolaTekrar)
            {
                lblMesaj.Text = "Şifre ve şifre tekrarı aynı değil.";
                return;
            }

            // Şifreyi hash'le (SHA256)
            string sifreHash = Sha256Hash(parola);

            string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_MusteriKayit", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@AdSoyad", adSoyad);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@SifreHash", sifreHash);
                    cmd.Parameters.AddWithValue("@Telefon", (object)telefon ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery(); // SP içindeki SELECT'leri kullanmak şart değil

                    lblMesaj.ForeColor = System.Drawing.Color.Green;
                    lblMesaj.Text = "Kayıt başarıyla oluşturuldu. Giriş sayfasına yönlendiriliyorsunuz...";

                    // 2-3 saniye sonra login sayfasına yönlendirmek için:
                    Response.AddHeader("REFRESH", "2;URL=Login.aspx");
                }
            }
            catch (SqlException ex)
            {
                // Örneğin: "Bu e-posta adresi zaten kayıtlı." (SP içindeki RAISERROR)
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Beklenmeyen bir hata oluştu: " + ex.Message;
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
