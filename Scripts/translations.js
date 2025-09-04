// Translation System for Hospital Appointment System
// Supports Turkish (tr) and Arabic (ar)

const translations = {
    tr: {
        // Navigation
        dashboard: "Dashboard",
        appointments: "Randevular",
        hospitals: "Hastaneler",
        bloodTests: "Kan Testleri",
        profile: "Profil",
        logout: "Çıkış",
        
        // Login/Register
        login: "Giriş",
        register: "Kayıt Ol",
        email: "E-posta",
        password: "Şifre",
        confirmPassword: "Şifre Tekrar",
        rememberMe: "Beni Hatırla",
        forgotPassword: "Şifremi Unuttum",
        loginButton: "Giriş Yap",
        registerButton: "Kayıt Ol",
        alreadyHaveAccount: "Zaten hesabınız var mı?",
        dontHaveAccount: "Hesabınız yok mu?",
        
        // Profile
        personalInformation: "Kişisel Bilgiler",
        firstName: "Ad",
        lastName: "Soyad",
        phone: "Telefon",
        nationalId: "TC Kimlik No",
        dateOfBirth: "Doğum Tarihi",
        saveChanges: "Değişiklikleri Kaydet",
        changePassword: "Şifre Değiştir",
        currentPassword: "Mevcut Şifre",
        newPassword: "Yeni Şifre",
        confirmNewPassword: "Yeni Şifre Tekrar",
        accountSecurity: "Hesap Güvenliği",
        accountStatus: "Hesap Durumu",
        active: "Aktif",
        
        // Dashboard
        welcome: "Hoş Geldiniz",
        totalAppointments: "Toplam Randevu",
        completedAppointments: "Tamamlanan Randevu",
        bloodTests: "Kan Testleri",
        memberSince: "Üye Olma Tarihi",
        recentAppointments: "Son Randevular",
        notifications: "Bildirimler",
        noAppointments: "Randevu bulunamadı",
        noNotifications: "Bildirim bulunamadı",
        
        // Appointments
        bookAppointment: "Randevu Al",
        appointmentDate: "Randevu Tarihi",
        appointmentTime: "Randevu Saati",
        hospital: "Hastane",
        doctor: "Doktor",
        specialization: "Uzmanlık",
        status: "Durum",
        pending: "Beklemede",
        confirmed: "Onaylandı",
        completed: "Tamamlandı",
        cancelled: "İptal Edildi",
        cancelAppointment: "Randevu İptal Et",
        rescheduleAppointment: "Randevu Yeniden Planla",
        
        // Hospitals
        searchHospitals: "Hastane Ara",
        search: "Ara",
        clear: "Temizle",
        city: "Şehir",
        rating: "Değerlendirme",
        allCities: "Tüm Şehirler",
        allSpecializations: "Tüm Uzmanlıklar",
        allRatings: "Tüm Değerlendirmeler",
        bookNow: "Şimdi Randevu Al",
        viewDetails: "Detayları Görüntüle",
        
        // Blood Tests
        testName: "Test Adı",
        testDate: "Test Tarihi",
        result: "Sonuç",
        normal: "Normal",
        abnormal: "Anormal",
        pending: "Beklemede",
        viewResults: "Sonuçları Görüntüle",
        
        // Common
        loading: "Yükleniyor...",
        error: "Hata",
        success: "Başarılı",
        warning: "Uyarı",
        info: "Bilgi",
        yes: "Evet",
        no: "Hayır",
        ok: "Tamam",
        cancel: "İptal",
        save: "Kaydet",
        edit: "Düzenle",
        delete: "Sil",
        close: "Kapat",
        back: "Geri",
        next: "İleri",
        previous: "Önceki",
        page: "Sayfa",
        of: "/",
        noResults: "Sonuç bulunamadı",
        selectAll: "Tümünü Seç",
        deselectAll: "Tümünü Kaldır",
        
        // Messages
        profileUpdated: "Profil başarıyla güncellendi!",
        passwordChanged: "Şifre başarıyla değiştirildi!",
        appointmentBooked: "Randevu başarıyla alındı!",
        appointmentCancelled: "Randevu iptal edildi!",
        loginSuccess: "Başarıyla giriş yapıldı!",
        loginError: "E-posta veya şifre hatalı!",
        registrationSuccess: "Kayıt başarıyla tamamlandı!",
        logoutSuccess: "Başarıyla çıkış yapıldı!",
        
        // Validation
        requiredField: "Bu alan zorunludur",
        invalidEmail: "Geçersiz e-posta adresi",
        passwordMismatch: "Şifreler eşleşmiyor",
        passwordTooShort: "Şifre en az 6 karakter olmalıdır",
        invalidPhone: "Geçersiz telefon numarası",
        invalidNationalId: "Geçersiz TC Kimlik No"
    },
    
    ar: {
        // Navigation
        dashboard: "لوحة التحكم",
        appointments: "المواعيد",
        hospitals: "المستشفيات",
        bloodTests: "فحوصات الدم",
        profile: "الملف الشخصي",
        logout: "تسجيل الخروج",
        
        // Login/Register
        login: "تسجيل الدخول",
        register: "إنشاء حساب",
        email: "البريد الإلكتروني",
        password: "كلمة المرور",
        confirmPassword: "تأكيد كلمة المرور",
        rememberMe: "تذكرني",
        forgotPassword: "نسيت كلمة المرور",
        loginButton: "تسجيل الدخول",
        registerButton: "إنشاء حساب",
        alreadyHaveAccount: "لديك حساب بالفعل؟",
        dontHaveAccount: "ليس لديك حساب؟",
        
        // Profile
        personalInformation: "المعلومات الشخصية",
        firstName: "الاسم الأول",
        lastName: "اسم العائلة",
        phone: "رقم الهاتف",
        nationalId: "رقم الهوية الوطنية",
        dateOfBirth: "تاريخ الميلاد",
        saveChanges: "حفظ التغييرات",
        changePassword: "تغيير كلمة المرور",
        currentPassword: "كلمة المرور الحالية",
        newPassword: "كلمة المرور الجديدة",
        confirmNewPassword: "تأكيد كلمة المرور الجديدة",
        accountSecurity: "أمان الحساب",
        accountStatus: "حالة الحساب",
        active: "نشط",
        
        // Dashboard
        welcome: "مرحباً بك",
        totalAppointments: "إجمالي المواعيد",
        completedAppointments: "المواعيد المكتملة",
        bloodTests: "فحوصات الدم",
        memberSince: "عضو منذ",
        recentAppointments: "المواعيد الأخيرة",
        notifications: "الإشعارات",
        noAppointments: "لا توجد مواعيد",
        noNotifications: "لا توجد إشعارات",
        
        // Appointments
        bookAppointment: "حجز موعد",
        appointmentDate: "تاريخ الموعد",
        appointmentTime: "وقت الموعد",
        hospital: "المستشفى",
        doctor: "الطبيب",
        specialization: "التخصص",
        status: "الحالة",
        pending: "في الانتظار",
        confirmed: "مؤكد",
        completed: "مكتمل",
        cancelled: "ملغي",
        cancelAppointment: "إلغاء الموعد",
        rescheduleAppointment: "إعادة جدولة الموعد",
        
        // Hospitals
        searchHospitals: "البحث في المستشفيات",
        search: "بحث",
        clear: "مسح",
        city: "المدينة",
        rating: "التقييم",
        allCities: "جميع المدن",
        allSpecializations: "جميع التخصصات",
        allRatings: "جميع التقييمات",
        bookNow: "احجز الآن",
        viewDetails: "عرض التفاصيل",
        
        // Blood Tests
        testName: "اسم الفحص",
        testDate: "تاريخ الفحص",
        result: "النتيجة",
        normal: "طبيعي",
        abnormal: "غير طبيعي",
        pending: "في الانتظار",
        viewResults: "عرض النتائج",
        
        // Common
        loading: "جاري التحميل...",
        error: "خطأ",
        success: "نجح",
        warning: "تحذير",
        info: "معلومات",
        yes: "نعم",
        no: "لا",
        ok: "موافق",
        cancel: "إلغاء",
        save: "حفظ",
        edit: "تعديل",
        delete: "حذف",
        close: "إغلاق",
        back: "رجوع",
        next: "التالي",
        previous: "السابق",
        page: "صفحة",
        of: "/",
        noResults: "لا توجد نتائج",
        selectAll: "تحديد الكل",
        deselectAll: "إلغاء تحديد الكل",
        
        // Messages
        profileUpdated: "تم تحديث الملف الشخصي بنجاح!",
        passwordChanged: "تم تغيير كلمة المرور بنجاح!",
        appointmentBooked: "تم حجز الموعد بنجاح!",
        appointmentCancelled: "تم إلغاء الموعد!",
        loginSuccess: "تم تسجيل الدخول بنجاح!",
        loginError: "البريد الإلكتروني أو كلمة المرور غير صحيحة!",
        registrationSuccess: "تم التسجيل بنجاح!",
        logoutSuccess: "تم تسجيل الخروج بنجاح!",
        
        // Validation
        requiredField: "هذا الحقل مطلوب",
        invalidEmail: "عنوان البريد الإلكتروني غير صحيح",
        passwordMismatch: "كلمات المرور غير متطابقة",
        passwordTooShort: "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
        invalidPhone: "رقم الهاتف غير صحيح",
        invalidNationalId: "رقم الهوية الوطنية غير صحيح"
    }
};

