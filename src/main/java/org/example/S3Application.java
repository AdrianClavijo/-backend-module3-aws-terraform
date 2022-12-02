package org.example;

import org.example.services.IAWSS3Service;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class S3Application {
    private IAWSS3Service awsS3Service;
    private final String bucketName = "bootcamp-backend-bucket2";

    public S3Application(IAWSS3Service awsS3Service) {
        this.awsS3Service = awsS3Service;
    }

    public void run() {
        String objectKey = "Documents/files/bootcamp.txt";
        String objectKey1 = "Documents/files/bootcamp1.txt";
        String objectKey2 = "Documents/files/bootcamp2.txt";
        String objectKey3 = "Documents/files/bootcamp3.txt";

        if (!this.awsS3Service.isBucketExist(bucketName)) {
            this.awsS3Service.createBucket(bucketName);
        } else {
            System.out.println("Bucket name exists!!!");
        }
        //uploading
        this.awsS3Service.uploadObject(bucketName,
                objectKey,
                new File("C:/Users/USUARIO/Documents/bootcamp.txt"));
        this.awsS3Service.uploadObject(bucketName,
                objectKey1,
                new File("C:/Users/USUARIO/Documents/bootcamp1.txt"));
        this.awsS3Service.uploadObject(bucketName,
                objectKey2,
                new File("C:/Users/USUARIO/Documents/bootcamp2.txt"));
        this.awsS3Service.uploadObject(bucketName,
                objectKey3,
                new File("C:/Users/USUARIO/Documents/bootcamp3.txt"));
        // get object and copy in Desktop/bootcamp.txt
        try {
            String newObjectKey = "Desktop/bootcamp.txt";
            String localFileOutputStream = "C:/Users/USUARIO/Documents/bootcamp_desktop.txt";
            S3Object o = awsS3Service.getObject(bucketName, objectKey);
            S3ObjectInputStream s3is = o.getObjectContent();
            FileOutputStream fos = new FileOutputStream(new File(localFileOutputStream));
            byte[] read_buf = new byte[1024];
            int read_len = 0;
            while ((read_len = s3is.read(read_buf)) > 0) {
                fos.write(read_buf, 0, read_len);
            }
            s3is.close();
            fos.close();
            this.awsS3Service.uploadObject(bucketName,
                newObjectKey,
                new File(localFileOutputStream));
        } catch (AmazonServiceException e) {
            System.err.println(e.getErrorMessage());
            System.exit(1);
        } catch (FileNotFoundException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        } catch (IOException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
        //copying from s3 bucket 1 to s3 bucket 2
        this.awsS3Service.copyObject("bootcamp-backend-bucket", "picture/pic.png",
                "bootcamp-backend-bucket2", "Documents/picture.png");
        //delete objects
        this.awsS3Service.deleteObjects(bucketName, objectKey1, objectKey2);
    }
}
