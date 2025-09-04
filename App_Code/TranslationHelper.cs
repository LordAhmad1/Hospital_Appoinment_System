using System;
using System.Collections.Generic;
using System.Web;

namespace HospitalAppointmentSystem
{
    public static class TranslationHelper
    {
        private static readonly Dictionary<string, Dictionary<string, string>> translations = new Dictionary<string, Dictionary<string, string>>
        {
            { "tr", new Dictionary<string, string>
            {
                // Navigation
                { "dashboard", "Dashboard" },
                { "appointments", "Randevular" },
                { "hospitals", "Hastaneler" },
                { "bloodTests", "Kan Testleri" },
                { "profile", "Profil" },
                { "logout", "Çıkış" },
                
                // Login/Register
                { "login", "Giriş" },
                { "register", "Kayıt Ol" },
                { "email", "E-posta" },
                { "password", "Şifre" },
                { "confirmPassword", "Şifre Tekrar" },
                { "rememberMe", "Beni Hatırla" },
                { "forgotPassword", "Şifremi Unuttum" },
                { "loginButton", "Giriş Yap" },
                { "registerButton", "Kayıt Ol" },
                { "alreadyHaveAccount", "Zaten hesabınız var mı?" },
                { "dontHaveAccount", "Hesabınız yok mu?" },
                
                // Profile
                { "personalInformation", "Kişisel Bilgiler" },
                { "firstName", "Ad" },
                { "lastName", "Soyad" },
                { "phone", "Telefon" },
                { "nationalId", "TC Kimlik No" },
                { "dateOfBirth", "Doğum Tarihi" },
                { "saveChanges", "Değişiklikleri Kaydet" },
                { "changePassword", "Şifre Değiştir" },
                { "currentPassword", "Mevcut Şifre" },
                { "newPassword", "Yeni Şifre" },
                { "confirmNewPassword", "Yeni Şifre Tekrar" },
                { "accountSecurity", "Hesap Güvenliği" },
                { "accountStatus", "Hesap Durumu" },
                { "active", "Aktif" },
                
                // Dashboard
                { "welcome", "Hoş Geldiniz" },
                { "totalAppointments", "Toplam Randevu" },
                { "completedAppointments", "Tamamlanan Randevu" },
                { "bloodTests", "Kan Testleri" },
                { "memberSince", "Üye Olma Tarihi" },
                { "recentAppointments", "Son Randevular" },
                { "notifications", "Bildirimler" },
                { "noAppointments", "Randevu bulunamadı" },
                { "noNotifications", "Bildirim bulunamadı" },
                
                // Appointments
                { "bookAppointment", "Randevu Al" },
                { "appointmentDate", "Randevu Tarihi" },
                { "appointmentTime", "Randevu Saati" },
                { "hospital", "Hastane" },
                { "doctor", "Doktor" },
                { "specialization", "Uzmanlık" },
                { "status", "Durum" },
                { "pending", "Beklemede" },
                { "confirmed", "Onaylandı" },
                { "completed", "Tamamlandı" },
                { "cancelled", "İptal Edildi" },
                { "cancelAppointment", "Randevu İptal Et" },
                { "rescheduleAppointment", "Randevu Yeniden Planla" },
                
                // Hospitals
                { "searchHospitals", "Hastane Ara" },
                { "search", "Ara" },
                { "clear", "Temizle" },
                { "city", "Şehir" },
                { "rating", "Değerlendirme" },
                { "allCities", "Tüm Şehirler" },
                { "allSpecializations", "Tüm Uzmanlıklar" },
                { "allRatings", "Tüm Değerlendirmeler" },
                { "bookNow", "Şimdi Randevu Al" },
                { "viewDetails", "Detayları Görüntüle" },
                
                // Blood Tests
                { "testName", "Test Adı" },
                { "testDate", "Test Tarihi" },
                { "result", "Sonuç" },
                { "normal", "Normal" },
                { "abnormal", "Anormal" },
                { "viewResults", "Sonuçları Görüntüle" },
                
                // Common
                { "loading", "Yükleniyor..." },
                { "error", "Hata" },
                { "success", "Başarılı" },
                { "warning", "Uyarı" },
                { "info", "Bilgi" },
                { "yes", "Evet" },
                { "no", "Hayır" },
                { "ok", "Tamam" },
                { "cancel", "İptal" },
                { "save", "Kaydet" },
                { "edit", "Düzenle" },
                { "delete", "Sil" },
                { "close", "Kapat" },
                { "back", "Geri" },
                { "next", "İleri" },
                { "previous", "Önceki" },
                { "page", "Sayfa" },
                { "of", "/" },
                { "noResults", "Sonuç bulunamadı" },
                { "selectAll", "Tümünü Seç" },
                { "deselectAll", "Tümünü Kaldır" },
                
                // Messages
                { "profileUpdated", "Profil başarıyla güncellendi!" },
                { "passwordChanged", "Şifre başarıyla değiştirildi!" },
                { "appointmentBooked", "Randevu başarıyla alındı!" },
                { "appointmentCancelled", "Randevu iptal edildi!" },
                { "loginSuccess", "Başarıyla giriş yapıldı!" },
                { "loginError", "E-posta veya şifre hatalı!" },
                { "registrationSuccess", "Kayıt başarıyla tamamlandı!" },
                { "logoutSuccess", "Başarıyla çıkış yapıldı!" },
                
                // Validation
                { "requiredField", "Bu alan zorunludur" },
                { "invalidEmail", "Geçersiz e-posta adresi" },
                { "passwordMismatch", "Şifreler eşleşmiyor" },
                { "passwordTooShort", "Şifre en az 6 karakter olmalıdır" },
                { "invalidPhone", "Geçersiz telefon numarası" },
                { "invalidNationalId", "Geçersiz TC Kimlik No" }
            }},
            
            { "ar", new Dictionary<string, string>
            {
                // Navigation
                { "dashboard", "لوحة التحكم" },
                { "appointments", "المواعيد" },
                { "hospitals", "المستشفيات" },
                { "bloodTests", "فحوصات الدم" },
                { "profile", "الملف الشخصي" },
                { "logout", "تسجيل الخروج" },
                
                // Login/Register
                { "login", "تسجيل الدخول" },
                { "register", "إنشاء حساب" },
                { "email", "البريد الإلكتروني" },
                { "password", "كلمة المرور" },
                { "confirmPassword", "تأكيد كلمة المرور" },
                { "rememberMe", "تذكرني" },
                { "forgotPassword", "نسيت كلمة المرور" },
                { "loginButton", "تسجيل الدخول" },
                { "registerButton", "إنشاء حساب" },
                { "alreadyHaveAccount", "لديك حساب بالفعل؟" },
                { "dontHaveAccount", "ليس لديك حساب؟" },
                
                // Profile
                { "personalInformation", "المعلومات الشخصية" },
                { "firstName", "الاسم الأول" },
                { "lastName", "اسم العائلة" },
                { "phone", "رقم الهاتف" },
                { "nationalId", "رقم الهوية الوطنية" },
                { "dateOfBirth", "تاريخ الميلاد" },
                { "saveChanges", "حفظ التغييرات" },
                { "changePassword", "تغيير كلمة المرور" },
                { "currentPassword", "كلمة المرور الحالية" },
                { "newPassword", "كلمة المرور الجديدة" },
                { "confirmNewPassword", "تأكيد كلمة المرور الجديدة" },
                { "accountSecurity", "أمان الحساب" },
                { "accountStatus", "حالة الحساب" },
                { "active", "نشط" },
                
                // Dashboard
                { "welcome", "مرحباً بك" },
                { "totalAppointments", "إجمالي المواعيد" },
                { "completedAppointments", "المواعيد المكتملة" },
                { "bloodTests", "فحوصات الدم" },
                { "memberSince", "عضو منذ" },
                { "recentAppointments", "المواعيد الأخيرة" },
                { "notifications", "الإشعارات" },
                { "noAppointments", "لا توجد مواعيد" },
                { "noNotifications", "لا توجد إشعارات" },
                
                // Appointments
                { "bookAppointment", "حجز موعد" },
                { "appointmentDate", "تاريخ الموعد" },
                { "appointmentTime", "وقت الموعد" },
                { "hospital", "المستشفى" },
                { "doctor", "الطبيب" },
                { "specialization", "التخصص" },
                { "status", "الحالة" },
                { "pending", "في الانتظار" },
                { "confirmed", "مؤكد" },
                { "completed", "مكتمل" },
                { "cancelled", "ملغي" },
                { "cancelAppointment", "إلغاء الموعد" },
                { "rescheduleAppointment", "إعادة جدولة الموعد" },
                
                // Hospitals
                { "searchHospitals", "البحث في المستشفيات" },
                { "search", "بحث" },
                { "clear", "مسح" },
                { "city", "المدينة" },
                { "rating", "التقييم" },
                { "allCities", "جميع المدن" },
                { "allSpecializations", "جميع التخصصات" },
                { "allRatings", "جميع التقييمات" },
                { "bookNow", "احجز الآن" },
                { "viewDetails", "عرض التفاصيل" },
                
                // Blood Tests
                { "testName", "اسم الفحص" },
                { "testDate", "تاريخ الفحص" },
                { "result", "النتيجة" },
                { "normal", "طبيعي" },
                { "abnormal", "غير طبيعي" },
                { "viewResults", "عرض النتائج" },
                
                // Common
                { "loading", "جاري التحميل..." },
                { "error", "خطأ" },
                { "success", "نجح" },
                { "warning", "تحذير" },
                { "info", "معلومات" },
                { "yes", "نعم" },
                { "no", "لا" },
                { "ok", "موافق" },
                { "cancel", "إلغاء" },
                { "save", "حفظ" },
                { "edit", "تعديل" },
                { "delete", "حذف" },
                { "close", "إغلاق" },
                { "back", "رجوع" },
                { "next", "التالي" },
                { "previous", "السابق" },
                { "page", "صفحة" },
                { "of", "/" },
                { "noResults", "لا توجد نتائج" },
                { "selectAll", "تحديد الكل" },
                { "deselectAll", "إلغاء تحديد الكل" },
                
                // Messages
                { "profileUpdated", "تم تحديث الملف الشخصي بنجاح!" },
                { "passwordChanged", "تم تغيير كلمة المرور بنجاح!" },
                { "appointmentBooked", "تم حجز الموعد بنجاح!" },
                { "appointmentCancelled", "تم إلغاء الموعد!" },
                { "loginSuccess", "تم تسجيل الدخول بنجاح!" },
                { "loginError", "البريد الإلكتروني أو كلمة المرور غير صحيحة!" },
                { "registrationSuccess", "تم التسجيل بنجاح!" },
                { "logoutSuccess", "تم تسجيل الخروج بنجاح!" },
                
                // Validation
                { "requiredField", "هذا الحقل مطلوب" },
                { "invalidEmail", "عنوان البريد الإلكتروني غير صحيح" },
                { "passwordMismatch", "كلمات المرور غير متطابقة" },
                { "passwordTooShort", "كلمة المرور يجب أن تكون 6 أحرف على الأقل" },
                { "invalidPhone", "رقم الهاتف غير صحيح" },
                { "invalidNationalId", "رقم الهوية الوطنية غير صحيح" }
            }}
        };

