//
//  TYLEncryptManager.m
//  Nirvana
//
//  Created by puhui on 2017/9/20.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLEncryptManager.h"
#import <CommonCrypto/CommonCrypto.h>

NSString *const kInitVector = @"f56e3bfec5823ed1";      /**< 初始向量IV，需要和server端协商一致*/
size_t const kKeySize1 = kCCKeySizeAES128;

@implementation TYLEncryptManager

+ (NSString *)AESEncryptKey {
    NSString *pid = [UIDevice PID];
    
    if (!pid) {
        return @"";
    }
    
    return [pid substringWithRange:NSMakeRange(0, 16)];
}

+ (NSString *)MD5:(NSString *)rawStr {
    NSAssert(rawStr, @"MD5 : rawString not null");
    return [[[rawStr dataUsingEncoding:NSUTF8StringEncoding] md5String] uppercaseString];
}

+ (NSString *)AES128Encrypt:(NSString *)rawStr {
    NSAssert(rawStr, @"Encrypt : rawStr not nil");
    NSString *key = [self AESEncryptKey];
    NSAssert(key, @"Encrypt : key not nil");
    
    NSData *contentData = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encrptedData = [self AESEncryptData:contentData keyData:keyData];

    return [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];;
}

+ (NSString *)AES128Decrypt:(NSString *)encrptStr {
    NSAssert(encrptStr, @"Encrypt : encrptStr not nil");
    NSString *key = [self AESEncryptKey];
    NSAssert(key, @"Encrypt : key not nil");
    
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:encrptStr
                                                              options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [self AESDecryptData:contentData keyData:keyData];
    
    return [[NSString alloc] initWithData:decryptedData
                                 encoding:NSUTF8StringEncoding];;
}

#pragma mark -
#pragma mark Private Method for res128

+ (NSData *)AESEncryptData:(NSData *)contentData keyData:(NSData *)keyData {
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize1 * 8, kKeySize1];
    NSCAssert(keyData.length == kKeySize1, hint);

    return  [self cipherOperationWithContentData:contentData keyData:keyData operation:kCCEncrypt];
}

+ (NSData *)AESDecryptData:(NSData *)contentData keyData:(NSData *)keyData {
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize1 * 8, kKeySize1];
    NSCAssert(keyData.length == kKeySize1, hint);

    return [self cipherOperationWithContentData:contentData keyData:keyData operation:kCCDecrypt];
}

+ (NSData *)cipherOperationWithContentData:(NSData *)contentData keyData:(NSData *)keyData operation:(CCOperation)operation {
    NSUInteger dataLength = contentData.length;
    
    void const *initVectorBytes = [kInitVector dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    size_t actualOutSize = 0;
    
    /*
     使用aes128，cbc模式，数据填充采用kCCOptionPKCS7Padding
     */
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kKeySize1,
                                          initVectorBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    
    return nil;
}

+ (NSString *)Sha256:(NSString *)rawStr  {
//    const char *s = [rawStr cStringUsingEncoding:NSASCIIStringEncoding];
//    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // 用上面的方法中文字符串转data时会造成数据丢失
    NSData *keyData = [rawStr dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

@end
