using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public partial class Appointments : System.Web.UI.Page
    {
        private int currentPage = 1;
        private const int pageSize = 9;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure proper UTF-8 encoding
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("/pages/Login.aspx");
                    return;
                }

                LoadAppointments();
                LoadHospitals();
                LoadBookingHospitals();
            }
        }

        private void LoadAppointments()
        {
            string userEmail = User.Identity.Name;
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    
                    // Build the query with filters
                    string query = @"SELECT a.Id, a.AppointmentDate, a.AppointmentTime, a.Status, a.Notes,
                                          d.Name AS DoctorName, h.Name AS HospitalName, d.Specialization
                                   FROM Appointments a 
                                   INNER JOIN Doctors d ON a.DoctorId = d.Id 
                                   INNER JOIN Hospitals h ON a.HospitalId = h.Id 
                                   WHERE a.PatientEmail = @Email";
                    
                    // Add filters
                    if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                    {
                        query += " AND a.Status = @Status";
                    }
                    
                    if (!string.IsNullOrEmpty(ddlHospital.SelectedValue))
                    {
                        query += " AND a.HospitalId = @HospitalId";
                    }
                    
                    if (!string.IsNullOrEmpty(txtDateFrom.Text))
                    {
                        query += " AND a.AppointmentDate >= @DateFrom";
                    }
                    
                    if (!string.IsNullOrEmpty(txtDateTo.Text))
                    {
                        query += " AND a.AppointmentDate <= @DateTo";
                    }
                    
                    query += " ORDER BY a.AppointmentDate DESC, a.AppointmentTime";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        
                        if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                        }
                        
                        if (!string.IsNullOrEmpty(ddlHospital.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@HospitalId", ddlHospital.SelectedValue);
                        }
                        
                        if (!string.IsNullOrEmpty(txtDateFrom.Text))
                        {
                            cmd.Parameters.AddWithValue("@DateFrom", DateTime.Parse(txtDateFrom.Text));
                        }
                        
                        if (!string.IsNullOrEmpty(txtDateTo.Text))
                        {
                            cmd.Parameters.AddWithValue("@DateTo", DateTime.Parse(txtDateTo.Text));
                        }
                        
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        // Apply pagination
                        DataTable pagedData = GetPagedData(dt, currentPage, pageSize);
                        
                        rptAppointments.DataSource = pagedData;
                        rptAppointments.DataBind();
                        
                        // Update pagination info
                        UpdatePaginationInfo(dt.Rows.Count);
                    }
                }
                catch (Exception ex)
                {
                    // Handle error - in production, log the exception
                }
            }
        }

        private void LoadHospitals()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT Id, Name FROM Hospitals ORDER BY Name";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        ddlHospital.DataSource = dt;
                        ddlHospital.DataTextField = "Name";
                        ddlHospital.DataValueField = "Id";
                        ddlHospital.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private void LoadBookingHospitals()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT Id, Name FROM Hospitals ORDER BY Name";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        ddlBookingHospital.DataSource = dt;
                        ddlBookingHospital.DataTextField = "Name";
                        ddlBookingHospital.DataValueField = "Id";
                        ddlBookingHospital.DataBind();
                        
                        ddlBookingHospital.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Hastane Seçin", ""));
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private DataTable GetPagedData(DataTable sourceTable, int pageNumber, int pageSize)
        {
            DataTable pagedData = sourceTable.Clone();
            
            int startIndex = (pageNumber - 1) * pageSize;
            int endIndex = Math.Min(startIndex + pageSize, sourceTable.Rows.Count);
            
            for (int i = startIndex; i < endIndex; i++)
            {
                pagedData.ImportRow(sourceTable.Rows[i]);
            }
            
            return pagedData;
        }

        private void UpdatePaginationInfo(int totalRecords)
        {
            int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
            
            if (totalPages > 0)
            {
                lblPageInfo.Text = string.Format("Page {0} / {1}", currentPage, totalPages);
                lnkPrevious.Enabled = currentPage > 1;
                lnkNext.Enabled = currentPage < totalPages;
            }
            else
            {
                lblPageInfo.Text = "Sonuç bulunamadı";
                lnkPrevious.Enabled = false;
                lnkNext.Enabled = false;
            }
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadAppointments();
        }

        protected void ddlHospital_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadAppointments();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadAppointments();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlStatus.SelectedIndex = 0;
            ddlHospital.SelectedIndex = 0;
            txtDateFrom.Text = "";
            txtDateTo.Text = "";
            currentPage = 1;
            LoadAppointments();
        }

        protected void lnkPrevious_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                LoadAppointments();
            }
        }

        protected void lnkNext_Click(object sender, EventArgs e)
        {
            currentPage++;
            LoadAppointments();
        }

        protected void btnCancel_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandName == "CancelAppointment")
            {
                string appointmentId = e.CommandArgument.ToString();
                CancelAppointment(appointmentId);
            }
        }

        protected void btnReschedule_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandName == "RescheduleAppointment")
            {
                string appointmentId = e.CommandArgument.ToString();
                // Store appointment ID for rescheduling
                Session["RescheduleAppointmentId"] = appointmentId;
                // Show booking modal for rescheduling
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showBookingModal", 
                    "$('#bookingModal').modal('show');", true);
            }
        }

        protected void btnViewDetails_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string appointmentId = e.CommandArgument.ToString();
                // Show appointment details
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showDetails", 
                    string.Format("alert('Appointment ID: {0} details will be displayed');", appointmentId), true);
            }
        }

        protected void ddlBookingHospital_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSpecializations();
        }

        protected void ddlBookingSpecialization_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDoctors();
        }

        protected void ddlBookingDoctor_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Load available dates for selected doctor
        }

        protected void txtBookingDate_TextChanged(object sender, EventArgs e)
        {
            // Load available time slots for selected date
        }

        protected void btnBookAppointment_Click(object sender, EventArgs e)
        {
            if (ValidateBookingForm())
            {
                if (BookAppointment())
                {
                    // Clear form and close modal
                    ClearBookingForm();
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "closeModal", 
                        "$('#bookingModal').modal('hide');", true);
                    
                    // Reload appointments
                    LoadAppointments();
                    
                    // Show success message
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess", 
                        "alert('Randevu başarıyla alındı!');", true);
                }
                else
                {
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showError", 
                        "alert('Randevu alınırken bir hata oluştu.');", true);
                }
            }
        }

        private void LoadSpecializations()
        {
            if (string.IsNullOrEmpty(ddlBookingHospital.SelectedValue))
            {
                ddlBookingSpecialization.Items.Clear();
                ddlBookingSpecialization.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Önce hastane seçin", ""));
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT DISTINCT Specialization FROM Doctors WHERE HospitalId = @HospitalId ORDER BY Specialization";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@HospitalId", ddlBookingHospital.SelectedValue);
                        
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        ddlBookingSpecialization.DataSource = dt;
                        ddlBookingSpecialization.DataTextField = "Specialization";
                        ddlBookingSpecialization.DataValueField = "Specialization";
                        ddlBookingSpecialization.DataBind();
                        
                        ddlBookingSpecialization.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Uzmanlık Seçin", ""));
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private void LoadDoctors()
        {
            if (string.IsNullOrEmpty(ddlBookingSpecialization.SelectedValue))
            {
                ddlBookingDoctor.Items.Clear();
                ddlBookingDoctor.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Önce uzmanlik seçin", ""));
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT Id, Name FROM Doctors WHERE HospitalId = @HospitalId AND Specialization = @Specialization ORDER BY Name";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@HospitalId", ddlBookingHospital.SelectedValue);
                        cmd.Parameters.AddWithValue("@Specialization", ddlBookingSpecialization.SelectedValue);
                        
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        ddlBookingDoctor.DataSource = dt;
                        ddlBookingDoctor.DataTextField = "Name";
                        ddlBookingDoctor.DataValueField = "Id";
                        ddlBookingDoctor.DataBind();
                        
                        ddlBookingDoctor.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Doktor Seçin", ""));
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private bool ValidateBookingForm()
        {
            if (string.IsNullOrEmpty(ddlBookingHospital.SelectedValue))
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showError", 
                    "alert('Lütfen hastane seçin.');", true);
                return false;
            }

            if (string.IsNullOrEmpty(ddlBookingSpecialization.SelectedValue))
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showError", 
                    "alert('Lütfen uzmanlık seçin.');", true);
                return false;
            }

            if (string.IsNullOrEmpty(ddlBookingDoctor.SelectedValue))
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showError", 
                    "alert('Lütfen doktor seçin.');", true);
                return false;
            }

            if (string.IsNullOrEmpty(txtBookingDate.Text))
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showError", 
                    "alert('Lütfen tarih seçin.');", true);
                return false;
            }

            return true;
        }

        private bool BookAppointment()
        {
            string userEmail = User.Identity.Name;
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"INSERT INTO Appointments (PatientEmail, HospitalId, DoctorId, AppointmentDate, AppointmentTime, Status, Notes, CreatedDate) 
                                   VALUES (@PatientEmail, @HospitalId, @DoctorId, @AppointmentDate, @AppointmentTime, 'Scheduled', @Notes, @CreatedDate)";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PatientEmail", userEmail);
                        cmd.Parameters.AddWithValue("@HospitalId", ddlBookingHospital.SelectedValue);
                        cmd.Parameters.AddWithValue("@DoctorId", ddlBookingDoctor.SelectedValue);
                        cmd.Parameters.AddWithValue("@AppointmentDate", DateTime.Parse(txtBookingDate.Text));
                        cmd.Parameters.AddWithValue("@AppointmentTime", TimeSpan.Parse("09:00:00")); // Default time, should be selected from time slots
                        cmd.Parameters.AddWithValue("@Notes", txtBookingNotes.Text);
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                        
                        int result = cmd.ExecuteNonQuery();
                        return result > 0;
                    }
                }
                catch (Exception ex)
                {
                    return false;
                }
            }
        }

        private void CancelAppointment(string appointmentId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "UPDATE Appointments SET Status = 'Cancelled' WHERE Id = @Id";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", appointmentId);
                        
                        int result = cmd.ExecuteNonQuery();
                        if (result > 0)
                        {
                            LoadAppointments();
                            System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess", 
                                "alert('Randevu iptal edildi.');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showError", 
                        "alert('Randevu iptal edilirken bir hata oluştu.');", true);
                }
            }
        }

        private void ClearBookingForm()
        {
            ddlBookingHospital.SelectedIndex = 0;
            ddlBookingSpecialization.Items.Clear();
            ddlBookingDoctor.Items.Clear();
            txtBookingDate.Text = "";
            txtBookingNotes.Text = "";
        }

        public string GetAppointmentStatusClass(string status)
        {
            switch (status.ToLower())
            {
                case "scheduled":
                    return "scheduled-appointment";
                case "completed":
                    return "completed-appointment";
                case "cancelled":
                    return "cancelled-appointment";
                default:
                    return "";
            }
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "scheduled":
                    return "bg-success";
                case "completed":
                    return "bg-secondary";
                case "cancelled":
                    return "bg-danger";
                default:
                    return "bg-primary";
            }
        }

        public string GetStatusText(string status)
        {
            switch (status.ToLower())
            {
                case "scheduled":
                    return "Planlandı";
                case "completed":
                    return "Tamamlandı";
                case "cancelled":
                    return "İptal Edildi";
                default:
                    return status;
            }
        }
    }
}