        /// <summary>
        /// Gets the current language from session or defaults to Turkish
        /// </summary>
        public static string GetCurrentLanguage()
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                object sessionValue = HttpContext.Current.Session["CurrentLanguage"];
                if (sessionValue != null)
                {
                    return sessionValue.ToString();
                }
            }
            return "tr";
        }

        /// <summary>
        /// Sets the current language in session
        /// </summary>
        public static void SetCurrentLanguage(string language)
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                HttpContext.Current.Session["CurrentLanguage"] = language;
            }
        }

        /// <summary>
        /// Gets translation for the specified key in the current language
        /// </summary>
        public static string GetTranslation(string key)
        {
            string currentLang = GetCurrentLanguage();
            
            if (translations.ContainsKey(currentLang) && translations[currentLang].ContainsKey(key))
            {
                return translations[currentLang][key];
            }
            
            // Fallback to Turkish if translation not found
            if (translations["tr"].ContainsKey(key))
            {
                return translations["tr"][key];
            }
            
            return key; // Return the key itself if no translation found
        }

        /// <summary>
        /// Gets translation for the specified key in the specified language
        /// </summary>
        public static string GetTranslation(string key, string language)
        {
            if (translations.ContainsKey(language) && translations[language].ContainsKey(key))
            {
                return translations[language][key];
            }
            
            // Fallback to Turkish if translation not found
            if (translations["tr"].ContainsKey(key))
            {
                return translations["tr"][key];
            }
            
            return key; // Return the key itself if no translation found
        }

        /// <summary>
        /// Formats a translation string with parameters
        /// </summary>
        public static string GetTranslation(string key, params object[] args)
        {
            string translation = GetTranslation(key);
            return string.Format(translation, args);
        }

        /// <summary>
        /// Gets all available languages
        /// </summary>
        public static List<string> GetAvailableLanguages()
        {
            return new List<string>(translations.Keys);
        }

        /// <summary>
        /// Checks if a translation exists for the given key
        /// </summary>
        public static bool HasTranslation(string key, string language = null)
        {
            string lang = language ?? GetCurrentLanguage();
            return translations.ContainsKey(lang) && translations[lang].ContainsKey(key);
        }
    }
}
