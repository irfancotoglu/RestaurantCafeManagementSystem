<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Kullanicilar.aspx.cs" Inherits="LokantaCafeWeb.Admin.Kullanicilar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Paneli - Kullanıcılar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <style type="text/css">
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            color: #e5e7eb;
            background: radial-gradient(circle at top, #1f2937 0%, #020617 45%, #000 100%);
        }

        .page-shell {
            min-height: 100vh;
            padding: 18px 18px 28px 18px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            width: 1240px;
            max-width: 100%;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        /* Glass */
        .glass {
            border-radius: 18px;
            background: rgba(2, 6, 23, 0.72);
            border: 1px solid rgba(148, 163, 184, 0.22);
            box-shadow: 0 18px 45px rgba(0,0,0,0.55);
            backdrop-filter: blur(10px);
        }

        /* Topbar */
        .topbar {
            padding: 16px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .brand-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-wrap {
            width: 46px; height: 46px;
            border-radius: 50%;
            overflow: hidden;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(148,163,184,0.25);
            display: flex; align-items: center; justify-content: center;
        }

        .logo-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
            display: block;
        }

        .brand-text { display: flex; flex-direction: column; gap: 2px; }

        .brand-title {
            font-size: 18px;
            font-weight: 800;
            color: #f9fafb;
            letter-spacing: 0.02em;
        }

        .brand-sub {
            font-size: 12px;
            color: #9ca3af;
        }

        .admin-right {
            text-align: right;
            display: flex;
            flex-direction: column;
            gap: 6px;
            align-items: flex-end;
        }

        .pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 11px;
            color: #fff7ed;
            background: rgba(249,115,22,0.10);
            border: 1px solid rgba(249,115,22,0.35);
            white-space: nowrap;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 11px;
            color: #fff7ed;
            background: linear-gradient(135deg, #f97316, #ea580c);
            box-shadow: 0 12px 24px rgba(248,113,22,0.22);
            border: 1px solid rgba(249,115,22,0.45);
            white-space: nowrap;
        }

        .badge-dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: #fff7ed;
            box-shadow: 0 0 10px rgba(255,247,237,0.8);
        }

        /* NAV - Dashboard ile aynı */
        .nav {
            padding: 10px 12px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            text-decoration: none;
            font-size: 13px;
            color: #fde68a;
            background: rgba(249,115,22,0.10);
            border: 1px solid rgba(249,115,22,0.30);
            transition: transform 0.06s ease, background-color 0.15s ease, border-color 0.15s ease;
        }

        .nav-link:hover {
            background: rgba(249,115,22,0.18);
            border-color: rgba(249,115,22,0.55);
            transform: translateY(-1px);
            color: #fff7ed;
        }

        .nav-link-active {
            color: #fff7ed !important;
            background: linear-gradient(135deg, #f97316, #ea580c);
            border-color: rgba(249,115,22,0.75);
            box-shadow: 0 14px 30px rgba(248,113,22,0.22);
        }

        /* Content */
        .content { padding: 16px 18px 18px 18px; }

        .message-label {
            display: block;
            min-height: 18px;
            margin-bottom: 10px;
            font-size: 12px;
        }

        .section-head {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            gap: 10px;
            margin: 6px 0 10px 0;
        }

        .section-title {
            font-size: 15px;
            font-weight: 800;
            color: #f9fafb;
        }

        .section-subtitle {
            font-size: 12px;
            color: #9ca3af;
            text-align: right;
        }

        /* GridView - Dashboard ile aynı */
        .data-grid {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 14px;
            border: 1px solid rgba(249,115,22,0.18);
        }

        .data-grid th, .data-grid td { padding: 9px 10px; font-size: 12px; }

        .data-grid th {
            text-align: left;
            color: #fde68a;
            background: rgba(15, 23, 42, 0.95);
            border-bottom: 1px solid rgba(249,115,22,0.18);
        }

        .data-grid td {
            color: #e5e7eb;
            background: rgba(2, 6, 23, 0.65);
            border-bottom: 1px solid rgba(148,163,184,0.10);
            vertical-align: middle;
        }

        .data-grid tr:hover td { background: rgba(249,115,22,0.10); }

        /* ✅ Düzenle/Kaydet/İptal linkleri SARIIII */
        .data-grid td a,
        .data-grid td a:visited {
            color: #fde68a !important;
            font-weight: 900;
            text-decoration: none;
        }
        .data-grid td a:hover {
            color: #fff7ed !important;
            text-decoration: underline;
        }

        /* Edit modundaki input/dropdown koyu tema */
        .data-grid input[type="text"],
        .data-grid select {
            border-radius: 12px;
            border: 1px solid rgba(249,115,22,0.30);
            background: rgba(15, 23, 42, 0.85);
            color: #e5e7eb;
            padding: 7px 9px;
            font-size: 12px;
            outline: none;
        }

        .data-grid input[type="text"]:focus,
        .data-grid select:focus {
            border-color: rgba(249,115,22,0.75);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.18);
        }

        /* Checkbox biraz daha görünür */
        .data-grid input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #f97316;
        }

        .footer-note {
            margin-top: 10px;
            font-size: 11px;
            color: #6b7280;
        }

        @media (max-width: 980px) {
            .admin-right { align-items: flex-start; text-align: left; }
            .topbar { flex-direction: column; align-items: flex-start; }
            .section-head { flex-direction: column; align-items: flex-start; }
            .section-subtitle { text-align: left; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">
    <div class="page-shell">
        <div class="container">

            <!-- ÜST BAR -->
            <div class="glass topbar">
                <div class="brand-left">
                    <div class="logo-wrap">
                        <asp:Image ID="imgLogo" runat="server"
                            ImageUrl="~/Content/Images/logo.png"
                            AlternateText="Lokanta Cafe Logo" />
                    </div>

                    <div class="brand-text">
                        <div class="brand-title">Yönetici Paneli • Kullanıcılar</div>
                        <div class="brand-sub">Kullanıcı rollerini ve aktiflik durumlarını buradan yönetebilirsiniz.</div>
                    </div>
                </div>

                <div class="admin-right">
                    <div class="pill">Admin paneli / Kullanıcılar</div>
                    <div class="badge">
                        <span class="badge-dot"></span>
                        Yönetici olarak giriş yaptınız
                         <!-- ANA EKRAN BUTONU -->
    <asp:HyperLink ID="hlAnaEkran" runat="server"
        NavigateUrl="~/Account/Login.aspx"
        CssClass="btn-home">
        Ana Ekran
    </asp:HyperLink>
                    </div>
                </div>
            </div>

            <!-- NAV -->
            <div class="glass nav">
                <asp:HyperLink ID="hlDash" runat="server" NavigateUrl="~/Admin/Dashboard.aspx"
                    CssClass="nav-link">Dashboard</asp:HyperLink>

                <asp:HyperLink ID="hlKategoriler" runat="server" NavigateUrl="~/Admin/Kategoriler.aspx"
                    CssClass="nav-link">Kategoriler</asp:HyperLink>

                <asp:HyperLink ID="hlUrunler" runat="server" NavigateUrl="~/Admin/Urunler.aspx"
                    CssClass="nav-link">Ürünler</asp:HyperLink>

                <asp:HyperLink ID="hlAdminMasalar" runat="server" NavigateUrl="~/Admin/Masalar.aspx"
                    CssClass="nav-link">Masalar</asp:HyperLink>

                <asp:HyperLink ID="hlSiparisYonetimi" runat="server" NavigateUrl="~/Admin/SiparisYonetimi.aspx"
                    CssClass="nav-link">Sipariş Yönetimi</asp:HyperLink>

                <asp:HyperLink ID="hlKullanicilar" runat="server" NavigateUrl="~/Admin/Kullanicilar.aspx"
                    CssClass="nav-link nav-link-active">Kullanıcılar</asp:HyperLink>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <!-- Mesaj -->
                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <div class="section-head">
                    <div class="section-title">Kayıtlı Kullanıcılar</div>
                    <div class="section-subtitle">
                        Roller (Admin / Garson / Müşteri) ve aktiflik durumları düzenlenebilir.
                    </div>
                </div>

                <asp:GridView ID="gvKullanicilar" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="KullaniciId,RolId"
                    CssClass="data-grid"
                    GridLines="None"
                    OnRowEditing="gvKullanicilar_RowEditing"
                    OnRowCancelingEdit="gvKullanicilar_RowCancelingEdit"
                    OnRowUpdating="gvKullanicilar_RowUpdating"
                    OnRowDataBound="gvKullanicilar_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="KullaniciId" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="AdSoyad" HeaderText="Ad Soyad" ReadOnly="True" />
                        <asp:BoundField DataField="Email" HeaderText="E-posta" ReadOnly="True" />
                        <asp:BoundField DataField="Telefon" HeaderText="Telefon" ReadOnly="True" />
                        <asp:CheckBoxField DataField="AktifMi" HeaderText="Aktif Mi" />

                        <asp:TemplateField HeaderText="Rol">
                            <ItemTemplate>
                                <%# Eval("RolAdi") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlRol" runat="server"></asp:DropDownList>
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField ShowEditButton="True" EditText="Düzenle" UpdateText="Kaydet" CancelText="İptal" />
                    </Columns>
                </asp:GridView>

                <div class="footer-note">
                    © <%: DateTime.Now.Year %> Lokanta Cafe • Kullanıcı Yönetimi
                </div>

            </div>
        </div>
    </div>
</form>
</body>
</html>
