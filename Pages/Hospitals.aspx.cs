using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public partial class Hospitals : System.Web.UI.Page
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

                LoadHospitals();
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
                    
                    // Build the query with filters
                    string query = @"SELECT h.Id, h.Name, h.Address, h.Phone, h.Rating, h.Specializations, h.City
                                   FROM Hospitals h 
                                   WHERE 1=1";
                    
                    // Add search filter
                    if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                    {
                        query += " AND (h.Name LIKE @Search OR h.Address LIKE @Search)";
                    }
                    
                    // Add specialization filter
                    if (!string.IsNullOrEmpty(ddlSpecialization.SelectedValue))
                    {
                        query += " AND h.Specializations LIKE @Specialization";
                    }
                    
                    // Add city filter
                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
                    {
                        query += " AND h.City = @City";
                    }
                    
                    // Add rating filter
                    if (!string.IsNullOrEmpty(ddlRating.SelectedValue) && ddlRating.SelectedValue != "0")
                    {
                        query += " AND h.Rating >= @Rating";
                    }
                    
                    query += " ORDER BY h.Rating DESC, h.Name";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                        }
                        
                        if (!string.IsNullOrEmpty(ddlSpecialization.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@Specialization", "%" + ddlSpecialization.SelectedValue + "%");
                        }
                        
                        if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
                        }
                        
                        if (!string.IsNullOrEmpty(ddlRating.SelectedValue) && ddlRating.SelectedValue != "0")
                        {
                            cmd.Parameters.AddWithValue("@Rating", Convert.ToDouble(ddlRating.SelectedValue));
                        }
                        
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        
                        // Apply pagination
                        DataTable pagedData = GetPagedData(dt, currentPage, pageSize);
                        
                        rptHospitals.DataSource = pagedData;
                        rptHospitals.DataBind();
                        
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

        protected void ddlSpecialization_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadHospitals();
        }

        protected void ddlCity_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadHospitals();
        }

        protected void ddlRating_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadHospitals();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            currentPage = 1;
            LoadHospitals();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlSpecialization.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;
            ddlRating.SelectedIndex = 0;
            currentPage = 1;
            LoadHospitals();
        }

        protected void btnResetSearch_Click(object sender, EventArgs e)
        {
            btnClear_Click(sender, e);
        }

        protected void lnkPrevious_Click(object sender, EventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                LoadHospitals();
            }
        }

        protected void lnkNext_Click(object sender, EventArgs e)
        {
            currentPage++;
            LoadHospitals();
        }

        protected void btnBookAppointment_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandName == "BookAppointment")
            {
                string hospitalId = e.CommandArgument.ToString();
                // Store selected hospital info and redirect to appointment page
                Session["SelectedHospitalId"] = hospitalId;
                Response.Redirect("/pages/Appointments.aspx");
            }
        }

        public string GetHospitalImage(string hospitalId)
        {
            // TODO: Implement actual image loading from database
            // This would return the actual image path from the database
            return "/Images/hospital-placeholder.jpg";
        }

        public string GetStarRating(double rating)
        {
            string stars = "";
            int fullStars = (int)rating;
            bool hasHalfStar = rating % 1 >= 0.5;
            
            // Add full stars
            for (int i = 0; i < fullStars; i++)
            {
                stars += "<i class='fas fa-star'></i>";
            }
            
            // Add half star if needed
            if (hasHalfStar)
            {
                stars += "<i class='fas fa-star-half-alt'></i>";
            }
            
            // Add empty stars
            int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
            for (int i = 0; i < emptyStars; i++)
            {
                stars += "<i class='far fa-star'></i>";
            }
            
            return stars;
        }

        public string GetSpecializationBadges(string specializations)
        {
            if (string.IsNullOrEmpty(specializations))
                return "<span class='text-muted'>Bilgi yok</span>";
            
            string[] specs = specializations.Split(',');
            string badges = "";
            
            foreach (string spec in specs)
            {
                string trimmedSpec = spec.Trim();
                if (!string.IsNullOrEmpty(trimmedSpec))
                {
                    badges += string.Format("<span class='badge bg-primary specialization-badge'>{0}</span>", trimmedSpec);
                }
            }
            
            return badges;
        }
    }
}
