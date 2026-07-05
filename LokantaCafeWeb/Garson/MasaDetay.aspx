<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MasaDetay.aspx.cs" Inherits="LokantaCafeWeb.Garson.MasaDetay" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Masa Detayı - Garson Paneli</title>
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

        .right-stack {
            display: flex;
            flex-direction: column;
            gap: 8px;
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

        /* Content */
        .content {
            padding: 16px 18px 18px 18px;
        }

        .message-label {
            display: block;
            min-height: 18px;
            margin-bottom: 10px;
            font-size: 12px;
        }

        /* Section cards */
        .section-card {
            border-radius: 16px;
            background: rgba(15,23,42,0.60);
            border: 1px solid rgba(249,115,22,0.18);
            padding: 14px;
            margin-bottom: 14px;
        }

        .section-head {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 10px;
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

        .total-label {
            display: inline-block;
            margin-top: 8px;
            font-size: 14px;
            font-weight: 900;
            color: #fff7ed;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(249,115,22,0.10);
            border: 1px solid rgba(249,115,22,0.28);
        }

        /* Inputs */
        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .form-row label {
            font-size: 12px;
            font-weight: 800;
            color: #cbd5e1;
        }

        .text-input, .select-input {
            box-sizing: border-box;
            padding: 10px 11px;
            border-radius: 12px;
            border: 1px solid rgba(148,163,184,0.22);
            background: rgba(2,6,23,0.70);
            color: #e5e7eb;
            font-size: 13px;
            outline: none;
            transition: box-shadow .15s ease, border-color .15s ease, filter .15s ease;
        }

        .text-input:focus, .select-input:focus {
            border-color: rgba(249,115,22,0.85);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.22);
        }

        .btn-primary {
            background: linear-gradient(135deg, #f97316, #ea580c);
            border: 1px solid rgba(249,115,22,0.55);
            color: #fff7ed;
            padding: 10px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 900;
            cursor: pointer;
            box-shadow: 0 16px 30px rgba(248,113,22,0.16);
            transition: transform .06s ease, filter .15s ease;
        }

        .btn-primary:hover { filter: brightness(1.06); transform: translateY(-1px); }
        .btn-primary:active { transform: scale(0.98); }

        /* GridView */
        .data-grid {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 14px;
            border: 1px solid rgba(249,115,22,0.18);
            margin-top: 10px;
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
        }

        .data-grid tr:hover td {
            background: rgba(249,115,22,0.10);
        }

        /* Links = sarı */
        .link-inline, .link-inline:visited {
            font-size: 13px;
            text-decoration: none;
            color: #fde68a;
            font-weight: 900;
        }

        .link-inline:hover {
            color: #fff7ed;
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
                        <div class="brand-title">Garson Paneli • Masa Detayı</div>
                        <div class="brand-sub">Aktif sipariş, ürün ekleme ve ödeme işlemlerini buradan yönetebilirsiniz.</div>
                    </div>
                </div>

                <div class="right-stack">
                    <div class="pill">
                        Masa:
                        <asp:Label ID="lblMasaNo" runat="server" />
                    </div>

                    <div class="badge">
                        <span class="badge-dot"></span>
                        Durum:
                        <asp:Label ID="lblMasaDurum" runat="server" />
                    </div>
                </div>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <!-- Mesaj -->
                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <!-- Aktif sipariş bilgisi -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-title">Aktif Sipariş Bilgisi</div>
                        <div class="section-subtitle">Bu masaya ait açık sipariş ve eklenen ürünler listelenir.</div>
                    </div>

                    <asp:Label ID="lblSiparisBilgi" runat="server"></asp:Label><br />
                    <asp:Label ID="lblToplamTutar" runat="server" CssClass="total-label"></asp:Label>

                    <asp:GridView ID="gvSiparisDetay" runat="server" AutoGenerateColumns="False"
                        CssClass="data-grid"
                        GridLines="None"
                        EmptyDataText="Bu masaya ait aktif sipariş bulunmamaktadır.">
                        <Columns>
                            <asp:BoundField DataField="UrunAdi" HeaderText="Ürün" />
                            <asp:BoundField DataField="Adet" HeaderText="Adet" />
                            <asp:BoundField DataField="BirimFiyat" HeaderText="Birim Fiyat" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="Tutar" HeaderText="Tutar" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>

                    <asp:HiddenField ID="hfSiparisId" runat="server" />
                </div>

                <!-- Ürün ekleme -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-title">Ürün Ekle</div>
                        <div class="section-subtitle">Menüden ürün seçip adet belirleyerek aktif siparişe ekleyin.</div>
                    </div>

                    <div class="form-row">
                        <label for="ddlUrunler">Ürün:</label>
                        <asp:DropDownList ID="ddlUrunler" runat="server" CssClass="select-input"></asp:DropDownList>

                        <label for="txtAdet">Adet:</label>
                        <asp:TextBox ID="txtAdet" runat="server" CssClass="text-input" Width="80" Text="1"></asp:TextBox>

                        <asp:Button ID="btnUrunEkle" runat="server" Text="Ekle"
                            CssClass="btn-primary" OnClick="btnUrunEkle_Click" />
                    </div>
                </div>

                <!-- Ödeme -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-title">Ödeme</div>
                        <div class="section-subtitle">Ödeme sonrası masa “Boş” olur ve yeni müşteri için hazır hale gelir.</div>
                    </div>

                    <div class="form-row" style="margin-bottom:10px;">
                        <label for="txtOdemeAciklama">Açıklama:</label>
                        <asp:TextBox ID="txtOdemeAciklama" runat="server" CssClass="text-input" Width="360"></asp:TextBox>

                        <label for="ddlOdemeTipi">Ödeme Tipi:</label>
                        <asp:DropDownList ID="ddlOdemeTipi" runat="server" CssClass="select-input">
                            <asp:ListItem Text="Nakit" Value="Nakit"></asp:ListItem>
                            <asp:ListItem Text="Kart" Value="Kart"></asp:ListItem>
                        </asp:DropDownList>

                        <asp:Button ID="btnOdemeAl" runat="server" Text="Ödemeyi Al"
                            CssClass="btn-primary" OnClick="btnOdemeAl_Click" />
                    </div>

                    <div class="form-row">
                        <asp:HyperLink ID="hlMasalaraDon" runat="server"
                            NavigateUrl="~/Garson/Masalar.aspx"
                            CssClass="link-inline">
                            Masalara Dön
                        </asp:HyperLink>
                    </div>
                </div>

            </div>

        </div>
    </div>
</form>
</body>
</html>