// Current language (default: Turkish)
let currentLanguage = 'tr';

// Function to change language
function changeLanguage(lang) {
    if (translations[lang]) {
        currentLanguage = lang;
        
        // Update all elements with data-translate attribute
        const elements = document.querySelectorAll('[data-translate]');
        elements.forEach(element => {
            const key = element.getAttribute('data-translate');
            if (translations[lang][key]) {
                element.textContent = translations[lang][key];
            }
        });
        
        // Update all elements with data-translate-placeholder attribute
        const placeholderElements = document.querySelectorAll('[data-translate-placeholder]');
        placeholderElements.forEach(element => {
            const key = element.getAttribute('data-translate-placeholder');
            if (translations[lang][key]) {
                element.placeholder = translations[lang][key];
            }
        });
        
        // Update all elements with data-translate-title attribute
        const titleElements = document.querySelectorAll('[data-translate-title]');
        titleElements.forEach(element => {
            const key = element.getAttribute('data-translate-title');
            if (translations[lang][key]) {
                element.title = translations[lang][key];
            }
        });
        
        // Update all elements with data-translate-value attribute
        const valueElements = document.querySelectorAll('[data-translate-value]');
        valueElements.forEach(element => {
            const key = element.getAttribute('data-translate-value');
            if (translations[lang][key]) {
                element.value = translations[lang][key];
            }
        });
        
        // Update page direction for Arabic
        if (lang === 'ar') {
            document.body.style.direction = 'rtl';
            document.body.classList.add('rtl');
        } else {
            document.body.style.direction = 'ltr';
            document.body.classList.remove('rtl');
        }
        
        // Store language preference
        localStorage.setItem('preferredLanguage', lang);
        
        // Trigger custom event for other scripts
        document.dispatchEvent(new CustomEvent('languageChanged', { detail: { language: lang } }));
    }
}

// Function to get translation
function getTranslation(key) {
    return translations[currentLanguage][key] || key;
}

// Function to initialize translations on page load
function initializeTranslations() {
    // Get stored language preference or default to Turkish
    const storedLang = localStorage.getItem('preferredLanguage') || 'tr';
    changeLanguage(storedLang);
}

// Initialize translations when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeTranslations);

// Export functions for use in other scripts
window.translationSystem = {
    changeLanguage: changeLanguage,
    getTranslation: getTranslation,
    currentLanguage: () => currentLanguage
};
