<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="LokantaCafeWeb.Account.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Kayıt Ol - Lokanta Cafe</title>
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
            align-items: center;
            justify-content: center;
        }

        .register-card{
            width: 980px;
            max-width: 100%;
            border-radius: 22px;
            background: rgba(2, 6, 23, 0.75);
            border: 1px solid rgba(249,115,22,0.28);
            box-shadow: 0 22px 60px rgba(0,0,0,0.60);
            backdrop-filter: blur(10px);
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.05fr 1.2fr;
            min-height: 560px;
        }

        /* SOL PANEL (tanıtım) */
        .left-panel{
            position: relative;
            padding: 28px 26px;
            background:
                radial-gradient(circle at top left,
                    rgba(249,115,22,0.95) 0%,
                    rgba(124,45,18,0.55) 45%,
                    rgba(15,23,42,0.92) 85%);
            border-right: 1px solid rgba(255,255,255,0.10);
        }

        .brand-row{
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }

        .logo-circle{
            width: 54px; height: 54px;
            border-radius: 50%;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.25);
            background: rgba(255,255,255,0.10);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-circle img{
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .brand-title{
            font-size: 18px;
            font-weight: 800;
            color: #fff7ed;
            letter-spacing: 0.02em;
        }

        .brand-sub{
            font-size: 12px;
            color: rgba(255,247,237,0.88);
            margin-top: 2px;
        }

        .left-hero{
            margin-top: 20px;
            color: #fff7ed;
        }

        .left-hero h1{
            font-size: 28px;
            line-height: 1.2;
            margin-bottom: 10px;
            font-weight: 900;
        }

        .left-hero p{
            font-size: 13px;
            color: rgba(255,247,237,0.90);
            max-width: 360px;
        }

        .feature-list{
            margin-top: 18px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .feature-item{
            display: flex;
            gap: 10px;
            align-items: flex-start;
            padding: 10px 10px;
            border-radius: 14px;
            background: rgba(0,0,0,0.18);
            border: 1px solid rgba(255,255,255,0.12);
        }

        .dot{
            margin-top: 4px;
            width: 10px; height: 10px;
            border-radius: 50%;
            background: rgba(255,247,237,0.95);
            box-shadow: 0 0 10px rgba(255,247,237,0.65);
            flex: 0 0 auto;
        }

        .feature-text{
            font-size: 12px;
            color: rgba(255,247,237,0.92);
            line-height: 1.35;
        }

        /* SAĞ PANEL (form) */
        .right-panel{
            padding: 28px 26px;
            background: rgba(2, 6, 23, 0.72);
        }

        .form-title{
            font-size: 20px;
            font-weight: 800;
            color: #f9fafb;
            margin-bottom: 4px;
        }

        .form-subtitle{
            font-size: 12px;
            color: #9ca3af;
            margin-bottom: 14px;
        }

        .message-label{
            display: block;
            font-size: 13px;
            min-height: 18px;
            margin-bottom: 10px;
        }

        .grid{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .field{
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .field label{
            font-size: 12px;
            color: #cbd5e1;
            font-weight: 700;
            letter-spacing: 0.02em;
        }

        .text-input{
            width: 100%;
            padding: 10px 11px;
            border-radius: 12px;
            border: 1px solid rgba(148,163,184,0.25);
            background: rgba(15,23,42,0.70);
            color: #e5e7eb;
            outline: none;
            font-size: 13px;
            transition: box-shadow 0.15s ease, border-color 0.15s ease, transform 0.05s ease;
        }

        .text-input:focus{
            border-color: rgba(249,115,22,0.75);
            box-shadow: 0 0 0 3px rgba(249,115,22,0.22);
        }

        .text-input:active{
            transform: scale(0.995);
        }

        .full{
            grid-column: 1 / -1;
        }

        .btn-row{
            margin-top: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-primary{
            border: none;
            cursor: pointer;
            padding: 10px 16px;
            border-radius: 12px;
            font-weight: 800;
            font-size: 13px;
            color: #fff7ed;
            background: linear-gradient(135deg, #f97316, #ea580c);
            border: 1px solid rgba(249,115,22,0.55);
            box-shadow: 0 16px 30px rgba(248,113,22,0.18);
            transition: transform 0.06s ease, filter 0.15s ease;
        }

        .btn-primary:hover{
            filter: brightness(1.05);
            transform: translateY(-1px);
        }

        .btn-primary:active{
            transform: translateY(0px) scale(0.98);
        }

        .link-inline{
            font-size: 13px;
            text-decoration: none;
            color: #fde68a;
            padding: 8px 10px;
            border-radius: 999px;
            border: 1px solid rgba(249,115,22,0.30);
            background: rgba(249,115,22,0.10);
        }

        .link-inline:hover{
            background: rgba(249,115,22,0.18);
            border-color: rgba(249,115,22,0.55);
            color: #fff7ed;
        }

        @media (max-width: 980px){
            .register-card{
                grid-template-columns: 1fr;
                min-height: auto;
            }
            .left-panel{
                border-right: none;
                border-bottom: 1px solid rgba(255,255,255,0.10);
            }
            .grid{
                grid-template-columns: 1fr;
            }
            .btn-row{
                justify-content: flex-start;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="page-shell">

        <div class="register-card">

            <!-- SOL: Tanıtım paneli -->
            <div class="left-panel">
                <div class="brand-row">
                    <div class="logo-circle">
                        <asp:Image ID="imgLogo" runat="server"
                            ImageUrl="~/Content/Images/logo.png"
                            AlternateText="Lokanta Cafe Logo" />
                    </div>
                    <div>
                        <div class="brand-title">Lokanta Cafe</div>
                        <div class="brand-sub">Hızlı • Kolay • Güvenli</div>
                    </div>
                </div>

                <div class="left-hero">
                    <h1>Yeni hesabını oluştur</h1>
                    <p>
                        Hesabınla menüyü inceleyebilir, sepetine ürün ekleyebilir ve online sipariş verebilirsin.
                    </p>

                    <div class="feature-list">
                        <div class="feature-item">
                            <span class="dot"></span>
                            <div class="feature-text">Online sipariş & sepet sistemi ile hızlı sipariş oluştur.</div>
                        </div>
                        <div class="feature-item">
                            <span class="dot"></span>
                            <div class="feature-text">Sipariş geçmişini ve durumunu takip et.</div>
                        </div>
                        <div class="feature-item">
                            <span class="dot"></span>
                            <div class="feature-text">Güvenli giriş & rol tabanlı yetkilendirme altyapısı.</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SAĞ: Form paneli -->
            <div class="right-panel">

                <div class="form-title">Kayıt Ol</div>
                <div class="form-subtitle">Aşağıdaki alanları doldurarak hesabını oluştur.</div>

                <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                <div class="grid">
                    <div class="field full">
                        <label>Ad Soyad</label>
                        <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="text-input"></asp:TextBox>
                    </div>

                    <div class="field full">
                        <label>E-posta</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="text-input"></asp:TextBox>
                    </div>

                    <div class="field">
                        <label>Şifre</label>
                        <asp:TextBox ID="txtParola" runat="server" CssClass="text-input" TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="field">
                        <label>Şifre (Tekrar)</label>
                        <asp:TextBox ID="txtParolaTekrar" runat="server" CssClass="text-input" TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="field full">
                        <label>Telefon</label>
                        <asp:TextBox ID="txtTelefon" runat="server" CssClass="text-input"></asp:TextBox>
                    </div>
                </div>

                <div class="btn-row">
                    <asp:Button ID="btnKayitOl" runat="server" Text="Kayıt Ol"
                        CssClass="btn-primary" OnClick="btnKayitOl_Click" />

                    <asp:HyperLink ID="hlGiris" runat="server" NavigateUrl="~/Account/Login.aspx"
                        CssClass="link-inline">
                        Zaten hesabım var
                    </asp:HyperLink>
                </div>

            </div>

        </div>

    </div>
    </form>
</body>
</html>
