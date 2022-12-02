package org.example.services;

import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.CopyObjectResult;
import com.amazonaws.services.s3.model.PutObjectResult;
import com.amazonaws.services.s3.model.S3Object;

import java.io.File;

public interface IAWSS3Service {
    boolean isBucketExist(String bucketName);
    Bucket createBucket(String bucketName);
    PutObjectResult uploadObject(String bucketName, String key, File file);
    S3Object getObject(String bucketName, String key);
    CopyObjectResult copyObject(String sourceBucketName, String sourceObjKey, String destinationBucketName, String destinationObjKey);
    void deleteObject(String bucketName, String objectKey);
    void deleteObjects(String bucketName, String... objectsKeys);
}
