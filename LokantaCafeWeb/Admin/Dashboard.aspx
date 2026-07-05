<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LokantaCafeWeb.Admin.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Paneli - Dashboard</title>
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

        /* Glass kart */
        .glass {
            border-radius: 18px;
            background: rgba(2, 6, 23, 0.72);
            border: 1px solid rgba(148, 163, 184, 0.22);
            box-shadow: 0 18px 45px rgba(0,0,0,0.55);
            backdrop-filter: blur(10px);
        }

        /* Üst bar */
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
            gap: 4px;
            align-items: flex-end;
        }

        .admin-name {
            font-size: 13px;
            color: #e5e7eb;
            font-weight: 700;
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

        /* NAV - TURUNCU */
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

        /* İçerik */
        .content {
            padding: 16px 18px 18px 18px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 14px;
        }

        /* İki kart da TURUNCU */
        .stat-card {
            border-radius: 16px;
            padding: 14px 14px;
            border: 1px solid rgba(249,115,22,0.22);
            box-shadow: 0 18px 35px rgba(0,0,0,0.35);
            background: radial-gradient(circle at top left,
                rgba(249,115,22,0.95) 0%,
                rgba(124,45,18,0.55) 45%,
                rgba(15,23,42,0.92) 85%);
        }

        .stat-title {
            font-size: 11px;
            letter-spacing: 0.10em;
            text-transform: uppercase;
            color: rgba(255,255,255,0.85);
            margin-bottom: 4px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 4px;
        }

        .stat-sub {
            font-size: 12px;
            color: rgba(255,255,255,0.85);
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
            font-weight: 700;
            color: #f9fafb;
        }

        .section-subtitle {
            font-size: 12px;
            color: #9ca3af;
            text-align: right;
        }

        .data-grid {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 14px;
            border: 1px solid rgba(249,115,22,0.18);
        }

        .data-grid th, .data-grid td {
            padding: 9px 10px;
            font-size: 12px;
        }

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
        }

        .data-grid tr:hover td {
            background: rgba(249,115,22,0.10);
        }

        .footer-note {
            margin-top: 10px;
            font-size: 11px;
            color: #6b7280;
        }

        @media (max-width: 980px) {
            .stats { grid-template-columns: 1fr; }
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
                        <div class="brand-title">Yönetici Paneli • Dashboard</div>
                        <div class="brand-sub">Sipariş, ciro ve müşteri özetini buradan takip edebilirsiniz.</div>
                    </div>
                </div>

                <div class="admin-right">
                    <div class="admin-name">
                        <asp:Label ID="lblAdmin" runat="server"></asp:Label>
                    </div>
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
                    CssClass="nav-link nav-link-active">Dashboard</asp:HyperLink>

                <asp:HyperLink ID="hlKategoriler" runat="server" NavigateUrl="~/Admin/Kategoriler.aspx"
                    CssClass="nav-link">Kategoriler</asp:HyperLink>

                <asp:HyperLink ID="hlUrunler" runat="server" NavigateUrl="~/Admin/Urunler.aspx"
                    CssClass="nav-link">Ürünler</asp:HyperLink>

                <asp:HyperLink ID="hlAdminMasalar" runat="server" NavigateUrl="~/Admin/Masalar.aspx"
                    CssClass="nav-link">Masalar</asp:HyperLink>

                <asp:HyperLink ID="hlSiparisYonetimi" runat="server" NavigateUrl="~/Admin/SiparisYonetimi.aspx"
                    CssClass="nav-link">Sipariş Yönetimi</asp:HyperLink>

                <asp:HyperLink ID="hlKullanicilar" runat="server" NavigateUrl="~/Admin/Kullanicilar.aspx"
                    CssClass="nav-link">Kullanıcılar</asp:HyperLink>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <!-- İstatistikler -->
                <div class="stats">
                    <div class="stat-card">
                        <div class="stat-title">Bugünkü Ciro</div>
                        <div class="stat-value">
                            <asp:Label ID="lblGunlukCiro" runat="server"></asp:Label>
                        </div>
                        <div class="stat-sub">
                            <asp:Label ID="lblGunlukDetay" runat="server"></asp:Label>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-title">Bu Ayın Cirosu</div>
                        <div class="stat-value">
                            <asp:Label ID="lblAylikCiro" runat="server"></asp:Label>
                        </div>
                        <div class="stat-sub">
                            <asp:Label ID="lblAylikDetay" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>

                <!-- Müşteriler Tablosu -->
                <div class="section-head">
                    <div class="section-title">En Çok Harcama Yapan Müşteriler</div>
                    <div class="section-subtitle">Toplam ödeme tutarına göre ilk 10 müşteri listelenmektedir.</div>
                </div>

                <asp:GridView ID="gvTopMusteriler" runat="server" AutoGenerateColumns="False"
                    CssClass="data-grid" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="MusteriId" HeaderText="Müşteri ID" />
                        <asp:BoundField DataField="AdSoyad" HeaderText="Ad Soyad" />
                        <asp:BoundField DataField="Email" HeaderText="E-posta" />
                        <asp:BoundField DataField="ToplamSiparis" HeaderText="Sipariş Sayısı" />
                        <asp:BoundField DataField="ToplamOdeme" HeaderText="Toplam Ödeme" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="SonSiparisTarihi" HeaderText="Son Sipariş"
                            DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                    </Columns>
                </asp:GridView>

                <div class="footer-note">
                    Not: Dashboard verileri Odeme, Siparis ve v_MusteriSiparisOzet üzerinden dinamik olarak hesaplanmaktadır.
                    © <%: DateTime.Now.Year %> Lokanta Cafe
                </div>

            </div>

        </div>
    </div>
    </form>
</body>
</html>
