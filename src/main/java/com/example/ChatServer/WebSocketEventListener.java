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
       String userid=accessor.getFirstNativeHeader("userid");
      System.out.println(userid);
       String sessionId=accessor.getSessionId();
       if(userid!=null){
          session.addSession(userid,sessionId);
       }
   }
   @EventListener
   public void handleWebSocketDisconnectListener(SessionDisconnectEvent event){
      String sessionId=event.getSessionId();
      session.removeSession(sessionId);
   }

}
