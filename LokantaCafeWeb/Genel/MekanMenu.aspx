<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MekanMenu.aspx.cs" Inherits="LokantaCafeWeb.Genel.MekanMenu" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mekan Menüsü - Sadece Görüntüleme</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <style type="text/css">
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body{
            font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height:100vh;
            color:#e5e7eb;
            background: radial-gradient(circle at top, #1f2937 0%, #020617 45%, #000 100%);
        }

        .page-shell{
            min-height:100vh;
            padding:18px 18px 28px 18px;
            display:flex;
            justify-content:center;
            align-items:flex-start;
        }

        .container{
            width:1240px;
            max-width:100%;
            display:flex;
            flex-direction:column;
            gap:14px;
        }

        /* Glass */
        .glass{
            border-radius:18px;
            background: rgba(2,6,23,0.72);
            border:1px solid rgba(148,163,184,0.22);
            box-shadow:0 18px 45px rgba(0,0,0,0.55);
            backdrop-filter: blur(10px);
        }

        /* Topbar */
        .topbar{
            padding:16px 18px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
        }

        .brand{
            display:flex;
            flex-direction:column;
            gap:4px;
        }

        .title{
            font-size:18px;
            font-weight:800;
            color:#f9fafb;
            letter-spacing:0.02em;
        }

        .subtitle{
            font-size:12px;
            color:#9ca3af;
            max-width: 760px;
        }

        .badge{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding:6px 10px;
            border-radius:999px;
            font-size:11px;
            font-weight:900;
            color:#fff7ed;
            background: rgba(249,115,22,0.10);
            border:1px solid rgba(249,115,22,0.35);
            white-space:nowrap;
        }

        .badge-dot{
            width:8px; height:8px;
            border-radius:50%;
            background:#fff7ed;
            box-shadow:0 0 10px rgba(255,247,237,0.6);
        }

        /* Content */
        .content{
            padding:16px 18px 18px 18px;
        }

        /* Info box (amber) */
        .info-box{
            border-radius:16px;
            padding:12px 12px;
            margin-bottom:12px;
            background: rgba(245, 158, 11, 0.14);
            border: 1px solid rgba(245, 158, 11, 0.35);
            color:#fff7ed;
            font-size:13px;
        }
        .info-box strong{ color:#fde68a; }

        /* Filter row */
        .filter-row{
            display:flex;
            flex-wrap:wrap;
            gap:10px;
            align-items:center;
            margin-bottom:10px;
            font-size:13px;
        }
        .filter-row span{
            font-weight:900;
            color:#cbd5e1;
        }

        .select-input{
            box-sizing:border-box;
            padding:10px 11px;
            border-radius:12px;
            border:1px solid rgba(148,163,184,0.22);
            background: rgba(2,6,23,0.70);
            color:#e5e7eb;
            font-size:13px;
            outline:none;
            min-width:200px;
            transition: box-shadow .15s ease, border-color .15s ease;
        }
        .select-input:focus{
            border-color: rgba(249,115,22,0.85);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.22);
        }

        .message-label{
            display:block;
            min-height:18px;
            margin:8px 0 10px 0;
            font-size:12px;
        }

        /* Product list */
        .product-list{
            display:flex;
            flex-direction:column;
            gap:12px;
            margin-top:4px;
        }

        .product-card{
            display:grid;
            grid-template-columns: 130px 1fr;
            gap:12px;
            padding:12px;
            border-radius:16px;
            background: rgba(15,23,42,0.60);
            border:1px solid rgba(249,115,22,0.18);
            box-shadow:0 14px 30px rgba(0,0,0,0.35);
            transition: transform .06s ease, border-color .15s ease, background-color .15s ease;
        }

        .product-card:hover{
            transform: translateY(-1px);
            border-color: rgba(249,115,22,0.45);
            background: rgba(249,115,22,0.08);
        }

        .product-image{
            width:130px;
            height:100px;
            border-radius:14px;
            overflow:hidden;
            background: rgba(255,255,255,0.06);
            border:1px solid rgba(148,163,184,0.18);
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .product-image img{
            width:100%;
            height:100%;
            object-fit:cover;
            display:block;
        }

        .product-info{
            display:flex;
            flex-direction:column;
            justify-content:center;
            gap:6px;
        }

        .product-name-row{
            display:flex;
            justify-content:space-between;
            align-items:baseline;
            gap:10px;
        }

        .product-name{
            font-size:15px;
            font-weight:900;
            color:#fff7ed;
        }

        .product-price{
            font-size:14px;
            font-weight:900;
            color:#fde68a;
            white-space:nowrap;
        }

        .product-desc{
            font-size:13px;
            color:#9ca3af;
            line-height:1.35;
        }

        @media (max-width: 900px){
            .topbar{ flex-direction:column; align-items:flex-start; }
            .product-card{ grid-template-columns: 1fr; }
            .product-image{ width:100%; height:170px; }
            .select-input{ min-width: 100%; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">
    <div class="page-shell">
        <div class="container">

            <!-- ÜST BAR -->
            <div class="glass topbar">
                <div class="brand">
                    <div class="title">Mekan Menüsü</div>
                    <div class="subtitle">
                        Bu ekran sadece menüyü görüntülemek içindir. Sipariş vermek için lütfen garsona söyleyiniz.
                    </div>
                </div>

                <div class="badge">
                    <span class="badge-dot"></span>
                    Sadece görüntüleme modu
                </div>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <!-- Bilgilendirme kutusu -->
                <div class="info-box">
                    <strong>Bilgilendirme:</strong>
                    Menüyü inceleyip tercihlerinizi garsona iletebilirsiniz. Bu ekrandan doğrudan sipariş verilemez.
                </div>

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
                    <asp:Repeater ID="rptUrunler" runat="server">
                        <ItemTemplate>
                            <div class="product-card">
                                <div class="product-image">
                                    <asp:Image ID="imgUrun" runat="server"
                                        AlternateText='<%# Eval("UrunAdi") %>'
                                        ImageUrl='<%# string.IsNullOrEmpty(Convert.ToString(Eval("ResimYolu")))
                                                ? "~/Content/Images/indir.jpg"
                                                : Convert.ToString(Eval("ResimYolu")) %>' />
                                </div>

                                <div class="product-info">
                                    <div class="product-name-row">
                                        <div class="product-name"><%# Eval("UrunAdi") %></div>
                                        <div class="product-price">
                                            <%# String.Format("{0:C}", Eval("Fiyat")) %>
                                        </div>
                                    </div>

                                    <div class="product-desc">
                                        <%# Eval("Aciklama") %>
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
