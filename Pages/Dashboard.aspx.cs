using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
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

                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            string userEmail = User.Identity.Name;
            LoadPatientInfo(userEmail);
            LoadStatistics(userEmail);
            LoadRecentAppointments(userEmail);
            LoadNotifications(userEmail);
        }

        private void LoadPatientInfo(string userEmail)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT FirstName, LastName FROM Patients WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string firstName = reader["FirstName"].ToString();
                                string lastName = reader["LastName"].ToString();
                                lblPatientName.Text = firstName + " " + lastName;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private void LoadStatistics(string userEmail)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    
                    // Total appointments
                    string totalQuery = "SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        object result = cmd.ExecuteScalar();
                        lblTotalAppointments.Text = (result != null && result != DBNull.Value) ? result.ToString() : "0";
                    }
                    
                    // Upcoming appointments
                    string upcomingQuery = "SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @Email AND AppointmentDate >= @Today AND Status = 'Scheduled'";
                    using (SqlCommand cmd = new SqlCommand(upcomingQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        cmd.Parameters.AddWithValue("@Today", DateTime.Today);
                        object result = cmd.ExecuteScalar();
                        lblUpcomingAppointments.Text = (result != null && result != DBNull.Value) ? result.ToString() : "0";
                    }
                    
                    // Blood tests
                    string bloodTestsQuery = "SELECT COUNT(*) FROM BloodTests WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(bloodTestsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        object result = cmd.ExecuteScalar();
                        lblBloodTests.Text = (result != null && result != DBNull.Value) ? result.ToString() : "0";
                    }
                    
                    // Hospitals
                    string hospitalsQuery = "SELECT COUNT(DISTINCT HospitalId) FROM Appointments WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(hospitalsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        object result = cmd.ExecuteScalar();
                        lblHospitals.Text = (result != null && result != DBNull.Value) ? result.ToString() : "0";
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                }
            }
        }

        private void LoadRecentAppointments(string userEmail)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"SELECT TOP 5 a.AppointmentDate, a.Status, d.Name AS DoctorName, h.Name AS HospitalName 
                                   FROM Appointments a 
                                   INNER JOIN Doctors d ON a.DoctorId = d.Id 
                                   INNER JOIN Hospitals h ON a.HospitalId = h.Id 
                                   WHERE a.PatientEmail = @Email 
                                   ORDER BY a.AppointmentDate DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        if (dt.Rows.Count > 0)
                        {
                            rptRecentAppointments.DataSource = dt;
                            rptRecentAppointments.DataBind();
                            pnlNoAppointments.Visible = false;
                        }
                        else
                        {
                            rptRecentAppointments.DataSource = null;
                            rptRecentAppointments.DataBind();
                            pnlNoAppointments.Visible = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle error
                    rptRecentAppointments.DataSource = null;
                    rptRecentAppointments.DataBind();
                    pnlNoAppointments.Visible = true;
                }
            }
        }

        private void LoadNotifications(string userEmail)
        {
            // Load notifications from database
            DataTable dt = new DataTable();
            dt.Columns.Add("Message");
            
            // TODO: Implement actual notification loading from database
            // This would query a Notifications table based on userEmail
            
            if (dt.Rows.Count > 0)
            {
                rptNotifications.DataSource = dt;
                rptNotifications.DataBind();
                pnlNoNotifications.Visible = false;
            }
            else
            {
                rptNotifications.DataSource = null;
                rptNotifications.DataBind();
                pnlNoNotifications.Visible = true;
            }
        }

        public string GetAppointmentStatusClass(string status)
        {
            switch (status.ToLower())
            {
                case "scheduled":
                    return "upcoming-appointment";
                case "completed":
                    return "past-appointment";
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
