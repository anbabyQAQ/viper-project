//
//  TYLBusinessUtil.m
//  Nirvana
//
//  Created by puhui on 2017/9/12.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLBusinessUtil.h"

@import AdSupport;

@implementation TYLBusinessUtil

+ (NSString *)generateUrlStrWithModule:(NSString *)module interface:(NSString *)interface {
    if ([module isEqualToString:@"user"] && [interface isEqualToString:@"loginRegisterBySms"]) { //注册登录接口
        return [NSString stringWithFormat:@"%@/%@/%@", dBASE_URL_HTTP, module, interface];
    }

    return [NSString stringWithFormat:@"%@/%@/%@", dBASE_URL_HTTP, module, interface];
}

/*
 comm:{
     pid:"",
     pidType:"",
     type:""(1安卓手机,2苹果手机),
     package:"",
     versionCode:"",
     version:"",
     us:"",
     cellPhoneType:""(iphone3,2),
     systemVersion:"",
     clientDatetime:1505191340235，
     trackerId:"21c8dffd-bacd-4e7f-a5f7-7fee072ed583"
 
     pid(设备ID):设备ID,IOS优先取idfa、uuid，Android客户端优先取imei、androidid、mac，Web客户端由服务器注入2年失效期的cookie
     pidType(pid种类):idfa、imei、uuid、androidid、mac
     type(系统类型):1:android手机,2:苹果手机
     package(包版本):1:老钱站、2:钱站（尊享版）、3:钱站(抢鲜版)、4:新版钱站、99:古钱币
     version(应用版本):V3.0.1、V5.0.0
     versionCode(应用版本code)
     us(渠道code)
     cellPhoneType(手机版本):iphone3,2,mi750
     systemVersion(操作系统版本):ios10.0.3、android6.5
     clientDatetime(客户端时间戳):精确到ms，同java时间戳
     trackerId(随机字符串):取uuid，每次随即生成
 }
 */
+ (NSDictionary *)generateCommNode {
    NSTimeInterval timeStamp = floor([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSMutableDictionary *commNode = [NSMutableDictionary dictionaryWithDictionary:[UIDevice generatePIDInfo]];
    
    [commNode addEntriesFromDictionary:@{@"type" : dDVICE_TYPE,
                                         @"version" : [self getAppVersion],
                                         @"versionCode" : kVERSIONCODE,
                                         @"systemVersion" : @(dIOS_SYSTEM_VERSION),
                                         @"us" : kDISTRIBUTECHANNEL,
                                         @"cellPhoneType" : [UIDevice getDeviceModel],
                                         @"packageType" : kPACKAGETYPE,
                                         @"clientDatetime" : @(timeStamp),
                                         @"trackerId" : [[UIDevice currentDevice] deviceIdentifierID]}];
    
    return [commNode copy];
}

+ (NSDictionary *)generateCommNode:(NSTimeInterval)timeStamp {
    NSMutableDictionary *commNode = [NSMutableDictionary dictionaryWithDictionary:[UIDevice generatePIDInfo]];
    
    [commNode addEntriesFromDictionary:@{@"type" : dDVICE_TYPE,
                                         @"version" : [self getAppVersion],
                                         @"versionCode" : kVERSIONCODE,
                                         @"systemVersion" : @(dIOS_SYSTEM_VERSION),
                                         @"us" : kDISTRIBUTECHANNEL,
                                         @"cellPhoneType" : [UIDevice getDeviceModel],
                                         @"packageType" : kPACKAGETYPE,
                                         @"clientDatetime" : @(timeStamp),
                                         @"trackerId" : [[UIDevice currentDevice] deviceIdentifierID]}];
    
    return [commNode copy];
}

+ (NSString *)generateSign:(NSTimeInterval)timeStamp {
    NSString *pid = [UIDevice PID];
    NSString *version = [self getAppVersion];
    NSString *tstampStr = [[NSNumber numberWithDouble:timeStamp] stringValue];
    
    NSString *rawStr = [NSString stringWithFormat:@"%@%@%@%@",pid,kPACKAGETYPE,version,tstampStr];
    
    return [TYLEncryptManager MD5:rawStr];
}

+ (BOOL)doubleEqealWithValueA:(double)valueA valueB:(double)valueB {
    double precise = 0.00000000001;
    return fabs(valueA - valueB) < precise;
}

+ (NSString *)getAppVersion {
    return [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

@end
