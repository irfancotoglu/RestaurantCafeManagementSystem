using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Admin
{
    public partial class Masalar : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Sadece Admin erişsin
            if (Session["Rol"] == null || Session["Rol"].ToString() != "Admin")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                MasalariYukle();
            }
        }

        private void MasalariYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT MasaId, MasaNo, Durum, Aciklama FROM Masa ORDER BY MasaNo", conn))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvMasalar.DataSource = dt;
                    gvMasalar.DataBind();
                }
            }
        }

        protected void btnMasaEkle_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";
            lblMesaj.ForeColor = System.Drawing.Color.Red;

            string masaNo = txtMasaNo.Text.Trim();
            string aciklama = txtAciklama.Text.Trim();

            if (string.IsNullOrWhiteSpace(masaNo))
            {
                lblMesaj.Text = "Masa numarası boş olamaz.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Masa (MasaNo, Durum, Aciklama)
                    VALUES (@MasaNo, N'Bos', @Aciklama);", conn))
                {
                    cmd.Parameters.AddWithValue("@MasaNo", masaNo);
                    cmd.Parameters.AddWithValue("@Aciklama", (object)aciklama ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtMasaNo.Text = "";
                txtAciklama.Text = "";

                MasalariYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Masa eklendi.";
            }
            catch (SqlException ex)
            {
                // Örn. UNIQUE(MasaNo) ihlali
                if (ex.Message.Contains("UQ_") || ex.Message.Contains("UNIQUE"))
                {
                    lblMesaj.Text = "Bu masa numarası zaten tanımlı.";
                }
                else
                {
                    lblMesaj.Text = "Veritabanı hatası: " + ex.Message;
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

        protected void gvMasalar_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvMasalar.EditIndex = e.NewEditIndex;
            MasalariYukle();
        }

        protected void gvMasalar_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvMasalar.EditIndex = -1;
            MasalariYukle();
        }

        protected void gvMasalar_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            lblMesaj.Text = "";
            lblMesaj.ForeColor = System.Drawing.Color.Red;

            int masaId = Convert.ToInt32(gvMasalar.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvMasalar.Rows[e.RowIndex];

            string masaNo = ((TextBox)row.Cells[1].Controls[0]).Text.Trim();
            string aciklama = ((TextBox)row.Cells[3].Controls[0]).Text.Trim();

            if (string.IsNullOrWhiteSpace(masaNo))
            {
                lblMesaj.Text = "Masa numarası boş olamaz.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE Masa
                    SET MasaNo = @MasaNo,
                        Aciklama = @Aciklama
                    WHERE MasaId = @MasaId;", conn))
                {
                    cmd.Parameters.AddWithValue("@MasaNo", masaNo);
                    cmd.Parameters.AddWithValue("@Aciklama", (object)aciklama ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@MasaId", masaId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                gvMasalar.EditIndex = -1;
                MasalariYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Masa bilgisi güncellendi.";
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("UQ_") || ex.Message.Contains("UNIQUE"))
                {
                    lblMesaj.Text = "Bu masa numarası başka bir kayıtta kullanılıyor.";
                }
                else
                {
                    lblMesaj.Text = "Veritabanı hatası: " + ex.Message;
                }
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }
    }
}
