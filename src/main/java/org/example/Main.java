package org.example;

import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.example.services.AWSS3Service;

public class Main {

    public static void main(String[] args) {
        AWSCredentialsProvider baseCredentials = new ProfileCredentialsProvider("default");

        AmazonS3 s3Client = AmazonS3ClientBuilder
                .standard()
                .withCredentials(baseCredentials)
                .withRegion(Regions.US_EAST_1)
                .build();

        AWSS3Service awss3Service = new AWSS3Service(s3Client);

        S3Application app = new S3Application(awss3Service);
        app.run();
    }
}