package com.example.app.controller;

import com.example.app.database.RequestsDatabase;
import com.example.app.entity.Email;
import com.example.app.entity.RequestsEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin
@RestController
public class RequestsController {

    @Autowired
    RequestsDatabase db ;

    @PostMapping(path = "/newrequest")
    public void addRequest(@RequestBody RequestsEntity requestsEntity)
    {
        db.addRequests(requestsEntity);
    }

    @PostMapping (path = "/requestlender")
    public List<String> getRequestLender(@RequestBody Email email)
    {
        return db.getRequestLender(email);
    }

    @PostMapping(path = "/requestborrower")
    public List<String> getRequestBorrower(@RequestBody Email email)
    {
        return db.getRequestBorrower(email);
    }

    @PatchMapping(path = "/updaterequest")
    public void updateRequest(@RequestBody RequestsEntity requestsEntity)
    {
        db.updateRequest(requestsEntity);
    }

    @GetMapping(path = "/viewtransactions")
    public List<String> getTransactions()
    {
        return db.getTransactions();
    }

    @DeleteMapping(path = "/deletetransaction")
    public void deleteTransactions(@RequestBody RequestsEntity requestsEntity)
    {
         db.deleteTransactions(requestsEntity);
    }
}
