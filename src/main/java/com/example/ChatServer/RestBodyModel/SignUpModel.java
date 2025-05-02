package com.example.ChatServer.RestBodyModel;



public class SignUpModel {


    private String name;
private String email;
private String id;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }



    public String getCookie() {
        return cookie;
    }

    public void setCookie(String cookie) {
        this.cookie = cookie;
    }


    private String cookie;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }





}
