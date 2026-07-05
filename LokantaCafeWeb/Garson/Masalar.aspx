<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Masalar.aspx.cs" Inherits="LokantaCafeWeb.Garson.Masalar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Masalar - Garson Paneli</title>
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

        .glass {
            border-radius: 18px;
            background: rgba(2, 6, 23, 0.72);
            border: 1px solid rgba(148, 163, 184, 0.22);
            box-shadow: 0 18px 45px rgba(0,0,0,0.55);
            backdrop-filter: blur(10px);
        }

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

        .right-stack {
            display: flex;
            flex-direction: column;
            gap: 6px;
            align-items: flex-end;
            text-align: right;
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

        .content {
            padding: 16px 18px 18px 18px;
        }

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

        .data-grid {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 14px;
            border: 1px solid rgba(249,115,22,0.18);
        }

        .data-grid th, .data-grid td {
            padding: 10px 10px;
            font-size: 12px;
            text-align: left;
        }

        .data-grid th {
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

        .data-grid tr:hover td {
            background: rgba(249,115,22,0.10);
        }

        /* Detay linki sarı */
        .link-detay,
        .data-grid td a,
        .data-grid td a:visited {
            color: #fde68a !important;
            text-decoration: none;
            font-weight: 900;
        }

        .data-grid td a:hover {
            color: #fff7ed !important;
            text-decoration: underline;
        }

        @media (max-width: 980px) {
            .right-stack { align-items: flex-start; text-align: left; }
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
                        <div class="brand-title">Garson Paneli • Masalar</div>
                        <div class="brand-sub">Masaların durumunu görüntüleyin ve detay ekranına geçerek siparişleri yönetin.</div>
                    </div>
                </div>

                <div class="right-stack">
                    <div class="pill">Garson Paneli / Masalar</div>
                    <div class="badge">
                        <span class="badge-dot"></span>
                        Aktif oturum
                    </div>
                </div>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <div class="section-head">
                    <div class="section-title">Masa Listesi</div>
                    <div class="section-subtitle">“Detay” ile masanın sipariş ekranına geçebilirsiniz.</div>
                </div>

                <!-- ✅ RowDataBound kaldırıldı -->
                <asp:GridView ID="gvMasalar" runat="server" AutoGenerateColumns="False"
                    CssClass="data-grid"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="MasaId" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="MasaNo" HeaderText="Masa" />
                        <asp:BoundField DataField="Durum" HeaderText="Durum" />
                        <asp:HyperLinkField Text="Detay"
                            DataNavigateUrlFields="MasaId"
                            DataNavigateUrlFormatString="MasaDetay.aspx?masaId={0}"
                            ControlStyle-CssClass="link-detay" />
                    </Columns>
                </asp:GridView>

            </div>

        </div>
    </div>
</form>
</body>
</html>
