//
//  TYLBusinessUtil.h
//  Nirvana
//
//  Created by puhui on 2017/9/12.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

    /*
     *  业务逻辑相关的工具类
     */

#import <Foundation/Foundation.h>

@interface TYLBusinessUtil : NSObject

/**
 @Network
 根据module和interface，生成所需要的完整的url地址

 @param module 模块
 @param interface url中的接口（interface）
 @return url字符串
 */
+ (NSString *)generateUrlStrWithModule:(NSString *)module interface:(NSString *)interface;

/**
 生成网络请求中comm

 @return 字典,包括:pid,uuid...
 */
+ (NSDictionary *)generateCommNode;

/**
 @Netwrok
 生成网络请求中comm

 @param timeStamp 时间戳
 @return 字典,包括:pid,uuid...
 */

+ (NSDictionary *)generateCommNode:(NSTimeInterval)timeStamp;

+ (BOOL)doubleEqealWithValueA:(double)valueA valueB:(double)valueB;

/**
 获取app的版本号信息

 @return 版本号 eg: v1.0.0
 */
+ (NSString *)getAppVersion;

+ (NSString *)generateSign:(NSTimeInterval)timeStamp;

@end
