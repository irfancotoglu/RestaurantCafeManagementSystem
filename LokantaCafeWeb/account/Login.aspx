<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LokantaCafeWeb.Account.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Giriş Yap - Lokanta Cafe</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style type="text/css">
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: radial-gradient(circle at top, #1f2937 0%, #020617 45%, #000000 100%);
            color: #f9fafb;
            min-height: 100vh;
        }

        .layout-root {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            position: relative;
        }

        /* Sol taraf – görsel & slogan */
        .hero-pane {
            position: relative;
            overflow: hidden;
        }

        .hero-background {
            position: absolute;
            inset: 0;
            background-image: url('/Content/Images/login_bg.jpg'); /* buraya kendi görsel yolunu koyabilirsin */
            background-size: cover;
            background-position: center;
            filter: brightness(0.65);
            transform: scale(1.02);
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(15,23,42,0.95), rgba(30,64,175,0.65));
            mix-blend-mode: multiply;
        }

        .hero-content {
            position: relative;
            height: 100%;
            padding: 40px 48px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: #e5e7eb;
        }

        .hero-logo-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .hero-logo-circle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: radial-gradient(circle at 30% 20%, #f97316, #b91c1c);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #fff7ed;
            box-shadow: 0 0 16px rgba(249,115,22,0.7);
        }

        .hero-brand-text-main {
            font-size: 18px;
            font-weight: 700;
            letter-spacing: 0.03em;
        }

        .hero-brand-text-sub {
            font-size: 12px;
            color: #9ca3af;
        }

        .hero-slogan {
            margin-top: 40px;
            max-width: 420px;
        }

        .hero-slogan-title {
            font-size: 32px;
            font-weight: 700;
            line-height: 1.25;
            color: #f9fafb;
        }

        .hero-slogan-highlight {
            color: #f97316;
        }

        .hero-slogan-text {
            margin-top: 14px;
            font-size: 14px;
            color: #cbd5f5;
        }

        .hero-bottom {
            font-size: 12px;
            color: #9ca3af;
        }

        /* Sağ taraf – login paneli */
        .form-pane {
            background: #020617;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 24px;
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            background: radial-gradient(circle at top left, #1e293b 0%, #020617 55%);
            border-radius: 18px;
            padding: 26px 26px 24px 26px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.65);
            border: 1px solid rgba(148,163,184,0.35);
        }

        .login-title-area {
            margin-bottom: 18px;
        }

        .login-title {
            font-size: 22px;
            font-weight: 700;
            color: #f9fafb;
            margin-bottom: 4px;
        }

        .login-subtitle {
            font-size: 13px;
            color: #9ca3af;
        }

        .login-subtitle span {
            color: #f97316;
            font-weight: 600;
        }

        .message-label {
            font-size: 13px;
            min-height: 18px;
            margin-bottom: 8px;
            display: block;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-label {
            font-size: 13px;
            color: #e5e7eb;
            margin-bottom: 4px;
            display: block;
        }

        .text-input {
            width: 100%;
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #4b5563;
            background-color: rgba(15,23,42,0.7);
            color: #f9fafb;
            outline: none;
            font-size: 13px;
            transition: border-color 0.15s ease, box-shadow 0.15s ease, background-color 0.15s ease;
        }

        .text-input:focus {
            border-color: #60a5fa;
            box-shadow: 0 0 0 2px rgba(37,99,235,0.45);
            background-color: rgba(15,23,42,0.95);
        }

        .text-input::placeholder {
            color: #6b7280;
        }

        .password-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .forgot-link {
            font-size: 11px;
            color: #9ca3af;
            text-decoration: none;
        }

        .forgot-link:hover {
            color: #e5e7eb;
            text-decoration: underline;
        }

        .btn-primary {
            width: 100%;
            padding: 9px 0;
            border-radius: 999px;
            border: none;
            background: linear-gradient(135deg, #f97316, #ea580c);
            color: #fff7ed;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 4px;
            box-shadow: 0 12px 24px rgba(248,113,22,0.35);
            transition: transform 0.06s ease, box-shadow 0.1s ease, filter 0.12s ease;
        }

        .btn-primary:hover {
            filter: brightness(1.05);
            box-shadow: 0 16px 30px rgba(248,113,22,0.45);
        }

        .btn-primary:active {
            transform: translateY(1px) scale(0.99);
            box-shadow: 0 10px 20px rgba(248,113,22,0.35);
        }

        .aux-links {
            margin-top: 14px;
            font-size: 12px;
            color: #9ca3af;
            text-align: center;
        }

        .aux-links a {
            color: #93c5fd;
            text-decoration: none;
            font-weight: 500;
        }

        .aux-links a:hover {
            color: #bfdbfe;
            text-decoration: underline;
        }

        .mekan-link {
            display: inline-block;
            margin-top: 6px;
            font-size: 11px;
            color: #9ca3af;
        }

        .mekan-link a {
            color: #fbbf24;
            text-decoration: none;
            font-weight: 500;
        }

        .mekan-link a:hover {
            color: #fde68a;
            text-decoration: underline;
        }

        @media (max-width: 920px) {
            .layout-root {
                grid-template-columns: 1fr;
            }

            .hero-pane {
                display: none; /* istersen mobile'da da gösterilecek şekilde değiştirebiliriz */
            }

            .form-pane {
                padding: 32px 18px;
            }

            .login-card {
                max-width: 420px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="layout-root">

            <!-- SOL PANEL (görsel + slogan) -->
            <div class="hero-pane">
                <div class="hero-background"></div>
                <div class="hero-overlay"></div>

                <div class="hero-content">
                    <div class="hero-logo-row">
                        <div class="hero-logo-circle">LC</div>
                        <div>
                            <div class="hero-brand-text-main">Lokanta Cafe Yönetim Sistemi</div>
                            <div class="hero-brand-text-sub">Mutfaktan masaya, tüm süreç tek panelde.</div>
                        </div>
                    </div>

                    <div class="hero-slogan">
                        <div class="hero-slogan-title">
                            <span class="hero-slogan-highlight">Siparişleri,</span><br />
                            masaları ve ödemeleri<br />
                            tek ekrandan yönetin.
                        </div>
                        <div class="hero-slogan-text">
                            Garsonlar, kasiyerler ve yöneticiler için tasarlanmış modern bir restoran otomasyonu.
                            Anlık sipariş takibi, online müşteri siparişleri, masa durumu ve çok daha fazlası.
                        </div>
                    </div>

                    <div class="hero-bottom">
                        © <%: DateTime.Now.Year %> Lokanta Cafe • Tüm hakları saklıdır.
                    </div>
                </div>
            </div>

            <!-- SAĞ PANEL (login formu) -->
            <div class="form-pane">
                <div class="login-card">

                    <div class="login-title-area">
                        <div class="login-title">Hoş geldiniz</div>
                        <div class="login-subtitle">
                            Hesabınıza giriş yaparak <span>yönetim panelini</span> kullanmaya başlayın.
                        </div>
                    </div>

                    <asp:Label ID="lblMesaj" runat="server" CssClass="message-label" ForeColor="Red"></asp:Label>

                    <div class="form-group">
                        <label for="txtEmail" class="form-label">E-posta adresi</label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="text-input"
                            placeholder="ornek@lokantacafe.com"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <div class="password-row">
                            <label for="txtParola" class="form-label">Şifre</label>
                            <a href="#" class="forgot-link">Şifremi unuttum (isteğe bağlı)</a>
                        </div>
                        <asp:TextBox ID="txtParola" runat="server"
                            CssClass="text-input"
                            TextMode="Password"
                            placeholder="••••••••"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnGiris" runat="server"
                        Text="Giriş Yap"
                        CssClass="btn-primary"
                        OnClick="btnGiris_Click" />

                    <div class="aux-links">
                        Hesabınız yok mu?
                        <asp:HyperLink ID="hlKayitOl" runat="server"
                            NavigateUrl="~/Account/Register.aspx">
                            Kayıt Ol
                        </asp:HyperLink>

                        <div class="mekan-link">
                            Mekanda bulunan müşteriler için menüyü görüntülemek isterseniz:&nbsp;
                            <asp:HyperLink ID="hlMekanMenu" runat="server"
                                NavigateUrl="~/Genel/MekanMenu.aspx">
                                Mekan Menüsünü Aç
                            </asp:HyperLink>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
