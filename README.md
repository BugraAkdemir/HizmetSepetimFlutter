# HizmetSepetim – Flutter Client (Open Source)

🚀 **HizmetSepetim**, hizmet verenler ile kullanıcıları buluşturmayı amaçlayan bir platformdur.  
Bu repository, HizmetSepetim’in **Flutter ile geliştirilmiş istemci (client) uygulamasını** içerir.

> ⚠️ **Önemli:**  
> Bu repo **yalnızca Flutter client uygulamasını** kapsar.  
> Backend, veritabanı, canlı API servisleri ve marka altyapısı bu repoya dahil değildir.

---

## 🎯 Projenin Amacı

Bu Flutter uygulaması:

- Flutter ile **gerçek bir ürünün** nasıl geliştirildiğini göstermek
- iOS sürümü ve uzun vadede **Android + iOS birleşik client** için temel oluşturmak
- Açık kaynak üzerinden **Flutter mimarisi, UI/UX ve API entegrasyonu** sergilemek
- Geliştirici (benim) Flutter bilgisini ileri seviyeye taşımak

Amaç **demo yapmak değil**, gerçek dünyada kullanılan bir yapıyı açık kaynak olarak geliştirmektir.

---

## 🧠 Genel Mimari

- **Frontend:** Flutter (Material)
- **State yönetimi:** Basit Stateful / setState (ileride geliştirilebilir)
- **API katmanı:** REST API (Dio)
- **Tasarım:** HizmetSepetim marka renklerine uygun, modern ve sade UI
- **Hata yönetimi:**  
  - Null / bozuk image güvenli  
  - Backend test senaryolarına dayanıklı

---

## 📱 Platform Desteği

| Platform | Durum |
|--------|------|
| Android | ✅ Geliştiriliyor |
| iOS | 🎯 Hedef platform |
| Web | ❌ Şu an hedef değil |

> ℹ️ Android için **ilk Play Store sürümü native Kotlin (Jetpack Compose)** ile çıkacaktır.  
> Flutter bu projede **iOS ve uzun vadeli unified client** hedefiyle geliştirilmektedir.

---

## 🔐 Backend Hakkında

- Backend **özel (private)** tutulmaktadır
- Bu repo canlı backend kodlarını **içermez**
- API endpoint’leri örnek / geliştirme amaçlıdır

Eğer proje ileride:
- **Başarılı olursa:** Open-core model devam eder  
- **Sonlandırılırsa:** Backend dahil tamamı açık kaynak yapılabilir

---
