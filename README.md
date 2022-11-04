# Sendgrid-Email-Plugin
'Sendgrid Email Plugin' ile e-posta gönderimlerinizi SMTP dışında bir web servis ile SendGrid hesabınız üzerinden gönderebilirsiniz.

sendgrid.com web sitesine üye olduktan sonra "Free" seçeneği ile günlük 100 adet e-posta gönderimi ücretsiz olarak sunulmaktadır.

# Sendgrid Kurulum Aşamaları
1. [Sender Authentication](https://app.sendgrid.com/settings/sender_auth) bölümünden gönderi yapacağınız e-posta adresini kayıt edin.
2. Gönderi yapacağınız e-posta adresini doğrulama (verification) işlemini tamamlayın.
3. [API Keys](https://app.sendgrid.com/settings/api_keys) bölümünden API anahtarınızı alın.
4. RabbitCMS / Panel / Sistem Ayarları / Eklentiler bölümünde Sendgrid Email Plugin eklentisinin ayarlarını açın.
5. Aldığınız API anahtarını ilgili bölüme girin.
6. RabbitCMS / Panel Sistem Ayarları / Genel Ayarlar bölümünde E-Posta sekmesine gelin. (Fotograf 1)
7. E-Posta Servis Ayarları bölümünde bulunan ayarları, kayıt ettiğiniz e-posta kutusu bilgileri ile güncelleyin.
8. Sendgrid Email Plugin ayarlarından Aktivasyon Durumu'nun aktif olduğuna emin olun. (Fotograf 2)

RabbitCMS artık Sendgrid üzerinden e-posta gönderecek.

> Eğer günlük e-posta gönderiminiz 100 adet'ten fazla ise mutlaka ücretli üyelik almanız gerekir. Sisteminizin ayrıca gönderdiği e-posta'ları bu sayıya dahil etmeyi unutmayın!

<img width="600" alt="eposta-ayarlari" src="https://user-images.githubusercontent.com/5244451/199963748-93ed642c-6d37-46cf-adc7-3125593225a8.png">
Fotograf 1

<img width="600" alt="Sendgrid-Plugin-Ayarlari" src="https://user-images.githubusercontent.com/5244451/199963762-66939837-8a55-4c9b-8069-7cda421775c4.png">
Fotograf 2
