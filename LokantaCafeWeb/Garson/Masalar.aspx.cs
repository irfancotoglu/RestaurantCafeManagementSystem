using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Garson
{
    public partial class Masalar : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["LokantaDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MasalariYukle();
            }
        }

        private void MasalariYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SELECT MasaId, MasaNo, Durum FROM Masa ORDER BY MasaNo", conn))
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

        protected void gvMasalar_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string durum = e.Row.Cells[2].Text; // 0: MasaId, 1: MasaNo, 2: Durum

                // Basit renk kodlama
                if (durum == "Bos")
                    e.Row.BackColor = System.Drawing.Color.LightGreen;
                else if (durum == "Dolu")
                    e.Row.BackColor = System.Drawing.Color.LightCoral;
                else if (durum == "Rezerve")
                    e.Row.BackColor = System.Drawing.Color.Khaki;
                else if (durum == "HesapIstiyor")
                    e.Row.BackColor = System.Drawing.Color.Orange;
            }
        }
    }
}
