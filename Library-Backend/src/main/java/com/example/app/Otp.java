package com.example.app;

import com.example.app.entity.Email;
import org.springframework.stereotype.Service;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

@Service
public class Otp {
    public String sendmail(Email email) throws AddressException, MessagingException, IOException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");


        Random rand = new Random();

        int rand_int = rand.nextInt(1000);

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("your_mail", "your_password");
            }
        });
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress("your_mail", false));

        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email.getEmail()));
        msg.setSubject("OTP");
        msg.setContent(Integer.toString(rand_int), "text/html");
        msg.setSentDate(new Date());

        MimeBodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setContent(Integer.toString(rand_int), "text/html");

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);

        msg.setContent(multipart);
        Transport.send(msg);

        return Integer.toString(rand_int);
    }

}
