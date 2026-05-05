package org.example.utils;

import java.util.regex.Pattern;

public class ValidationUtils {

    // Regex chuẩn cho Email
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";
    
    // Regex cho Mật khẩu: Ít nhất 8 ký tự, 1 chữ hoa, 1 chữ thường, 1 số
    private static final String PASSWORD_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$";
    
    // Regex cho Số điện thoại: Bắt đầu bằng 0 và đủ 10 chữ số
    private static final String PHONE_REGEX = "^0[0-9]{9}$";

    /**
     * Kiểm tra Email hợp lệ
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return Pattern.compile(EMAIL_REGEX).matcher(email).matches();
    }

    /**
     * Kiểm tra Mật khẩu hợp lệ: 6+ ký tự, đủ Hoa, Thường, Số
     */
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return Pattern.compile(PASSWORD_REGEX).matcher(password).matches();
    }

    /**
     * Kiểm tra Số điện thoại hợp lệ (10 số)
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return true; // Phone có thể trống tùy logic
        return Pattern.compile(PHONE_REGEX).matcher(phone).matches();
    }

    /**
     * Kiểm tra nội dung có chứa từ ngữ nhạy cảm/thô tục không
     */
    public static boolean hasSensitiveWords(String text) {
        if (text == null || text.trim().isEmpty()) return false;
        
        // Danh sách các từ nhạy cảm (Đã mở rộng đầy đủ hơn)
        String[] sensitiveWords = {
            "đm", "dm", "đmm", "dmm", "vcl", "vl", "vkl", "vcl", "vcc", "đệt",
            "cl", "clm", "cmn", "cc", "ccl", "cặc", "lồn", "đit", "địt", "đjt",
            "chó", "súc vật", "ngu", "đần", "mẹ mày", "bố mày", "con phò", "phò",
            "điếm", "điên", "khùng", "hâm", "hấp", "tổ sư", "khốn nạn", "vô học"
        };
        
        String lowerText = text.toLowerCase();
        for (String word : sensitiveWords) {
            if (lowerText.contains(word)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Kiểm tra danh sách các trường không được để trống
     */
    public static boolean isNonEmpty(String... fields) {
        for (String field : fields) {
            if (field == null || field.trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }
}
