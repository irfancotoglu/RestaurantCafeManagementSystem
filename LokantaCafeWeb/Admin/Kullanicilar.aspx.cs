using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Admin
{
    public partial class Kullanicilar : System.Web.UI.Page
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
                KullanicilariYukle();
            }
        }

        private void KullanicilariYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(@"
    SELECT 
        k.KullaniciId,
        k.AdSoyad,
        k.Email,
        ISNULL(m.Telefon, '') AS Telefon,
        k.AktifMi,
        r.RolAdi,
        r.RolId
    FROM Kullanici k
    JOIN Rol r ON r.RolId = k.RolId
    LEFT JOIN Musteri m ON m.KullaniciId = k.KullaniciId
    ORDER BY k.AdSoyad;", conn))

            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvKullanicilar.DataSource = dt;
                    gvKullanicilar.DataBind();
                }
            }
        }

        protected void gvKullanicilar_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvKullanicilar.EditIndex = e.NewEditIndex;
            KullanicilariYukle();
        }

        protected void gvKullanicilar_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvKullanicilar.EditIndex = -1;
            KullanicilariYukle();
        }

        protected void gvKullanicilar_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow &&
                (e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
            {
                // Edit modundaki satır
                DropDownList ddlRol = (DropDownList)e.Row.FindControl("ddlRol");
                if (ddlRol == null) return;

                // Rol listesini doldur
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("SELECT RolId, RolAdi FROM Rol ORDER BY RolAdi", conn))
                {
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlRol.Items.Clear();
                        while (dr.Read())
                        {
                            ddlRol.Items.Add(new ListItem(
                                dr["RolAdi"].ToString(),
                                dr["RolId"].ToString()
                            ));
                        }
                    }
                }

                // Şu anki rolü seçili yap
                int currentRolId = Convert.ToInt32(gvKullanicilar.DataKeys[e.Row.RowIndex].Values["RolId"]);
                ddlRol.SelectedValue = currentRolId.ToString();
            }
        }

        protected void gvKullanicilar_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            lblMesaj.Text = "";

            int kullaniciId = Convert.ToInt32(gvKullanicilar.DataKeys[e.RowIndex].Values["KullaniciId"]);
            GridViewRow row = gvKullanicilar.Rows[e.RowIndex];

            // AktifMi checkbox'ını al
            CheckBox chkAktif = (CheckBox)row.Cells[4].Controls[0];
            bool aktifMi = chkAktif.Checked;

            // === Güvenlik: Admin kendi hesabını PASİF yapamasın ===
            if (Session["KullaniciId"] != null &&
                kullaniciId == Convert.ToInt32(Session["KullaniciId"]) &&
                aktifMi == false) // kendini pasif yapmaya çalışıyorsa
            {
                lblMesaj.Text = "Kendi hesabınızı pasif yapamazsınız.";
                gvKullanicilar.EditIndex = -1;
                KullanicilariYukle();
                return;
            }
            // =====================================================

            // Rol dropdownu
            DropDownList ddlRol = (DropDownList)row.FindControl("ddlRol");
            int yeniRolId = int.Parse(ddlRol.SelectedValue);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(@"
            UPDATE Kullanici
            SET RolId = @RolId,
                AktifMi = @AktifMi
            WHERE KullaniciId = @Id;", conn))
                {
                    cmd.Parameters.AddWithValue("@RolId", yeniRolId);
                    cmd.Parameters.AddWithValue("@AktifMi", aktifMi);
                    cmd.Parameters.AddWithValue("@Id", kullaniciId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                gvKullanicilar.EditIndex = -1;
                KullanicilariYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Kullanıcı rolü / durumu güncellendi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

    }
}
