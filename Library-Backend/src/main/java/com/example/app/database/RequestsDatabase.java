package com.example.app.database;

import com.example.app.MongoDBClient;
import com.example.app.entity.Email;
import com.example.app.entity.RequestsEntity;
import com.mongodb.BasicDBObject;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

@Component
public class RequestsDatabase {

    MongoClient mongo = MongoDBClient.getMongo();
    public void addRequests(RequestsEntity requestsEntity)
    {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Requests");

        Document document = new Document();


        document.put("borrower", requestsEntity.getBorrower());
        document.put("lender", requestsEntity.getLender());
        document.put("title", requestsEntity.getTitle());
        document.put("status", requestsEntity.getStatus());
        document.put("place", "NULL");
        document.put("date", "NULL");
        document.put("time", "NULL");
        document.put("holdPeriod", requestsEntity.getHoldPeriod());


        collection.insertOne(document);


    }


    public List<String> getRequestLender(Email email) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Requests");

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("lender", email.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        List<String> requestsList = new ArrayList<>();

        for (Document document : cursor) {

            requestsList.add(document.toJson());

        }

        return requestsList;


    }

    public List<String> getRequestBorrower(Email email) {


        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Requests");

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("borrower", email.getEmail());
        FindIterable<Document> cursor = collection.find(whereQuery);

        List<String> requestsList = new ArrayList<>();

        for (Document document : cursor) {

            requestsList.add(document.toJson());

        }

        return requestsList;

    }

    public void updateRequest(RequestsEntity requestsEntity) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> requestsCollection = db.getCollection("Requests");
        MongoCollection<Document> bookCollection = db.getCollection("Books");

        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("email", requestsEntity.getLender());
        FindIterable<Document> cursor = bookCollection.find(whereQuery);

        Document doc = cursor.first();

        List<Document> oldBookList = doc.get("books",List.class);
        List<Document> newBookList = new ArrayList<>();

        for(Document book:oldBookList)
        {
            if(book.get("title").equals(requestsEntity.getTitle()))
            {
                String status = requestsEntity.getStatus();
                if(status.equals("1"))
                {
                    book.put("availability","0");

                }else{
                    book.put("availability","1");
                }

            }
            newBookList.add(book);

        }
        bookCollection.updateOne(eq("email", requestsEntity.getLender()), Updates.set("books",newBookList));

        ArrayList<Bson> updateListRequests = new ArrayList<>();
        updateListRequests.add(Updates.set("status",requestsEntity.getStatus()));
        updateListRequests.add(Updates.set("place",requestsEntity.getPlace()));
        updateListRequests.add(Updates.set("time",requestsEntity.getTime()));
        updateListRequests.add(Updates.set("date",requestsEntity.getDate()));
        updateListRequests.add(Updates.set("holdPeriod",requestsEntity.getHoldPeriod()));



        requestsCollection.updateMany(and(eq("lender",requestsEntity.getLender()),
                        eq("borrower",requestsEntity.getBorrower()),eq("title",requestsEntity.getTitle())),
                updateListRequests);

    }

    public List<String> getTransactions() {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Requests");

        FindIterable<Document> cursor = collection.find();

        List<String> requestsList = new ArrayList<>();

        for (Document document : cursor) {

            requestsList.add(document.toJson());

        }

        return requestsList;

    }


    public void deleteTransactions(RequestsEntity requestsEntity) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Requests");

        collection.deleteOne(and(eq("lender",requestsEntity.getLender()),
                eq("borrower",requestsEntity.getBorrower()),eq("title",requestsEntity.getTitle())));

    }

}
