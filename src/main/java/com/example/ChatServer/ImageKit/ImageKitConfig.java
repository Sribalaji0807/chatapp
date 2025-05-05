package com.example.ChatServer.ImageKit;

import io.imagekit.sdk.ImageKit;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

@Configuration
public class ImageKitConfig {

    @Bean
    public ImageKit imageKitBean() throws IOException {
        Properties props = new Properties();
        try (FileInputStream file = new FileInputStream("/etc/secrets/config.properties")) {
            props.load(file);
        }



        ImageKit imageKit = ImageKit.getInstance();
        imageKit.setConfig(new io.imagekit.sdk.config.Configuration(
                props.getProperty("PublicKey"),
                props.getProperty("PrivateKey"),
                props.getProperty("UrlEndpoint")
        ));

        return imageKit;
    }
}
