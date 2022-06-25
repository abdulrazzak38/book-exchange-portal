package com.example.app.database;

import com.example.app.MongoDBClient;
import com.example.app.entity.Email;
import com.example.app.entity.UserEntity;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class UsersDatabase {

    MongoClient mongo = MongoDBClient.getMongo();
    public void addUser(UserEntity userEntity) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        Document document = new Document();


        document.put("userID", userEntity.getId());
        document.put("userName", userEntity.getName());
        document.put("address", userEntity.getAddress());
        document.put("email", userEntity.getEmail());
        document.put("phoneNumber", userEntity.getPhoneNumber());
        document.put("password", userEntity.getPassword());
        document.put("balance", 0);
        document.put("fineAmount", 0);


        collection.insertOne(document);



    }

    public List<String> viewUser() {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        FindIterable<Document> cursor = collection.find();

        List<String> userList = new ArrayList<>();

        for (Document document : cursor) {

            userList.add(document.toJson());

        }

        return userList;

    }

    public void changePassword(UserEntity userEntity)
    {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        collection.updateOne(Filters.eq("email", userEntity.getEmail()), Updates.set("password",userEntity.getPassword()));
    }

    public void deleteUser(Email email) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        collection.deleteOne(Filters.eq("email", email.getEmail()));
    }

    public String getPassword(Email email) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        Document doc = collection.find(Filters.eq("email", email.getEmail())).first();

        if (doc != null) {
            return (String)doc.get("password");
        }else{
            return "";
        }

    }

    public void addBalance(UserEntity userEntity) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        Document doc = collection.find(Filters.eq("email", userEntity.getEmail())).first();

        collection.updateOne(Filters.eq("email", userEntity.getEmail()),Updates.set("balance",userEntity.getBalance()+(int)doc.get("balance")));

    }

    public void updateFine(UserEntity userEntity) {

        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        Document doc = collection.find(Filters.eq("email", userEntity.getEmail())).first();

        collection.updateOne(Filters.eq("email", userEntity.getEmail()),Updates.set("fineAmount",userEntity.getFineAmount()+(int)doc.get("fineAmount")));



    }

    public String getUserDetails(Email email)
    {
        MongoDatabase db = mongo.getDatabase("LibraryDatabase");
        MongoCollection<Document> collection = db.getCollection("Users");

        FindIterable<Document> cursor = collection.find(Filters.eq("email",email.getEmail()));

        Document userDetails = cursor.first();

        if (userDetails != null) {
            return userDetails.toJson();
        }else{
            return "";
        }

    }


}
