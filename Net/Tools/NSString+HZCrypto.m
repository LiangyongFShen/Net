//
//  NSString+HZCrypto.m
//  HZHttpRequest
//
//  Created by 汉子MacBook－Pro on 16/5/13.
//  Copyright © 2016年 汉子MacBook－Pro. All rights reserved.
//

#import "NSString+HZCrypto.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+HZCrypto.h"
#import "crc32.h"

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation NSString (HZCrypto)
- (NSString*) HZMD5 {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] HZMD5];
}

+ (NSString*)HZMd5Base64Code:(NSString*)bodyData {
    NSString * md5Str = [bodyData HZMD5];
    NSData * myData = [md5Str HZStringToHexData];
    return [myData HZBase64EncodedString];
}

+ (NSString*)HZHexMd5Base64Code:(NSString*)bodyData{
    NSData * myData = [bodyData HZStringToHexData];
    return [myData HZBase64EncodedString];
}

- (NSData *) HZStringToHexData
{
    NSInteger len = [self length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

+ (NSString *)HZHmacSHA256:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

+ (NSString *)HZGetFileMD5_SHA1_CRC32WithPath:(NSString *)path {
    return (__bridge_transfer NSString *)FileMD5_SHA1_CRC32HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFMutableStringRef FileMD5_SHA1_CRC32HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    
    // Declare needed variables
    CFStringRef resultMD5 = NULL;
    
    CFStringRef resultSHA1 = NULL;
    
    CFStringRef resultCRC32 =NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObjectMD5;
    
    CC_MD5_Init(&hashObjectMD5);
    
    CC_SHA1_CTX hashObjectSHA1;
    
    CC_SHA1_Init(&hashObjectSHA1);
    
    CC_CRC32_CTX hashObjectCRC32;
    
    CC_CRC32_Init(&hashObjectCRC32);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObjectMD5,(const void *)buffer,(CC_LONG)readBytesCount);
        
        CC_SHA1_Update(&hashObjectSHA1,(const void *)buffer,(CC_LONG)readBytesCount);
        
        CC_CRC32_Update(&hashObjectCRC32,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digestMD5[CC_MD5_DIGEST_LENGTH];//16
    
    unsigned char digestSHA1[CC_SHA1_DIGEST_LENGTH];//20
    
    unsigned char digestCRC32[CC_CRC32_DIGEST_LENGTH];//4
    
    CC_MD5_Final(digestMD5, &hashObjectMD5);
    
    CC_SHA1_Final(digestSHA1, &hashObjectSHA1);
    
    CC_CRC32_Final(digestCRC32, &hashObjectCRC32);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    // md5
    char hashMD5[2 * sizeof(digestMD5) + 1];
    
    for (size_t i = 0; i < sizeof(digestMD5); ++i) {
        
        snprintf(hashMD5 + (2 * i), 3, "%02x", (int)(digestMD5[i]));
        
    }
    
    resultMD5 = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hashMD5,kCFStringEncodingUTF8);
    
    // sha1
    char hashSHA1[2 * sizeof(digestSHA1) + 1];
    
    for (size_t i = 0; i < sizeof(digestSHA1); ++i) {
        
        snprintf(hashSHA1 + (2 * i), 3, "%02x", (int)(digestSHA1[i]));
        
    }
    
    resultSHA1 = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hashSHA1,kCFStringEncodingUTF8);
    
    // crc32
    char hashCRC32[2 * sizeof(digestCRC32) + 1];
    
    for (size_t i = 0; i < sizeof(digestCRC32); ++i) {
        
        snprintf(hashCRC32 + (2 * i), 3, "%02x", (int)(digestCRC32[i]));
        
    }
    
    resultCRC32 = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hashCRC32,kCFStringEncodingUTF8);
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    CFMutableStringRef mStr = (__bridge_retained CFMutableStringRef)[NSMutableString stringWithFormat:@"%@|%@|%@",resultMD5,resultSHA1,resultCRC32];
    
    return mStr;
}


@end
