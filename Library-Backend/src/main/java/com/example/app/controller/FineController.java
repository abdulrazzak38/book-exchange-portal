package com.example.app.controller;

import com.example.app.database.FineDatabase;
import com.example.app.entity.Email;
import com.example.app.entity.FineEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@CrossOrigin
@RestController
public class FineController {

    @Autowired
    FineDatabase db ;

    @PostMapping(path = "/createFine")
    public void addFine(@RequestBody FineEntity fineEntity)
    {
        db.addFine(fineEntity);
    }

    @PostMapping(path = "/getUserFines")
    public ArrayList<String> getUserFines(@RequestBody Email email)
    {
        return db.getUserFines(email);
    }

    @PostMapping(path = "/getTotalFineUser")
    public String getTotalFineUser(@RequestBody Email email)
    {
        return db.getTotalFineUser(email);
    }

    @DeleteMapping(path = "/deleteFine")
    public void deleteFines(@RequestBody Email email)
    {
        db.deleteFines(email);
    }




}



