package com.example.app.controller;

import com.example.app.Otp;
import com.example.app.database.UsersDatabase;
import com.example.app.entity.Email;
import com.example.app.entity.UserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.List;

@CrossOrigin
@RestController
public class UserController {

    @Autowired
    UsersDatabase db ;
    Otp otp = new Otp();

    @PostMapping(path = "/newUser")
    public void addUser(@RequestBody UserEntity userEntity)
    {
        db.addUser(userEntity);
    }

    @GetMapping(path = "/viewuser")
    public List<String> viewUser()
    {
       return db.viewUser();
    }


    @PostMapping(path = "/getPassword")
    public String getPassword(@RequestBody Email email)
    {
        return db.getPassword(email);
    }

    @DeleteMapping(path = "/deleteuser")
    public void deleteUser(@RequestBody Email email)
    {
        db.deleteUser(email);
    }

    @PostMapping(path = "/sendotp")
    public String sendMail(@RequestBody Email email) throws MessagingException, IOException {

        return otp.sendmail(email);
    }
    @PatchMapping(path = "/changePassword")
    public void updatePassword(@RequestBody UserEntity userEntity)
    {
        db.changePassword(userEntity);
    }

    @PatchMapping(path = "/fine")
    public void updateFine(@RequestBody UserEntity userEntity)
    {
        db.updateFine(userEntity);
    }

    @PatchMapping(path = "/addBalance")
    public void updateBalance(@RequestBody UserEntity userEntity)
    {
        db.addBalance(userEntity);
    }

    @PostMapping(path = "/getUserDetails")
    public String getUserDetails(@RequestBody Email email)
    {
        return db.getUserDetails(email);
    }




}
