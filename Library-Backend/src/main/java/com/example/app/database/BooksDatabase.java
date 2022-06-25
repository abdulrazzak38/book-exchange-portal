package com.example.app.database;

import com.example.app.MongoDBClient;
import com.example.app.entity.Email;
import com.example.app.entity.BookEntity;
import com.mongodb.*;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

@Component
public class BooksDatabase {

    MongoClient mongo = MongoDBClient.getMongo();

    public void addBook(BookEntity bookEntity) {
        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Books");

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("email", bookEntity.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        if (cursor.first() != null)
        {

            Document book = new Document();
            book.put("title", bookEntity.getBookTitle());
            book.put("author", bookEntity.getAuthor());
            book.put("edition", bookEntity.getEdition());
            book.put("publisher", bookEntity.getPublisher());
            book.put("year", bookEntity.getYear());
            book.put("availability", "1");

            collection.updateOne(eq("email", bookEntity.getEmail()), Updates.addToSet("books",book));
        }
        else {
            Document document = new Document();
            bookEntity.setAvailability("1");
            document.put("email", bookEntity.getEmail());
            Document book = new Document();
            book.put("title", bookEntity.getBookTitle());
            book.put("author", bookEntity.getAuthor());
            book.put("edition", bookEntity.getEdition());
            book.put("publisher", bookEntity.getPublisher());
            book.put("year", bookEntity.getYear());
            book.put("availability", "1");


            List<Document> array = new ArrayList<Document>();
            array.add(book);
            document.put("books",array);

            collection.insertOne(document);
        }


    }

    public List<String> getAllBooks() {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Books");
        List<String> bookList = new ArrayList<>();

        FindIterable<Document> cursor = collection.find();
        for (Document document : cursor) {

            List<Document> docList = document.get("books",List.class);

            for(Document doc:docList)
            {
                doc.put("email",document.get("email"));
                bookList.add(doc.toJson());
            }

        }

        return bookList;
    }

    public List<String> getUserBooks(Email email) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Books");
        List<String> bookList = new ArrayList<>();

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("email", email.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        for (Document document : cursor) {

            List<Document> docList = document.get("books",List.class);

            for(Document doc:docList)
            {
                doc.put("email",document.get("email"));
                bookList.add(doc.toJson());
            }

        }

        return bookList;
    }

    public void updateBookAvailability(BookEntity bookEntity) {


        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Books");
        List<Document> newBookList = new ArrayList<>();

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("email", bookEntity.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        Document doc = cursor.first();

        List<Document> oldBookList = doc.get("books",List.class);

        for(Document book:oldBookList)
        {
            if(book.get("title").equals(bookEntity.getBookTitle()) &&
                    book.get("author").equals(bookEntity.getAuthor()))
            {
                book.put("availability",bookEntity.getAvailability());
            }
            newBookList.add(book);

        }
        collection.updateOne(eq("email", bookEntity.getEmail()), Updates.set("books",newBookList));

    }


    public void deleteBook( BookEntity bookEntity)
    {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Books");
        List<Document> newBookList = new ArrayList<>();

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("email", bookEntity.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        Document doc = cursor.first();

        List<Document> oldBookList = doc.get("books",List.class);

        for(Document book:oldBookList)
        {
                if(book.get("title").equals(bookEntity.getBookTitle()) &&
                        book.get("author").equals(bookEntity.getAuthor()))
                {
                    continue;
                }
                newBookList.add(book);

        }
        collection.updateOne(eq("email", bookEntity.getEmail()), Updates.set("books",newBookList));

    }

    public boolean checkAvailability(BookEntity bookEntity)
    {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Books");

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("email", bookEntity.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        Document doc = cursor.first();

        List<Document> bookList = doc.get("books",List.class);
        for(Document book:bookList)
        {
            if(book.get("title").equals(bookEntity.getBookTitle()))
            {
                if(book.get("availability").equals("1"))
                    return  true;
            }

        }

        return false;
    }




}
