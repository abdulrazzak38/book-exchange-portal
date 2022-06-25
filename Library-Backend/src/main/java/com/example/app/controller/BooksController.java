package com.example.app.controller;

import com.example.app.database.BooksDatabase;
import com.example.app.entity.BookEntity;
import com.example.app.entity.Email;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin
@RestController
public class BooksController {

    @Autowired
    BooksDatabase db ;


    @PostMapping(path = "/newBook")
    public void addBook(@RequestBody BookEntity bookEntity)
    {
        db.addBook(bookEntity);
    }


    @GetMapping(path = "/listBooks")
    public List<String> getBooks()
    {
        return db.getAllBooks();
    }

    @PatchMapping(path = "/updateAvailability")
    public void updateAvailability(@RequestBody BookEntity bookEntity)
    {
        db.updateBookAvailability(bookEntity);
    }

    @PostMapping(path = "/listUserBooks")
    public List<String> getUserBooks(@RequestBody Email email)
    {
        return db.getUserBooks(email);
    }

    @DeleteMapping(path = "/deletebook")
    public void deleteBook(@RequestBody BookEntity bookEntity)
    {
        db.deleteBook(bookEntity);
    }

    @PostMapping(path = "/checkAvailability")
    public boolean checkAvailability(@RequestBody BookEntity bookEntity)
    {
        return db.checkAvailability(bookEntity);
    }


}
