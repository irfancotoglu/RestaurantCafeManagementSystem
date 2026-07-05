<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Urunler.aspx.cs" Inherits="LokantaCafeWeb.Admin.Urunler" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ürün Yönetimi - Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style type="text/css">
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: radial-gradient(circle at top, #1f2937 0%, #020617 45%, #000 100%);
            color: #e5e7eb;
        }

        .page-shell{
            min-height: 100vh;
            padding: 18px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container{
            width: 1240px;
            max-width: 100%;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .glass{
            border-radius: 18px;
            background: rgba(2, 6, 23, 0.72);
            border: 1px solid rgba(249,115,22,0.22);
            box-shadow: 0 18px 45px rgba(0,0,0,0.55);
            backdrop-filter: blur(10px);
        }

        /* Topbar */
        .topbar{
            padding: 16px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .top-left{
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-wrap{
            width: 46px; height: 46px;
            border-radius: 50%;
            overflow: hidden;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(148,163,184,0.25);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-wrap img{ width: 100%; height: 100%; object-fit: cover; display: block; }

        .title-wrap{ display: flex; flex-direction: column; gap: 2px; }
        .title-main{
            font-size: 18px;
            font-weight: 900;
            color: #f9fafb;
            letter-spacing: 0.02em;
        }
        .title-sub{ font-size: 12px; color: #9ca3af; }

        .admin-info{
            text-align: right;
            font-size: 12px;
            color: #cbd5e1;
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid rgba(249,115,22,0.30);
            background: rgba(249,115,22,0.10);
            white-space: nowrap;
        }

        /* Nav (turuncu) */
        .nav{
            padding: 10px 12px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .nav-link{
            display: inline-flex;
            align-items: center;
            padding: 8px 12px;
            border-radius: 999px;
            text-decoration: none;
            font-size: 13px;
            color: #fde68a;
            background: rgba(249,115,22,0.10);
            border: 1px solid rgba(249,115,22,0.30);
            transition: transform 0.06s ease, background-color 0.15s ease, border-color 0.15s ease;
        }
        .nav-link:hover{
            background: rgba(249,115,22,0.18);
            border-color: rgba(249,115,22,0.55);
            transform: translateY(-1px);
            color: #fff7ed;
        }
        .nav-link-active{
            color: #fff7ed !important;
            background: linear-gradient(135deg, #f97316, #ea580c);
            border-color: rgba(249,115,22,0.75);
            box-shadow: 0 14px 30px rgba(248,113,22,0.22);
        }

        /* Content */
        .content{ padding: 16px 18px 18px 18px; }

        .message-label{
            display: block;
            min-height: 18px;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .panel{
            border-radius: 16px;
            border: 1px solid rgba(249,115,22,0.18);
            background: rgba(15,23,42,0.55);
            padding: 14px 14px;
            margin-bottom: 14px;
        }

        .section-head{
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            gap: 10px;
            margin: 6px 0 10px 0;
        }

        .section-title{
            font-size: 15px;
            font-weight: 800;
            color: #f9fafb;
        }

        .section-subtitle{
            font-size: 12px;
            color: #9ca3af;
            text-align: right;
        }

        .row{
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .label{
            font-size: 12px;
            color: #cbd5e1;
            font-weight: 800;
            letter-spacing: 0.02em;
        }

        .text-input, .select-input{
            padding: 10px 11px;
            border-radius: 12px;
            border: 1px solid rgba(148,163,184,0.25);
            background: rgba(2,6,23,0.65);
            color: #e5e7eb;
            outline: none;
            font-size: 13px;
            transition: box-shadow 0.15s ease, border-color 0.15s ease;
        }

        .text-input:focus, .select-input:focus{
            border-color: rgba(249,115,22,0.75);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.22);
        }

        .btn-primary{
            border: none;
            cursor: pointer;
            padding: 10px 14px;
            border-radius: 12px;
            font-weight: 900;
            font-size: 13px;
            color: #fff7ed;
            background: linear-gradient(135deg, #f97316, #ea580c);
            border: 1px solid rgba(249,115,22,0.55);
            box-shadow: 0 16px 30px rgba(248,113,22,0.18);
            transition: transform 0.06s ease, filter 0.15s ease;
        }

        .btn-primary:hover{ filter: brightness(1.05); transform: translateY(-1px); }
        .btn-primary:active{ transform: translateY(0px) scale(0.98); }

        /* GridView */
        .data-grid{
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 16px;
            border: 1px solid rgba(249,115,22,0.18);
        }

        .data-grid th, .data-grid td{ padding: 10px 10px; font-size: 12px; }

        .data-grid th{
            text-align: left;
            color: #fde68a;
            background: rgba(15, 23, 42, 0.95);
            border-bottom: 1px solid rgba(249,115,22,0.18);
        }

        .data-grid td{
            color: #e5e7eb;
            background: rgba(2, 6, 23, 0.62);
            border-bottom: 1px solid rgba(148,163,184,0.10);
            vertical-align: middle;
        }

        .data-grid tr:hover td{ background: rgba(249,115,22,0.10); }

        .data-grid a{
            color: #fde68a;
            text-decoration: none;
            font-weight: 800;
        }
        .data-grid a:hover{ color: #fff7ed; text-decoration: underline; }

        .thumb{
            width: 68px;
            height: 50px;
            border-radius: 10px;
            border: 1px solid rgba(249,115,22,0.22);
            overflow: hidden;
            background: rgba(255,255,255,0.06);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .thumb img{
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        @media (max-width: 980px){
            .topbar{ flex-direction: column; align-items: flex-start; }
            .admin-info{ text-align: left; }
            .section-subtitle{ text-align: left; }
            .row{ align-items: flex-start; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="page-shell">
        <div class="container">

            <!-- TOPBAR -->
            <div class="glass topbar">
                <div class="top-left">
                    <div class="logo-wrap">
                        <asp:Image ID="imgLogo" runat="server"
                            ImageUrl="~/Content/Images/logo.png"
                            AlternateText="Lokanta Cafe Logo" />
                    </div>
                    <div class="title-wrap">
                        <div class="title-main">Ürün Yönetimi</div>
                        <div class="title-sub">Ürünleri ekleyin, güncelleyin, stok ve görünürlük yönetin.</div>
                    </div>
                </div>
                <div class="admin-info">Admin paneli / Ürünler</div>
                 <!-- ANA EKRAN BUTONU -->
    <asp:HyperLink ID="hlAnaEkran" runat="server"
        NavigateUrl="~/Account/Login.aspx"
        CssClass="btn-home">
        Ana Ekran
    </asp:HyperLink>
            </div>

            <!-- NAV -->
            <div class="glass nav">
                <asp:HyperLink ID="hlDash" runat="server" NavigateUrl="~/Admin/Dashboard.aspx"
                    CssClass="nav-link">Dashboard</asp:HyperLink>

                <asp:HyperLink ID="hlKategoriler" runat="server" NavigateUrl="~/Admin/Kategoriler.aspx"
                    CssClass="nav-link">Kategoriler</asp:HyperLink>

                <asp:HyperLink ID="hlUrunler" runat="server" NavigateUrl="~/Admin/Urunler.aspx"
                    CssClass="nav-link nav-link-active">Ürünler</asp:HyperLink>

                <asp:HyperLink ID="hlAdminMasalar" runat="server" NavigateUrl="~/Admin/Masalar.aspx"
                    CssClass="nav-link">Masalar</asp:HyperLink>

                <asp:HyperLink ID="hlSiparisYonetimi" runat="server" NavigateUrl="~/Admin/SiparisYonetimi.aspx"
                    CssClass="nav-link">Sipariş Yönetimi</asp:HyperLink>

                <asp:HyperLink ID="hlKullanicilar" runat="server" NavigateUrl="~/Admin/Kullanicilar.aspx"
                    CssClass="nav-link">Kullanıcılar</asp:HyperLink>
            </div>

            <!-- CONTENT -->
            <div class="glass content">

                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <!-- Filtre -->
                <div class="panel">
                    <div class="section-head">
                        <div class="section-title">Filtre</div>
                        <div class="section-subtitle">Kategorilere göre filtrele, istersen sadece aktif ürünleri göster.</div>
                    </div>

                    <div class="row">
                        <span class="label">Kategori</span>
                        <asp:DropDownList ID="ddlFiltreKategori" runat="server"
                            CssClass="select-input"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlFiltreKategori_SelectedIndexChanged">
                        </asp:DropDownList>

                        <asp:CheckBox ID="chkSadeceAktif" runat="server"
                            Text="Sadece aktif ürünler"
                            AutoPostBack="true"
                            OnCheckedChanged="chkSadeceAktif_CheckedChanged" />
                    </div>
                </div>

                <!-- Yeni ürün ekle -->
                <div class="panel">
                    <div class="section-head">
                        <div class="section-title">Yeni Ürün Ekle</div>
                        <div class="section-subtitle">Ad, fiyat, stok, açıklama ve resim yolu ile menüye ürün ekleyin.</div>
                    </div>

                    <div class="row" style="margin-bottom:10px;">
                        <span class="label">Kategori</span>
                        <asp:DropDownList ID="ddlYeniKategori" runat="server" CssClass="select-input"></asp:DropDownList>

                        <span class="label">Ürün Adı</span>
                        <asp:TextBox ID="txtYeniUrunAdi" runat="server" CssClass="text-input" Width="260"></asp:TextBox>
                    </div>

                    <div class="row" style="margin-bottom:10px;">
                        <span class="label">Fiyat</span>
                        <asp:TextBox ID="txtYeniFiyat" runat="server" CssClass="text-input" Width="110"></asp:TextBox>

                        <span class="label">Stok</span>
                        <asp:TextBox ID="txtYeniStok" runat="server" CssClass="text-input" Width="110"></asp:TextBox>

                        <span class="label">Resim Yolu</span>
                        <asp:TextBox ID="txtYeniResimYolu" runat="server" CssClass="text-input" Width="320"
                            placeholder="~/Content/Images/urunler/ornek.png"></asp:TextBox>
                    </div>

                    <div class="row">
                        <span class="label">Açıklama</span>
                        <asp:TextBox ID="txtYeniAciklama" runat="server" CssClass="text-input" Width="520"></asp:TextBox>

                        <asp:Button ID="btnYeniUrunEkle" runat="server" Text="Ürünü Ekle"
                            CssClass="btn-primary" OnClick="btnYeniUrunEkle_Click" />
                    </div>
                </div>

                <!-- Ürün listesi -->
                <div class="section-head">
                    <div class="section-title">Kayıtlı Ürünler</div>
                    <div class="section-subtitle">Düzenle / pasif yap / resim yolunu güncelle.</div>
                </div>

                <asp:GridView ID="gvUrunler" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="UrunId,KategoriId"
                    CssClass="data-grid"
                    OnRowEditing="gvUrunler_RowEditing"
                    OnRowCancelingEdit="gvUrunler_RowCancelingEdit"
                    OnRowUpdating="gvUrunler_RowUpdating"
                    OnRowDeleting="gvUrunler_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="UrunId" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="UrunAdi" HeaderText="Ürün Adı" />
                        <asp:BoundField DataField="Fiyat" HeaderText="Fiyat" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="StokMiktari" HeaderText="Stok" />
                        <asp:BoundField DataField="Aciklama" HeaderText="Açıklama" />
                        <asp:CheckBoxField DataField="AktifMi" HeaderText="Aktif" />
                        <asp:BoundField DataField="KategoriAdi" HeaderText="Kategori" ReadOnly="True" />

                        <asp:TemplateField HeaderText="Fotoğraf">
                            <ItemTemplate>
                                <span class="thumb">
                                    <asp:Image ID="imgUrun" runat="server"
                                        ImageUrl='<%# string.IsNullOrEmpty(Convert.ToString(Eval("ResimYolu")))
                                                    ? "~/Content/Images/urun_placeholder.png"
                                                    : Convert.ToString(Eval("ResimYolu")) %>'
                                        AlternateText='<%# Eval("UrunAdi") %>' />
                                </span>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtResimYoluEdit" runat="server"
                                    CssClass="text-input" Width="260"
                                    Text='<%# Bind("ResimYolu") %>' />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                    </Columns>
                </asp:GridView>

            </div>

        </div>
    </div>
</form>
</body>
</html>
