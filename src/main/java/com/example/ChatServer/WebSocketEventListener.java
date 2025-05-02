package com.example.ChatServer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.sql.SQLOutput;

@Component
public class WebSocketEventListener {

   @Autowired
   private WebSocketSessionStorage session;

   @EventListener
    public void handleWebSocketConnectListener(SessionConnectEvent event){
       StompHeaderAccessor accessor=StompHeaderAccessor.wrap(event.getMessage());
       String username=accessor.getFirstNativeHeader("username");
      System.out.println(username);
       String sessionId=accessor.getSessionId();
       if(username!=null){
          session.addSession(username,sessionId);
       }
   }
   @EventListener
   public void handleWebSocketDisconnectListener(SessionDisconnectEvent event){
      String sessionId=event.getSessionId();
      session.removeSession(sessionId);
   }

}
