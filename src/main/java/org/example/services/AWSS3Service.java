package org.example.services;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.CopyObjectResult;
import com.amazonaws.services.s3.model.DeleteObjectsRequest;
import com.amazonaws.services.s3.model.PutObjectResult;
import com.amazonaws.services.s3.model.S3Object;

import java.io.File;

public class AWSS3Service implements IAWSS3Service {
    private final AmazonS3 s3Client;

    public AWSS3Service(AmazonS3 s3Client) {
        this.s3Client = s3Client;
    }

    @Override
    public boolean isBucketExist(String bucketName) {
        return this.s3Client.doesBucketExistV2(bucketName);
    }

    @Override
    public Bucket createBucket(String bucketName) {
        return this.s3Client.createBucket(bucketName);
    }

    @Override
    public PutObjectResult uploadObject(String bucketName, String key, File file) {
        return this.s3Client.putObject(bucketName, key, file);
    }

    @Override
    public CopyObjectResult copyObject(String sourceBucketName, String sourceObjKey, String destinationBucketName, String destinationObjKey) {
        return this.copyObject(sourceBucketName, sourceObjKey, destinationBucketName, destinationObjKey);
    }

    @Override
    public void deleteObject(String bucketName, String objectKey) {
        this.s3Client.deleteObject(bucketName, objectKey);
    }

    @Override
    public S3Object getObject(String bucketName, String objectKey) {
        return this.s3Client.getObject(bucketName, objectKey);
    }

    // @Override
    // public void deleteObjects(String bucketName, List<String> objectsKeys) {
    //     for (String objKey: objectsKeys) {
    //         this.deleteObject(bucketName, objKey);
    //     }
    //     // objectsKeys.stream().map(objKey -> {this.deleteObject(bucketName, objKey) return objKey});
    // }
    @Override
    public void deleteObjects(String bucketName, String... objectsKeys) {
        try {
            DeleteObjectsRequest dor = new DeleteObjectsRequest(bucketName)
                    .withKeys(objectsKeys);
            s3Client.deleteObjects(dor);
        } catch (AmazonServiceException e) {
            System.err.println(e.getErrorMessage());
            System.exit(1);
        }
    }
}
