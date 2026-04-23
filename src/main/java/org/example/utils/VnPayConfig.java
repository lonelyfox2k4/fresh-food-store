package org.example.utils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.*;

public class VnPayConfig {

    public static final String VNP_URL          = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_TMN_CODE     = "0UE24Y6F";
    public static final String VNP_HASH_SECRET  = "UEOI36306JUHSCK1VZNHXZRVQJ1UEB09";
    public static final String VNP_VERSION      = "2.1.0";
    public static final String VNP_COMMAND      = "pay";
    public static final String VNP_ORDER_TYPE   = "other";

    // ✅ Di chuyển hàm vnpEncode vào đây để dùng chung
    public static String vnpEncode(String input) {
        try {
            return URLEncoder.encode(input, StandardCharsets.UTF_8.toString())
                    .replace("+", "%20")
                    .replace("%7E", "~");
        } catch (Exception e) {
            return "";
        }
    }

    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) throw new NullPointerException();
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            final SecretKeySpec secretKey = new SecretKeySpec(
                    key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", Byte.toUnsignedInt(b)));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | InvalidKeyException ex) {
            return "";
        }
    }

    public static String getIpAddress(HttpServletRequest request) {
        String ipAddr = request.getHeader("X-FORWARDED-FOR");
        if (ipAddr == null) ipAddr = request.getRemoteAddr();
        if (ipAddr == null || ipAddr.isEmpty() || "0:0:0:0:0:0:0:1".equals(ipAddr) || "::1".equals(ipAddr)) {
            ipAddr = "127.0.0.1";
        }
        return ipAddr;
    }

    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        List<String> joined = new ArrayList<>();
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                joined.add(fieldName + "=" + fieldValue);
            }
        }
        return hmacSHA512(VNP_HASH_SECRET, String.join("&", joined));
    }
}