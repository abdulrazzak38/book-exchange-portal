package com.example.app;

import com.mongodb.MongoClient;
import org.springframework.stereotype.Component;


public class MongoDBClient {

    private static final MongoClient mongo = new MongoClient("localhost", 27017);

    private MongoDBClient(){

    }

    public static MongoClient getMongo() {
        return mongo;
    }
}
