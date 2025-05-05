package com.example.ChatServer.Firebase;


import com.example.ChatServer.MessageSchema;

import java.util.ArrayList;
import java.util.HashMap;

import java.util.List;
import java.util.Map;


public class FirebaseSchema {
    public FirebaseSchema() {
    }
    public FirebaseSchema(String id,String email){
        setId(id);
        setName("");
        setEmail(email);
        setProfileUrl("");
        setContacts_RoomId(new HashMap<>());
        setMailBox(new ArrayList<>());
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Map<String, String> getContacts_RoomId() {
        return contacts_RoomId;
    }

    public void setContacts_RoomId(Map<String, String> contacts_RoomId) {
        this.contacts_RoomId = contacts_RoomId;
    }

    private String id;
    private String name;
    private String email;
private List mailBox;
private String profileUrl;

    public String getProfileUrl() {
        return profileUrl;
    }

    public void setProfileUrl(String profileUrl) {
        this.profileUrl = profileUrl;
    }

    public List getMailBox() {
        return mailBox;
    }

    public void setMailBox(List mailBox) {
        this.mailBox = mailBox;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    private Map<String,String> contacts_RoomId;




}
