package org.example.utils;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage; // Thêm dòng này
import java.util.Properties;

public class EmailUtils {
    public static void sendEmail(String to, String subject, String content) throws MessagingException {
        final String user = "quyenlinh13102003@gmail.com";
        final String pass = "txxp uyct sjbb ogyl";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        // ĐỔI DÒNG NÀY:
        MimeMessage message = new MimeMessage(session);

        message.setFrom(new InternetAddress(user));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject, "UTF-8"); // Thêm UTF-8 để không lỗi font tiêu đề
        message.setContent(content, "text/html; charset=utf-8"); // Gửi dạng HTML cho đẹp

        Transport.send(message);
    }
}