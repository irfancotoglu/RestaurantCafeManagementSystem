<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Sepet.aspx.cs" Inherits="LokantaCafeWeb.Musteri.Sepet" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sepetim - Lokanta Cafe</title>
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

        .left{
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
        }

        .welcome{
            margin-top:2px;
            font-size:12px;
            font-weight:800;
            color:#fff7ed;
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding:6px 10px;
            border-radius:999px;
            background: rgba(249,115,22,0.10);
            border:1px solid rgba(249,115,22,0.35);
            width:fit-content;
        }

        .right{
            display:flex;
            flex-direction:column;
            gap:8px;
            align-items:flex-end;
            text-align:right;
        }

        .btn-pill{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding:8px 12px;
            border-radius:999px;
            text-decoration:none;
            font-size:13px;
            font-weight:900;
            color:#fff7ed !important;
            background: linear-gradient(135deg, #f97316, #ea580c);
            border:1px solid rgba(249,115,22,0.75);
            box-shadow:0 14px 30px rgba(248,113,22,0.22);
            transition: transform .06s ease, filter .15s ease;
            white-space:nowrap;
        }

        .btn-pill:hover{ filter:brightness(1.06); transform: translateY(-1px); }
        .btn-pill:active{ transform: scale(0.98); }

        .meta{
            font-size:12px;
            color:#9ca3af;
        }

        /* Content */
        .content{
            padding:16px 18px 18px 18px;
        }

        .message-label{
            display:block;
            min-height:18px;
            margin:10px 0 8px 0;
            font-size:12px;
        }

        /* Table (dark) */
        .data-grid{
            width:100%;
            border-collapse:collapse;
            overflow:hidden;
            border-radius:16px;
            border:1px solid rgba(249,115,22,0.18);
            margin-top:8px;
        }

        .data-grid th, .data-grid td{
            padding:10px;
            font-size:12px;
            text-align:left;
        }

        .data-grid th{
            background: rgba(15,23,42,0.95);
            color:#fde68a;
            border-bottom:1px solid rgba(249,115,22,0.18);
        }

        .data-grid td{
            background: rgba(2,6,23,0.65);
            color:#e5e7eb;
            border-bottom:1px solid rgba(148,163,184,0.10);
        }

        .data-grid tr:hover td{
            background: rgba(249,115,22,0.10);
        }

        /* Total badge */
        .total{
            margin-top:10px;
            display:flex;
            justify-content:flex-end;
        }

        .total-badge{
            display:inline-flex;
            align-items:center;
            gap:10px;
            padding:10px 12px;
            border-radius:999px;
            font-size:12px;
            font-weight:900;
            color:#fff7ed;
            background: rgba(249,115,22,0.10);
            border:1px solid rgba(249,115,22,0.30);
        }

        .total-badge strong{
            color:#fde68a;
            font-size:13px;
        }

        /* Sections */
        .section-card{
            margin-top:14px;
            border-radius:16px;
            background: rgba(15,23,42,0.60);
            border:1px solid rgba(249,115,22,0.18);
            padding:14px;
        }

        .section-head{
            display:flex;
            align-items:baseline;
            justify-content:space-between;
            gap:10px;
            margin-bottom:10px;
        }

        .section-title{
            font-size:15px;
            font-weight:800;
            color:#fff7ed;
        }

        .section-sub{
            font-size:12px;
            color:#9ca3af;
            text-align:right;
        }

        .form-grid{
            display:grid;
            grid-template-columns: 160px 1fr;
            gap:10px 12px;
            align-items:center;
        }

        .label{
            font-size:12px;
            font-weight:900;
            color:#cbd5e1;
        }

        .text-input, .text-area{
            width:100%;
            box-sizing:border-box;
            padding:10px 11px;
            border-radius:12px;
            border:1px solid rgba(148,163,184,0.22);
            background: rgba(2,6,23,0.70);
            color:#e5e7eb;
            font-size:13px;
            outline:none;
            transition: box-shadow .15s ease, border-color .15s ease;
        }

        .text-area{ resize: vertical; min-height: 92px; }

        .text-input:focus, .text-area:focus{
            border-color: rgba(249,115,22,0.85);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.22);
        }

        /* Buttons */
        .actions{
            margin-top:14px;
            display:flex;
            flex-wrap:wrap;
            gap:10px;
            align-items:center;
        }

        .btn-primary{
            background: linear-gradient(135deg, #f97316, #ea580c);
            border:1px solid rgba(249,115,22,0.55);
            color:#fff7ed;
            padding:10px 14px;
            border-radius:12px;
            font-size:13px;
            font-weight:900;
            cursor:pointer;
            box-shadow:0 16px 30px rgba(248,113,22,0.16);
            transition: transform .06s ease, filter .15s ease;
        }
        .btn-primary:hover{ filter:brightness(1.06); transform: translateY(-1px); }
        .btn-primary:active{ transform: scale(0.98); }

        /* ✅ Sil = Sarı */
        .btn-delete{
            background: rgba(245, 158, 11, 0.15); /* amber glass */
            border: 1px solid rgba(245, 158, 11, 0.55);
            color: #fde68a;
            padding: 8px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 900;
            cursor: pointer;
            transition: transform .06s ease, filter .15s ease, background-color .15s ease, border-color .15s ease;
        }
        .btn-delete:hover{
            background: rgba(245, 158, 11, 0.22);
            border-color: rgba(245, 158, 11, 0.75);
            filter: brightness(1.04);
            transform: translateY(-1px);
        }
        .btn-delete:active{ transform: scale(0.98); }

        .link-inline{
            font-size:13px;
            text-decoration:none;
            color:#fdba74;
            font-weight:900;
        }
        .link-inline:hover{
            color:#fff7ed;
            text-decoration:underline;
        }

        @media (max-width: 980px){
            .topbar{ flex-direction:column; align-items:flex-start; }
            .right{ align-items:flex-start; text-align:left; }
            .form-grid{ grid-template-columns: 1fr; }
            .section-sub{ text-align:left; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">
    <div class="page-shell">
        <div class="container">

            <!-- ÜST BAR -->
            <div class="glass topbar">
                <div class="left">
                    <div class="title">Sepetim</div>
                    <div class="subtitle">Sepetinizi kontrol edip adres ve notlarınızı ekleyerek siparişi onaylayabilirsiniz.</div>
                    <asp:Label ID="lblHosgeldin" runat="server" CssClass="welcome"></asp:Label>
                </div>

                <div class="right">
                    <div class="meta">Online Sipariş / Sepet</div>
                    <asp:HyperLink ID="hlMenuyeDonTop" runat="server"
                        NavigateUrl="~/Musteri/Menu.aspx"
                        CssClass="btn-pill">
                        Menüye Dön
                    </asp:HyperLink>
                </div>
            </div>

            <!-- İÇERİK -->
            <div class="glass content">

                <!-- Mesaj -->
                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <!-- Sepet Tablosu -->
                <asp:GridView ID="gvSepet" runat="server" AutoGenerateColumns="False"
                    CssClass="data-grid"
                    OnRowCommand="gvSepet_RowCommand"
                    EmptyDataText="Sepetiniz boş. Menüden ürün ekleyebilirsiniz."
                    DataKeyNames="UrunId">
                    <Columns>
                        <asp:BoundField DataField="UrunAdi" HeaderText="Ürün Adı" />
                        <asp:BoundField DataField="Fiyat" HeaderText="Birim Fiyat" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Adet" HeaderText="Adet" />
                        <asp:BoundField DataField="Tutar" HeaderText="Tutar" DataFormatString="{0:C}" />
                        <asp:ButtonField Text="Sil"
                            CommandName="Sil"
                            ButtonType="Button"
                            ControlStyle-CssClass="btn-delete" />
                    </Columns>
                </asp:GridView>

                <!-- Toplam -->
                <div class="total">
                    <span class="total-badge">
                        Toplam: <strong><asp:Label ID="lblToplam" runat="server"></asp:Label></strong>
                    </span>
                </div>

                <!-- Teslimat Adresi -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-title">Teslimat Adresi</div>
                        <div class="section-sub">Başlık ve adres bilgilerini doldurun.</div>
                    </div>

                    <div class="form-grid">
                        <div class="label">Başlık:</div>
                        <div>
                            <asp:TextBox ID="txtAdresBaslik" runat="server"
                                CssClass="text-input" Text="Ev"></asp:TextBox>
                        </div>

                        <div class="label">Adres:</div>
                        <div>
                            <asp:TextBox ID="txtAdresMetni" runat="server"
                                CssClass="text-area" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>

                        <div class="label">İl:</div>
                        <div>
                            <asp:TextBox ID="txtIl" runat="server"
                                CssClass="text-input" Text="Erzurum"></asp:TextBox>
                        </div>

                        <div class="label">İlçe:</div>
                        <div>
                            <asp:TextBox ID="txtIlce" runat="server"
                                CssClass="text-input"></asp:TextBox>
                        </div>

                        <div class="label">Posta Kodu:</div>
                        <div>
                            <asp:TextBox ID="txtPostaKodu" runat="server"
                                CssClass="text-input"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- Sipariş Notu -->
                <div class="section-card">
                    <div class="section-head">
                        <div class="section-title">Sipariş Notu</div>
                        <div class="section-sub">İsteğe bağlı not ekleyebilirsiniz.</div>
                    </div>

                    <asp:TextBox ID="txtNotlar" runat="server"
                        CssClass="text-area" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>

                <!-- Butonlar -->
                <div class="actions">
                    <asp:Button ID="btnSiparisiOnayla" runat="server"
                        Text="Siparişi Onayla"
                        CssClass="btn-primary"
                        OnClick="btnSiparisiOnayla_Click" />

                    <asp:HyperLink ID="hlMenuyeDon" runat="server"
                        NavigateUrl="~/Musteri/Menu.aspx"
                        CssClass="link-inline">
                        Menüye geri dön
                    </asp:HyperLink>
                </div>

            </div>

        </div>
    </div>
</form>
</body>
</html>
