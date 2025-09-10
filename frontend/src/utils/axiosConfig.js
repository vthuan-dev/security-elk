import axios from 'axios';

// Đặt URL cơ sở cho tất cả các yêu cầu API
// Sử dụng absolute URL để có thể truy cập từ bất kỳ domain nào
axios.defaults.baseURL = process.env.REACT_APP_API_URL || 'http://192.168.1.8:5001';

// Đặt tiêu đề chung
axios.defaults.headers.common['Content-Type'] = 'application/json';

// Request interceptor để thêm token
axios.interceptors.request.use(
  request => {
    // Lấy token từ localStorage cho mỗi request
    const token = localStorage.getItem('token');
    if (token) {
      request.headers.Authorization = `Bearer ${token}`;
    }
    console.log('API Request:', request);
    return request;
  },
  error => {
    return Promise.reject(error);
  }
);

// Response interceptor để xử lý lỗi
axios.interceptors.response.use(
  response => response,
  error => {
    console.error('API Error:', error.response || error);
    
    // Nếu lỗi 401 (Unauthorized), redirect về trang login
    if (error.response && error.response.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    
    return Promise.reject(error);
  }
);

export default axios;
