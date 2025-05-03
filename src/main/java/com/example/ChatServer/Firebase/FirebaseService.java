package com.example.ChatServer.Firebase;

import com.example.ChatServer.MessageSchema;
import com.example.ChatServer.RestBodyModel.SignUpModel;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.google.firebase.database.GenericTypeIndicator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

import javax.print.Doc;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;


@RestController
public class FirebaseService {

    @Autowired
    public Firestore firestore;
    @Autowired
    public FirebaseAuth firebaseAuth;

@PostMapping("/api/SignUp")
    public boolean SignUp(@RequestBody SignUpModel body){
    try {
        System.out.println("start");
        System.out.println(body.getId());
        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(body.getCookie());
        if(decodedToken!=null){
            return addDocument(new FirebaseSchema(decodedToken.getUid(), body.getName(),body.getEmail()));
        }
        return false;
    } catch (Exception e) {

        System.out.println(e.getMessage());
        return false;
    }

}
//@PostMapping("/api/Login")
//public FirebaseSchema Login(@RequestBody String data) {
//    try {
//        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(data);
//        if(decodedToken!=null){
//            return getDocument(decodedToken.getUid());
//        }
//        return null;
//    }catch (FirebaseAuthException | ExecutionException | InterruptedException e){
//        System.out.println(e.getMessage());
//        return null;
//    }
//}

@PostMapping("/api/Login")
public FirebaseSchema Login(@RequestBody SignUpModel body){
    try {
        
        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(body.getCookie());
if(decodedToken!=null){
    return getDocument(decodedToken.getUid());
}
return null;
    }catch (FirebaseAuthException | ExecutionException | InterruptedException e){
        System.out.println(e.getMessage());
        return null;
    }
}


public void StoreMailBox(MessageSchema messageSchema,String username){
    try{
        ApiFuture<QuerySnapshot> query = firestore.collection("users")
                .whereEqualTo("name", username)
                .get();

        List<QueryDocumentSnapshot> documents = query.get().getDocuments();

        if (!documents.isEmpty()) {
            QueryDocumentSnapshot firstDoc = documents.get(0);
          ApiFuture<WriteResult> future=firestore.collection("users").document(firstDoc.getId()).update("mailBox",FieldValue.arrayUnion(messageSchema));
        }    }
    catch (FirestoreException | ExecutionException | InterruptedException e){
        System.out.println(e.getMessage());

    }
}
@GetMapping("/api/StoredMessages")
public List<MessageSchema> getStoredMessages(@RequestParam String userid){
    List<MessageSchema> messages = new ArrayList<>();
    System.out.println("userid"+userid);

    try{
    DocumentReference docRef= firestore.collection("users").document(userid);
    ApiFuture<DocumentSnapshot> future=docRef.get();
    DocumentSnapshot document=future.get();
    if (document.exists()) {
        List<Map<String, Object>> messageMaps = (List<Map<String, Object>>) document.get("mailBox");

        if (messageMaps != null) {
            for (Map<String, Object> messageMap : messageMaps) {
                MessageSchema message = new MessageSchema();
                message.setMessage((String) messageMap.get("message"));
                message.setSendBy((String) messageMap.get("sendBy"));
                message.setSendTo((String) messageMap.get("sendTo"));
                message.setTime((String) messageMap.get("time"));

                messages.add(message);
            }
        }
//        Map<String, Object> updates = new HashMap<>();
//        updates.put("mailBox", new ArrayList<>()); // Empty list
//
//        docRef.update(updates);
    }
}
catch (FirestoreException  | InterruptedException e){
    System.out.println(e);

} catch (ExecutionException e) {
    throw new RuntimeException(e);
}
    return messages;
}

//@PostMapping("/api/Contacts")
//public Map<String,String> getContacts(@RequestBody String username){
//    DocumentReference docRef = firestore.collection("users").where("name",isEqualTo:username).get();
//    ApiFuture<DocumentSnapshot> future = docRef.get();
//    DocumentSnapshot document = future.get();
//}

//@PostMapping("/api/Contacts")
//public boolean addContacts(String id1,String id2){
//    try {
//        Map<String, Object> messageData = new HashMap<>();
//        messageData.put("participates",new String[]{id1,id2});
//        messageData.put("createdAt",System.currentTimeMillis());
//        messageData.put("messages",new ArrayList<>());
//        ApiFuture<DocumentReference> doc =firestore.collection("Messages").add(messageData);
//        DocumentReference chatDoc = doc.get();
//        DocumentSnapshot user1 = firestore.collection("users").document(id1).get().get();
//        DocumentSnapshot user2 = firestore.collection("users").document(id2).get().get();
//        Map<String,String>tempContact=new HashMap<>();
//        tempContact.put(id2,chatDoc.getId());
//       // WriteResult write=firestore.collection("users").document(id1).update(tempContact);
//
//return true;
//
//    }
//    catch (FirestoreException e){
//        System.out.println(e.getMessage());
//    } catch (ExecutionException e) {
//        throw new RuntimeException(e);
//    } catch (InterruptedException e) {
//        throw new RuntimeException(e);
//    }
//    return false;
//}

public boolean addDocument(FirebaseSchema user) throws ExecutionException, InterruptedException {
    WriteResult doc=firestore.collection("users").document(user.getId()).set(user).get();
    if (doc != null) {
        return true;
    } else {
        return false;
    }
}

    public FirebaseSchema getDocument(String id) throws ExecutionException, InterruptedException {
        DocumentReference docRef = firestore.collection("users").document(id);
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();

        if (document.exists()) {
            FirebaseSchema schema = new FirebaseSchema();

            // Set simple fields manually
            schema.setName(document.getString("name"));
            schema.setEmail(document.getString("email"));
            schema.setId(document.getString("id"));
            Map<String, String> contactsRoomId = (Map<String, String>) document.get("contacts_RoomId");
            schema.setContacts_RoomId(contactsRoomId);
            // etc...

            // Set mailBox field using GenericTypeIndicator
            List<Map<String, String>> mailBox = new ArrayList<>();
            List<Object> rawList = (List<Object>) document.get("mailBox");
            if (rawList != null) {
                for (Object item : rawList) {
                    if (item instanceof Map) {
                        Map<String, String> map = new HashMap<>();
                        Map<?, ?> rawMap = (Map<?, ?>) item;
                        for (Map.Entry<?, ?> entry : rawMap.entrySet()) {
                            map.put(entry.getKey().toString(), entry.getValue().toString());
                        }
                        mailBox.add(map);
                    }
                }
            }
            schema.setMailBox(mailBox);

            return schema;
        } else {
            return null; // Handle case where document doesn't exist
        }
    }





}
