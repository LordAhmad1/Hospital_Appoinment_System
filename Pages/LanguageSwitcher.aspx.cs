using System;
using System.Web.UI.WebControls;

namespace HospitalAppointmentSystem
{
    public partial class LanguageSwitcher : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize the page
                LoadCurrentLanguage();
            }
        }

        private void LoadCurrentLanguage()
        {
            // Get current language from session or default to Turkish
            string currentLang = TranslationHelper.GetCurrentLanguage();
            
            // Set the hidden field value
            hdnSelectedLanguage.Value = currentLang;
        }

        protected void btnSaveLanguage_Click(object sender, EventArgs e)
        {
            try
            {
                string selectedLanguage = hdnSelectedLanguage.Value;
                
                // Validate language
                if (string.IsNullOrEmpty(selectedLanguage) || 
                    (selectedLanguage != "tr" && selectedLanguage != "ar"))
                {
                    selectedLanguage = "tr"; // Default to Turkish
                }
                
                // Save language preference to session
                TranslationHelper.SetCurrentLanguage(selectedLanguage);
                
                // Save to database if user is authenticated
                if (User.Identity.IsAuthenticated)
                {
                    SaveLanguageToDatabase(selectedLanguage);
                }
                
                // Show success message
                string successMessage = TranslationHelper.GetTranslation("languageSaved", selectedLanguage);
                if (string.IsNullOrEmpty(successMessage))
                {
                    successMessage = selectedLanguage == "tr" ? 
                        "Dil tercihiniz başarıyla kaydedildi!" : 
                        "تم حفظ تفضيل اللغة بنجاح!";
                }
                
                // Redirect to dashboard with success message
                Response.Redirect("/pages/Dashboard.aspx?lang=" + selectedLanguage + "&msg=language_saved");
            }
            catch (Exception ex)
            {
                // Handle error
                Response.Redirect("/pages/Dashboard.aspx?error=language_save_failed");
            }
        }

        private void SaveLanguageToDatabase(string language)
        {
            try
            {
                // This would save the language preference to the user's profile in the database
                // For now, we'll just use session storage
                // In a real application, you would update the user's profile in the database
                
                // Example:
                // using (SqlConnection conn = new SqlConnection(connectionString))
                // {
                //     string query = "UPDATE Patients SET PreferredLanguage = @Language WHERE Email = @Email";
                //     using (SqlCommand cmd = new SqlCommand(query, conn))
                //     {
                //         cmd.Parameters.AddWithValue("@Language", language);
                //         cmd.Parameters.AddWithValue("@Email", User.Identity.Name);
                //         conn.Open();
                //         cmd.ExecuteNonQuery();
                //     }
                // }
            }
            catch (Exception ex)
            {
                // Log error but don't fail the language change
                // The language change will still work with session storage
            }
        }
    }
}
