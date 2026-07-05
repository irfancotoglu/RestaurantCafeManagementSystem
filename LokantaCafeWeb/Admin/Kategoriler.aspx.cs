using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Admin
{
    public partial class Kategoriler : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Rol"] == null || Session["Rol"].ToString() != "Admin")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                KategorileriYukle();
            }
        }

        private void KategorileriYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT KategoriId, KategoriAdi, Aciklama, AktifMi FROM Kategori ORDER BY KategoriAdi", conn))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvKategoriler.DataSource = dt;
                    gvKategoriler.DataBind();
                }
            }
        }

        protected void btnKategoriEkle_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";
            string adi = txtYeniKategoriAdi.Text.Trim();
            string aciklama = txtYeniAciklama.Text.Trim();

            if (string.IsNullOrWhiteSpace(adi))
            {
                lblMesaj.Text = "Kategori adı boş olamaz.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Kategori (KategoriAdi, Aciklama, AktifMi)
                    VALUES (@Adi, @Aciklama, 1);", conn))
                {
                    cmd.Parameters.AddWithValue("@Adi", adi);
                    cmd.Parameters.AddWithValue("@Aciklama", (object)aciklama ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtYeniKategoriAdi.Text = "";
                txtYeniAciklama.Text = "";
                KategorileriYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Kategori eklendi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

        protected void gvKategoriler_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvKategoriler.EditIndex = e.NewEditIndex;
            KategorileriYukle();
        }

        protected void gvKategoriler_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvKategoriler.EditIndex = -1;
            KategorileriYukle();
        }

        protected void gvKategoriler_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int kategoriId = Convert.ToInt32(gvKategoriler.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvKategoriler.Rows[e.RowIndex];

            string adi = ((TextBox)row.Cells[1].Controls[0]).Text;
            string aciklama = ((TextBox)row.Cells[2].Controls[0]).Text;
            bool aktifMi = ((CheckBox)row.Cells[3].Controls[0]).Checked;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE Kategori
                    SET KategoriAdi = @Adi,
                        Aciklama   = @Aciklama,
                        AktifMi    = @AktifMi
                    WHERE KategoriId = @Id;", conn))
                {
                    cmd.Parameters.AddWithValue("@Adi", adi);
                    cmd.Parameters.AddWithValue("@Aciklama", (object)aciklama ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@AktifMi", aktifMi);
                    cmd.Parameters.AddWithValue("@Id", kategoriId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                gvKategoriler.EditIndex = -1;
                KategorileriYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Kategori güncellendi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

        // Sil = bizde "pasif yap"
        protected void gvKategoriler_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int kategoriId = Convert.ToInt32(gvKategoriler.DataKeys[e.RowIndex].Value);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE Kategori
                    SET AktifMi = 0
                    WHERE KategoriId = @Id;", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", kategoriId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                KategorileriYukle();
                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Kategori pasif yapıldı (silinmedi).";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }
    }
}
