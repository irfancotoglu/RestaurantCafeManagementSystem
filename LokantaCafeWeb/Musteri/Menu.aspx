<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="LokantaCafeWeb.Musteri.Menu" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Menü - Lokanta Cafe</title>
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

        /* Header */
        .topbar {
            padding: 16px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .brand-left {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .title {
            font-size: 18px;
            font-weight: 800;
            color: #f9fafb;
            letter-spacing: 0.02em;
        }

        .subtitle {
            font-size: 12px;
            color: #9ca3af;
        }

        .welcome {
            margin-top: 2px;
            font-size: 12px;
            font-weight: 800;
            color: #fff7ed;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(249,115,22,0.10);
            border: 1px solid rgba(249,115,22,0.35);
            width: fit-content;
        }

        .right-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
            text-align: right;
        }

        .btn-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 900;
            color: #fff7ed !important;
            background: linear-gradient(135deg, #f97316, #ea580c);
            border: 1px solid rgba(249,115,22,0.75);
            box-shadow: 0 14px 30px rgba(248,113,22,0.22);
            transition: transform .06s ease, filter .15s ease;
            white-space: nowrap;
        }

        .btn-pill:hover { filter: brightness(1.06); transform: translateY(-1px); }
        .btn-pill:active { transform: scale(0.98); }

        .cart-label {
            font-size: 12px;
            color: #fde68a;
            font-weight: 800;
        }

        /* Content */
        .content {
            padding: 16px 18px 18px 18px;
        }

        .message-label {
            display: block;
            min-height: 18px;
            margin: 10px 0 8px 0;
            font-size: 12px;
        }

        /* Filter */
        .filter-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .filter-row span {
            font-size: 12px;
            font-weight: 900;
            color: #cbd5e1;
        }

        .select-input {
            box-sizing: border-box;
            padding: 10px 11px;
            border-radius: 12px;
            border: 1px solid rgba(148,163,184,0.22);
            background: rgba(2,6,23,0.70);
            color: #e5e7eb;
            font-size: 13px;
            outline: none;
            min-width: 180px;
            transition: box-shadow .15s ease, border-color .15s ease;
        }

        .select-input:focus {
            border-color: rgba(249,115,22,0.85);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.22);
        }

        /* Product list */
        .product-list {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-top: 12px;
        }

        .product-card {
            border-radius: 16px;
            background: rgba(15,23,42,0.60);
            border: 1px solid rgba(249,115,22,0.18);
            box-shadow: 0 16px 30px rgba(0,0,0,0.35);
            overflow: hidden;
            display: grid;
            grid-template-columns: 160px 1fr;
            min-height: 140px;
        }

        .product-image {
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.06);
            border-right: 1px solid rgba(249,115,22,0.12);
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .product-body {
            padding: 12px 12px 12px 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .product-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 10px;
        }

        .product-name {
            font-size: 14px;
            font-weight: 900;
            color: #f9fafb;
            line-height: 1.2;
        }

        .product-price {
            font-size: 13px;
            font-weight: 900;
            color: #fde68a;
            white-space: nowrap;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(249,115,22,0.10);
            border: 1px solid rgba(249,115,22,0.25);
        }

        .product-desc {
            font-size: 12px;
            color: #9ca3af;
            line-height: 1.35;
        }

        .product-actions {
            margin-top: auto;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding-top: 6px;
            border-top: 1px solid rgba(148,163,184,0.12);
        }

        .qty-row {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: #cbd5e1;
            font-weight: 900;
        }

        .qty-input {
            box-sizing: border-box;
            padding: 10px 11px;
            border-radius: 12px;
            border: 1px solid rgba(148,163,184,0.22);
            background: rgba(2,6,23,0.70);
            color: #e5e7eb;
            font-size: 13px;
            outline: none;
            width: 90px;
            text-align: center;
            transition: box-shadow .15s ease, border-color .15s ease;
        }

        .qty-input:focus {
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

        @media (max-width: 980px) {
            .topbar { flex-direction: column; align-items: flex-start; }
            .right-actions { align-items: flex-start; text-align: left; }
            .product-list { grid-template-columns: 1fr; }
            .product-card { grid-template-columns: 1fr; }
            .product-image { height: 180px; border-right: none; border-bottom: 1px solid rgba(249,115,22,0.12); }
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
                    <div class="title">Menü</div>
                    <div class="subtitle">Buradan ürünleri seçip sepetinize ekleyebilirsiniz.</div>
                    <asp:Label ID="lblHosgeldin" runat="server" CssClass="welcome"></asp:Label>
                </div>

                <div class="right-actions">
                    <asp:HyperLink ID="hlSepet" runat="server"
                        NavigateUrl="~/Musteri/Sepet.aspx"
                        CssClass="btn-pill">
                        Sepetimi Gör
                    </asp:HyperLink>

                    <asp:Label ID="lblSepetOzet" runat="server" CssClass="cart-label"></asp:Label>
                </div>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <!-- Kategori filtresi -->
                <div class="filter-row">
                    <span>Kategori:</span>
                    <asp:DropDownList ID="ddlKategori" runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlKategori_SelectedIndexChanged"
                        CssClass="select-input">
                    </asp:DropDownList>
                </div>

                <!-- Mesaj -->
                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <!-- Ürün listesi -->
                <div class="product-list">
                    <asp:Repeater ID="rptUrunler" runat="server" OnItemCommand="rptUrunler_ItemCommand">
                        <ItemTemplate>
                            <div class="product-card">

                                <div class="product-image">
                                    <asp:Image ID="imgUrun" runat="server"
                                        ImageUrl="~/Content/Images/urun_placeholder.png"
                                        AlternateText='<%# Eval("UrunAdi") %>' />
                                </div>

                                <div class="product-body">
                                    <div class="product-top">
                                        <div class="product-name"><%# Eval("UrunAdi") %></div>
                                        <div class="product-price">
                                            <%# String.Format("{0:C}", Eval("Fiyat")) %>
                                        </div>
                                    </div>

                                    <div class="product-desc">
                                        <%# Eval("Aciklama") %>
                                    </div>

                                    <div class="product-actions">
                                        <div class="qty-row">
                                            Adet:
                                            <asp:TextBox ID="txtAdet" runat="server"
                                                CssClass="qty-input" Text="1"></asp:TextBox>
                                        </div>

                                        <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle"
                                            CssClass="btn-primary"
                                            CommandName="SepeteEkle"
                                            CommandArgument='<%# Eval("UrunId") %>' />
                                    </div>
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

            </div>

        </div>
    </div>
</form>
</body>
</html>
