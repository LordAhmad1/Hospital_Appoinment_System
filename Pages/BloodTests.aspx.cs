using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public partial class BloodTests : System.Web.UI.Page
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

                LoadBloodTests();
            }
        }

        private void LoadBloodTests()
        {
            string userEmail = User.Identity.Name;
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    
                    // Build the query with filters
                    string query = @"SELECT bt.Id, bt.TestName, bt.TestDate, bt.Result, bt.Unit, bt.ReferenceRange, 
                                          bt.Status, h.Name AS HospitalName, d.Name AS DoctorName
                                   FROM BloodTests bt 
                                   INNER JOIN Hospitals h ON bt.HospitalId = h.Id 
                                   INNER JOIN Doctors d ON bt.DoctorId = d.Id 
                                   WHERE bt.PatientEmail = @Email";
                    
                    // Add filters
                    if (!string.IsNullOrEmpty(ddlTestType.SelectedValue))
                    {
                        query += " AND bt.TestType = @TestType";
                    }
                    
                    if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                    {
                        query += " AND bt.Status = @Status";
                    }
                    
                    if (!string.IsNullOrEmpty(txtDateFrom.Text))
                    {
                        query += " AND bt.TestDate >= @DateFrom";
                    }
                    
                    if (!string.IsNullOrEmpty(txtDateTo.Text))
                    {
                        query += " AND bt.TestDate <= @DateTo";
                    }
                    
                    query += " ORDER BY bt.TestDate DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        
                        if (!string.IsNullOrEmpty(ddlTestType.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@TestType", ddlTestType.SelectedValue);
                        }
                        
                        if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
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
                        
                        rptBloodTests.DataSource = pagedData;
                        rptBloodTests.DataBind();
                        
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

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadBloodTests();
        }

        protected void ddlTestType_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadBloodTests();
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadBloodTests();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        { 
            currentPage = 1;
            LoadBloodTests();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlTestType.SelectedIndex = 0;
            ddlStatus.SelectedIndex = 0;
            txtDateFrom.Text = "";
            txtDateTo.Text = "";
            currentPage = 1;
            LoadBloodTests();
        }

        protected void lnkPrevious_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                LoadBloodTests();
            }
        }

        protected void lnkNext_Click(object sender, EventArgs e)
        {
            currentPage++;
            LoadBloodTests();
        }

        protected void btnViewDetails_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string testId = e.CommandArgument.ToString();
                // Redirect to test details page or show modal
                // For now, we'll just show an alert
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showDetails", 
                    string.Format("alert('Test ID: {0} details will be displayed');", testId), true);
            }
        }

        public string GetResultClass(string status)
        {
            switch (status.ToLower())
            {
                case "normal":
                    return "normal-result";
                case "abnormal":
                    return "abnormal-result";
                case "pending":
                    return "pending-result";
                default:
                    return "";
            }
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "normal":
                    return "bg-success";
                case "abnormal":
                    return "bg-danger";
                case "pending":
                    return "bg-warning";
                default:
                    return "bg-secondary";
            }
        }

        public string GetValueClass(string status)
        {
            switch (status.ToLower())
            {
                case "normal":
                    return "normal-value";
                case "abnormal":
                    return "abnormal-value";
                case "pending":
                    return "pending-value";
                default:
                    return "";
            }
        }

        public string GetStatusText(string status)
        {
            switch (status.ToLower())
            {
                case "normal":
                    return "Normal";
                case "abnormal":
                    return "Anormal";
                case "pending":
                    return "Beklemede";
                default:
                    return status;
            }
        }
    }
}
