package com.example.ChatServer.ImageKit;


import com.example.ChatServer.Firebase.FirebaseService;
import com.google.common.primitives.Bytes;
import io.imagekit.sdk.ImageKit;
import io.imagekit.sdk.exceptions.*;
import io.imagekit.sdk.models.FileCreateRequest;
import io.imagekit.sdk.models.results.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
public class ImageKitService {

    @Autowired
    public ImageKit imageKit;

    @Autowired
    public FirebaseService firebaseService;

    @PostMapping("/api/SetProfile")
    public void setprofile(@RequestParam MultipartFile file,@RequestParam String name,@RequestParam String isImage,@RequestParam String userid) throws IOException {
        System.out.println("started");

        String result=UploadFile(file,"example",isImage);
        System.out.println("result"+result);
        firebaseService.setProfile(result,name,userid);


    }

    public String UploadFile(MultipartFile file,String name,String isImage) throws IOException {
        try {
            Result result;

            if (isImage.equals("false")) {
                FileCreateRequest fileCreateRequest = new FileCreateRequest(
                        "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740", name + "Profile"
                );
                fileCreateRequest.setFolder("/Chatapp_Profile");

                result = imageKit.upload(fileCreateRequest);
            } else {
                byte[] bytes = file.getBytes();
                FileCreateRequest fileCreateRequest = new FileCreateRequest(bytes, name + "Profile");
                fileCreateRequest.setFolder("/Chatapp_Profile");
                result = imageKit.upload(fileCreateRequest);
            }

            return result.getUrl();

        } catch (InternalServerException | BadRequestException | UnknownException |
                 ForbiddenException | TooManyRequestsException | UnauthorizedException e) {
            // Log or rethrow based on your needs
            e.printStackTrace(); // or log with logger
            throw new RuntimeException("Image upload failed: " + e.getMessage());
        }
    }

}
