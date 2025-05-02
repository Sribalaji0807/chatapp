package com.example.ChatServer;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;

@Service
public class WebSocketSessionStorage {
    private final ConcurrentHashMap<String,String> userSessionMap=new ConcurrentHashMap<>();

    public String getSessionId(String name){
        if(userSessionMap.containsKey(name)){
            return userSessionMap.get(name);
        }
        return null;
    }
    public void addSession(String key,String value){
        userSessionMap.put(key,value);
    }
    public void removeSession(String key){
        userSessionMap.remove(key);
    }
}
