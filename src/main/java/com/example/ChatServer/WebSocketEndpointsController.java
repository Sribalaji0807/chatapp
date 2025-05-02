package com.example.ChatServer;

import com.example.ChatServer.Firebase.FirebaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;


@Controller
public class WebSocketEndpointsController {

    @Autowired
    private  SimpMessagingTemplate messagingTemplate;

    @Autowired
    private  WebSocketSessionStorage Session;
    @Autowired
    private FirebaseService firebaseService;



    @MessageMapping("/Exchange")
    public void sendToReceiver(MessageSchema message){
        String Sessionid=Session.getSessionId(message.getSendTo());
        if(Sessionid!=null){
System.out.println(message.getTime());
        System.out.println(message.getSendTo());
        System.out.println(message.getMessage());
       // messagingTemplate.convertAndSend("/Chats/receive",message);
messagingTemplate.convertAndSendToUser(message.getSendTo(),"/queue/messages",message);
    }else{
           firebaseService.StoreMailBox(message, message.getSendTo());
        }

    }


}
