using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace LokantaCafeWeb.Admin
{
    public partial class Urunler : System.Web.UI.Page
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
                UrunleriYukle();
            }
        }

        private void KategorileriYukle()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT KategoriId, KategoriAdi FROM Kategori WHERE AktifMi = 1 ORDER BY KategoriAdi", conn))
            {
                conn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlFiltreKategori.Items.Clear();
                    ddlFiltreKategori.Items.Add(new ListItem("Tüm Kategoriler", "0"));

                    ddlYeniKategori.Items.Clear();

                    while (dr.Read())
                    {
                        string adi = dr["KategoriAdi"].ToString();
                        string id = dr["KategoriId"].ToString();

                        ddlFiltreKategori.Items.Add(new ListItem(adi, id));
                        ddlYeniKategori.Items.Add(new ListItem(adi, id));
                    }
                }
            }
        }

        private void UrunleriYukle()
        {
            int kategoriFiltre;
            if (!int.TryParse(ddlFiltreKategori.SelectedValue, out kategoriFiltre))
                kategoriFiltre = 0;

            bool sadeceAktif = chkSadeceAktif.Checked;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Temel SELECT
                string sql = @"
SELECT 
    u.UrunId,
    u.UrunAdi,
    u.Fiyat,
    u.StokMiktari,
    u.Aciklama,
    u.AktifMi,
    u.KategoriId,
    u.ResimYolu,
    k.KategoriAdi
FROM Urun u
INNER JOIN Kategori k ON u.KategoriId = k.KategoriId
WHERE 1 = 1";

                // Dinamik filtreler
                if (kategoriFiltre > 0)
                {
                    sql += " AND u.KategoriId = @KategoriId";
                }

                if (sadeceAktif)
                {
                    sql += " AND u.AktifMi = 1";
                }

                // Sıralama
                sql += " ORDER BY k.KategoriAdi, u.UrunAdi;";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (kategoriFiltre > 0)
                    {
                        cmd.Parameters.AddWithValue("@KategoriId", kategoriFiltre);
                    }

                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvUrunler.DataSource = dt;
                        gvUrunler.DataBind();
                    }
                }
            }
        }

        protected void ddlFiltreKategori_SelectedIndexChanged(object sender, EventArgs e)
        {
            UrunleriYukle();
        }

        protected void chkSadeceAktif_CheckedChanged(object sender, EventArgs e)
        {
            UrunleriYukle();
        }

        protected void btnYeniUrunEkle_Click(object sender, EventArgs e)
        {
            lblMesaj.Text = "";
            int kategoriId = int.Parse(ddlYeniKategori.SelectedValue);
            string urunAdi = txtYeniUrunAdi.Text.Trim();
            string aciklama = txtYeniAciklama.Text.Trim();
            string resimYolu = string.IsNullOrWhiteSpace(txtYeniResimYolu.Text)
                ? null
                : txtYeniResimYolu.Text.Trim();

            decimal fiyat;
            int stok;

            if (string.IsNullOrWhiteSpace(urunAdi))
            {
                lblMesaj.Text = "Ürün adı boş olamaz.";
                return;
            }
            if (!decimal.TryParse(txtYeniFiyat.Text.Trim(), out fiyat) || fiyat <= 0)
            {
                lblMesaj.Text = "Geçerli bir fiyat giriniz.";
                return;
            }
            if (!int.TryParse(txtYeniStok.Text.Trim(), out stok) || stok < 0)
            {
                lblMesaj.Text = "Geçerli bir stok miktarı giriniz.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_UrunEkle", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@KategoriId", kategoriId);
                    cmd.Parameters.AddWithValue("@UrunAdi", urunAdi);
                    cmd.Parameters.AddWithValue("@Fiyat", fiyat);
                    cmd.Parameters.AddWithValue("@StokMiktari", stok);
                    cmd.Parameters.AddWithValue("@Aciklama",
                        string.IsNullOrWhiteSpace(aciklama) ? (object)DBNull.Value : aciklama);
                    cmd.Parameters.AddWithValue("@ResimYolu",
                        string.IsNullOrWhiteSpace(resimYolu) ? (object)DBNull.Value : resimYolu);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Formu temizle
                txtYeniUrunAdi.Text = "";
                txtYeniAciklama.Text = "";
                txtYeniFiyat.Text = "";
                txtYeniStok.Text = "";
                txtYeniResimYolu.Text = "";

                UrunleriYukle();
                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Ürün eklendi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

        protected void gvUrunler_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvUrunler.EditIndex = e.NewEditIndex;
            UrunleriYukle();
        }

        protected void gvUrunler_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvUrunler.EditIndex = -1;
            UrunleriYukle();
        }

        protected void gvUrunler_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            lblMesaj.Text = "";

            int urunId = Convert.ToInt32(gvUrunler.DataKeys[e.RowIndex].Values["UrunId"]);
            int kategoriId = Convert.ToInt32(gvUrunler.DataKeys[e.RowIndex].Values["KategoriId"]);
            GridViewRow row = gvUrunler.Rows[e.RowIndex];

            string urunAdi = ((TextBox)row.Cells[1].Controls[0]).Text;
            string fStr = ((TextBox)row.Cells[2].Controls[0]).Text;
            string stokStr = ((TextBox)row.Cells[3].Controls[0]).Text;
            string aciklama = ((TextBox)row.Cells[4].Controls[0]).Text;
            bool aktifMi = ((CheckBox)row.Cells[5].Controls[0]).Checked;
            TextBox txtResimYoluEdit = (TextBox)row.FindControl("txtResimYoluEdit");
            string resimYolu = txtResimYoluEdit != null ? txtResimYoluEdit.Text.Trim() : null;

            decimal fiyat;
            int stok;

            if (!decimal.TryParse(fStr, out fiyat) || fiyat <= 0)
            {
                lblMesaj.Text = "Geçerli bir fiyat giriniz.";
                return;
            }
            if (!int.TryParse(stokStr, out stok) || stok < 0)
            {
                lblMesaj.Text = "Geçerli bir stok giriniz.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_UrunGuncelle", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UrunId", urunId);
                    cmd.Parameters.AddWithValue("@KategoriId", kategoriId);
                    cmd.Parameters.AddWithValue("@UrunAdi", urunAdi);
                    cmd.Parameters.AddWithValue("@Fiyat", fiyat);
                    cmd.Parameters.AddWithValue("@StokMiktari", stok);
                    cmd.Parameters.AddWithValue("@Aciklama",
                        string.IsNullOrWhiteSpace(aciklama) ? (object)DBNull.Value : aciklama);
                    cmd.Parameters.AddWithValue("@ResimYolu",
                        string.IsNullOrWhiteSpace(resimYolu) ? (object)DBNull.Value : resimYolu);
                    cmd.Parameters.AddWithValue("@AktifMi", aktifMi);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                gvUrunler.EditIndex = -1;
                UrunleriYukle();

                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Ürün güncellendi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }

        protected void gvUrunler_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            lblMesaj.Text = "";

            int urunId = Convert.ToInt32(gvUrunler.DataKeys[e.RowIndex].Values["UrunId"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Urun WHERE UrunId = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", urunId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // tr_Urun_InsteadOfDelete trigger'ı sayesinde:
                // - SiparisDetay'a bağlı ürünler için: yalnızca AktifMi = 0
                // - Bağlı olmayanlar gerçekten silinir.

                UrunleriYukle();
                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Ürün silindi / pasif hale getirildi.";
            }
            catch (Exception ex)
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Hata: " + ex.Message;
            }
        }
    }
}
