using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Admin
{
    public partial class SiparisYonetimi : System.Web.UI.Page
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
                SiparisleriYukle();
            }
        }

        private void SiparisleriYukle()
        {
            lblMesaj.Text = "";

            int sonK = 50;
            int.TryParse(txtSonKSiparis.Text.Trim(), out sonK);
            if (sonK <= 0) sonK = 50;

            string durumFiltre = ddlDurumFiltre.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP(@TopN)
                        s.SiparisId,
                        s.SiparisTarihi,
                        s.TeslimatTipi,
                        s.Durum,
                        s.ToplamTutar,
                        s.OdendiMi,
                        ISNULL(k.AdSoyad, '') AS MusteriAdi,
                        ISNULL(m.MasaNo, '')  AS MasaNo
                    FROM Siparis s
                    LEFT JOIN Musteri mu ON mu.MusteriId = s.MusteriId
                    LEFT JOIN Kullanici k ON k.KullaniciId = mu.KullaniciId
                    LEFT JOIN Masa m ON m.MasaId = s.MasaId
                    WHERE 1 = 1";

                if (!string.IsNullOrEmpty(durumFiltre))
                {
                    sql += " AND s.Durum = @Durum";
                }

                sql += " ORDER BY s.SiparisTarihi DESC;";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TopN", sonK);
                    if (!string.IsNullOrEmpty(durumFiltre))
                    {
                        cmd.Parameters.AddWithValue("@Durum", durumFiltre);
                    }

                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvSiparisler.DataSource = dt;
                        gvSiparisler.DataBind();
                    }
                }
            }
        }

        protected void btnFiltrele_Click(object sender, EventArgs e)
        {
            gvSiparisler.EditIndex = -1;
            SiparisleriYukle();
        }

        protected void gvSiparisler_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvSiparisler.EditIndex = e.NewEditIndex;
            SiparisleriYukle();
        }

        protected void gvSiparisler_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvSiparisler.EditIndex = -1;
            SiparisleriYukle();
        }

        protected void gvSiparisler_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int siparisId = Convert.ToInt32(gvSiparisler.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvSiparisler.Rows[e.RowIndex];

            var ddlDurumEdit = (DropDownList)row.FindControl("ddlDurumEdit");
            string yeniDurum = ddlDurumEdit.SelectedValue;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_SiparisDurumGuncelle", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SiparisId", siparisId);
                    cmd.Parameters.AddWithValue("@YeniDurum", yeniDurum);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // tr_Siparis_Update_DurumLogla trigger'ı sayesinde
                // SiparisDurumLog tablosuna log düşer.

                gvSiparisler.EditIndex = -1;
                SiparisleriYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Sipariş durumu güncellendi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }
    }
}
