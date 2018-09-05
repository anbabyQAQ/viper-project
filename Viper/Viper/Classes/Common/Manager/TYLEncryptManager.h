//
//  TYLEncryptManager.h
//  Nirvana
//
//  Created by puhui on 2017/9/20.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLEncryptManager : NSObject

/**
 AES加、解密的秘钥

 @return string: 加解密的秘钥
 */
+ (NSString *)AESEncryptKey;

/**
 AES128加密

 @param rawStr 明文
 @return 密文
 */
+ (NSString *)AES128Encrypt:(NSString *)rawStr;

/**
 AES128解密

 @param encrptStr 密文
 @return 原文
 */
+ (NSString *)AES128Decrypt:(NSString *)encrptStr;

/**
 MD5摘要

 @param rawStr 原始字符串
 @return 摘要字符串结果
 */
+ (NSString *)MD5:(NSString *)rawStr;

/**
 Sha256哈希处理
 
 @param rawStr 原始字符串
 @return 处理后的字符串
 */
+ (NSString *)Sha256:(NSString *)rawStr;

@end
