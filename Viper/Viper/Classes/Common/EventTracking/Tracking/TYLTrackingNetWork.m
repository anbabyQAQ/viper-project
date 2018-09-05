//
//  NPTrackingNetWork.m
//  Nirvana
//
//  Created by puhui on 2018/1/10.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "TYLTrackingNetWork.h"
#import "AFNetworkReachabilityManager.h"

@interface TYLTrackingNetWork()
@property (nonatomic) NSURL *serverUrl;
@end

@implementation TYLTrackingNetWork

+ (NSURLSession *)shareSession {
    static NSURLSession *sharedSession = nil;
    @synchronized(self) {
        if (sharedSession == nil) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 7.0;
            sharedSession = [NSURLSession sessionWithConfiguration:sessionConfig];
        }
    }
    
    return sharedSession;
}

- (instancetype)initWithServerURL:(NSURL *)serverURL {
    self = [super init];
    if (self) {
        self.serverUrl = serverURL;
    }
    
    return self;
}

#pragma mark -
#pragma mark Flush
- (void)flushTtrackRecord:(NSArray *)records complete:(HttpClientCallBack)complete {
    if (records.count == 0) return;
    
    [self postWithParams:records complete:complete];
}

- (void)postWithParams:(id)parmas complete:(HttpClientCallBack)complete {
    AFNetworkReachabilityManager *rm = [AFNetworkReachabilityManager sharedManager];
    [rm startMonitoring];
    if (!rm.isReachable) {
        NSError *error = [NSError errorWithDomain:@"Network lost" code:-1005 userInfo:nil];
        complete(nil,error);
    };
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.serverUrl];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *paramsDic = [self createHttpParms:parmas];
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:paramsDic
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:nil];
    
    [urlRequest setHTTPBody:paramsData];
    
    @weakify(self);
    [[[TYLTrackingNetWork shareSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *info;
        if (data) {
            info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }
        
        @strongify(self);
        if (error) {
            NSLog(@"\n ********** 发送信令 (失败) ********* \n: 请求地址: %@\n 请求参数: %@\n 错误信息 : %@", ((self.serverUrl)?:(response.URL.absoluteString)), paramsDic,error);
        }
        else {
            id status = np_objectForKPath(info, KResponseStatusKey);
            if (!status || [status integerValue] != ResponseStatus_ok) {
                NSLog(@"\n ********** 发送信令 (失败) ********* \n: 请求地址: %@\n 请求参数: %@\n 错误信息 : %@", ((self.serverUrl)?:(response.URL.absoluteString)),paramsDic ,info);
            }
            else {
                NSLog(@"\n ********** 发送信令 (成功) ********* \n服务器接口: %@ \n 请求参数: %@\n 服务器响应: %@ \n ************* 信令结束 (成功) ********** ",((self.serverUrl)?:(response.URL.absoluteString)),paramsDic, info)
            }
        }
        
        if (complete) {
            complete(info,error);
        }
    }] resume];
}

#pragma mark -
#pragma mark Extra
/**
 根据conn、token、body重新生成POST网络请求的参数
 
 @param body body参数
 @return 新的param参数
 */
- (NSDictionary *)createHttpParms:(id)body {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:1];
    NSTimeInterval timeStamp = floor([[NSDate date] timeIntervalSince1970] * 1000);
    
    // comm节点
    params[KRequestNodeCommKey] = [TYLBusinessUtil generateCommNode:timeStamp];
    
    // token节点
    NSString *token = [TYLTokenManager token];
    params[KRequestNodeTokenKey] = token;
    
    //body节点
    if (body) {
        params[KRequestNodeBodyKey] = body;
    }
    
    //sign
    params[KRequestNodeSignKey] = [TYLBusinessUtil generateSign:timeStamp];
    
    return [params copy];
}

@end
