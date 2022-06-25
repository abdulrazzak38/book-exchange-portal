package com.example.app.database;

import com.example.app.MongoDBClient;
import com.example.app.entity.Email;
import com.example.app.entity.FineEntity;
import com.example.app.entity.UserEntity;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.springframework.stereotype.Component;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;


@Component
public class FineDatabase {

    MongoClient mongo = MongoDBClient.getMongo();
    public void addFine(FineEntity fineEntity) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Fines");

        Document document = new Document();



        document.put("email", fineEntity.getEmail());
        document.put("title", fineEntity.getTitle());
        document.put("fineAmount", fineEntity.getFineAmount());

        collection.insertOne(document);


    }
    public ArrayList<String> getUserFines(Email email)
    {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Fines");

        FindIterable<Document> cursor = collection.find(Filters.eq("email",email.getEmail()));

        ArrayList<String> fineList = new ArrayList<>();

        for (Document document : cursor) {

            fineList.add(document.toJson());

        }

        return fineList;

    }

    public String getTotalFineUser(Email email)
    {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        FindIterable<Document> cursor = collection.find(Filters.eq("email",email.getEmail()));

        int fine = (int) cursor.first().get("fineAmount");

        return String.valueOf(fine);

    }

    public void deleteFines(Email email) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Fines");

        collection.deleteMany(Filters.eq("email", email.getEmail()));
    }


}
