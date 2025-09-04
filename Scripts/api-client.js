/**
 * Hospital Appointment System API Client
 * Provides easy-to-use methods to interact with the backend API
 */

class HospitalApiClient {
    constructor(baseUrl = '') {
        this.baseUrl = baseUrl;
        this.token = localStorage.getItem('authToken') || sessionStorage.getItem('authToken');
        this.apiPath = '/App_Code/ApiController.asmx';
    }

    // Set authentication token
    setToken(token, rememberMe = false) {
        this.token = token;
        if (rememberMe) {
            localStorage.setItem('authToken', token);
        } else {
            sessionStorage.setItem('authToken', token);
        }
    }

    // Clear authentication token
    clearToken() {
        this.token = null;
        localStorage.removeItem('authToken');
        sessionStorage.removeItem('authToken');
    }

    // Generic API call method
    async callApi(methodName, params = {}) {
        try {
            const url = this.baseUrl + this.apiPath + '/' + methodName;
            
            // Create form data for POST request
            const formData = new FormData();
            Object.keys(params).forEach(key => {
                formData.append(key, params[key]);
            });

            const response = await fetch(url, {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const text = await response.text();
            
            // Parse XML response to extract JSON
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(text, 'text/xml');
            const resultElement = xmlDoc.querySelector('string');
            
            if (resultElement) {
                const jsonString = resultElement.textContent;
                return JSON.parse(jsonString);
            } else {
                throw new Error('Invalid API response format');
            }
        } catch (error) {
            console.error('API call error:', error);
            throw error;
        }
    }

    // Authentication Methods
    async login(email, password, rememberMe = false) {
        const result = await this.callApi('Login', { email, password });
        if (result.success) {
            this.setToken(result.token, rememberMe);
        }
        return result;
    }

    async register(firstName, lastName, email, password, phone = '', nationalId = '') {
        const result = await this.callApi('Register', { 
            firstName, lastName, email, password, phone, nationalId 
        });
        if (result.success) {
            this.setToken(result.token, false);
        }
        return result;
    }

    async refreshToken() {
        if (!this.token) {
            throw new Error('No token available for refresh');
        }
        const result = await this.callApi('RefreshToken', { token: this.token });
        if (result.success) {
            this.setToken(result.token, localStorage.getItem('authToken') !== null);
        }
        return result;
    }

    logout() {
        this.clearToken();
        window.location.href = '/pages/Login.aspx';
    }

    // Profile Methods
    async getProfile() {
        if (!this.token) {
            throw new Error('Authentication required');
        }
        return await this.callApi('GetProfile', { token: this.token });
    }

    async updateProfile(firstName, lastName, phone = '', nationalId = '', dateOfBirth = '') {
        if (!this.token) {
            throw new Error('Authentication required');
        }
        return await this.callApi('UpdateProfile', { 
            token: this.token, firstName, lastName, phone, nationalId, dateOfBirth 
        });
    }

    // Appointment Methods
    async getAppointments() {
        if (!this.token) {
            throw new Error('Authentication required');
        }
        return await this.callApi('GetAppointments', { token: this.token });
    }

    async createAppointment(hospitalId, doctorId, appointmentDate, appointmentTime) {
        if (!this.token) {
            throw new Error('Authentication required');
        }
        return await this.callApi('CreateAppointment', { 
            token: this.token, hospitalId, doctorId, appointmentDate, appointmentTime 
        });
    }

    async cancelAppointment(appointmentId) {
        if (!this.token) {
            throw new Error('Authentication required');
        }
        return await this.callApi('CancelAppointment', { 
            token: this.token, appointmentId 
        });
    }

    // Hospital and Doctor Methods
    async getHospitals() {
        return await this.callApi('GetHospitals');
    }

    async getDoctors(hospitalId = 0) {
        const params = hospitalId > 0 ? { hospitalId } : {};
        return await this.callApi('GetDoctors', params);
    }

    // Statistics Methods
    async getUserStatistics() {
        if (!this.token) {
            throw new Error('Authentication required');
        }
        return await this.callApi('GetUserStatistics', { token: this.token });
    }

    // Utility Methods
    isAuthenticated() {
        return this.token !== null;
    }

    getToken() {
        return this.token;
    }

    // Check if token is expired
    async isTokenExpired() {
        if (!this.token) {
            return true;
        }
        
        try {
            // Try to refresh token to check if it's valid
            await this.refreshToken();
            return false;
        } catch (error) {
            return true;
        }
    }

    // Auto-refresh token if needed
    async ensureValidToken() {
        if (await this.isTokenExpired()) {
            throw new Error('Token expired and could not be refreshed');
        }
    }
}

// Create global instance
window.hospitalApi = new HospitalApiClient();

// Auto-refresh token every 30 minutes
setInterval(async () => {
    if (window.hospitalApi.isAuthenticated()) {
        try {
            await window.hospitalApi.refreshToken();
        } catch (error) {
            console.warn('Token refresh failed:', error);
        }
    }
}, 30 * 60 * 1000);

// Handle token expiration on page load
document.addEventListener('DOMContentLoaded', async () => {
    if (window.hospitalApi.isAuthenticated()) {
        try {
            await window.hospitalApi.ensureValidToken();
        } catch (error) {
            console.warn('Token validation failed:', error);
            window.hospitalApi.logout();
        }
    }
});

// Example usage functions
window.apiExamples = {
    // Login example
    loginExample: async function() {
        try {
            const result = await window.hospitalApi.login('user@example.com', 'password', true);
            if (result.success) {
                console.log('Login successful:', result.user);
                // Redirect to dashboard or update UI
            } else {
                console.error('Login failed:', result.message);
            }
        } catch (error) {
            console.error('Login error:', error);
        }
    },

    // Get profile example
    getProfileExample: async function() {
        try {
            const result = await window.hospitalApi.getProfile();
            if (result.success) {
                console.log('Profile:', result.profile);
                // Update UI with profile data
            } else {
                console.error('Get profile failed:', result.message);
            }
        } catch (error) {
            console.error('Get profile error:', error);
        }
    },

    // Create appointment example
    createAppointmentExample: async function() {
        try {
            const result = await window.hospitalApi.createAppointment(
                1, // hospitalId
                1, // doctorId
                '2024-12-25', // appointmentDate
                '10:00' // appointmentTime
            );
            if (result.success) {
                console.log('Appointment created successfully');
                // Update UI or show success message
            } else {
                console.error('Create appointment failed:', result.message);
            }
        } catch (error) {
            console.error('Create appointment error:', error);
        }
    },

    // Get appointments example
    getAppointmentsExample: async function() {
        try {
            const result = await window.hospitalApi.getAppointments();
            if (result.success) {
                console.log('Appointments:', result.appointments);
                // Update UI with appointments list
            } else {
                console.error('Get appointments failed:', result.message);
            }
        } catch (error) {
            console.error('Get appointments error:', error);
        }
    }
};
