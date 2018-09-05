//
//  TYLNetworkManager.m
//  Nirvana
//
//  Created by puhui on 2017/9/11.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLNetworkManager.h"
#import "TYLTokenManager.h"

@import AdSupport;

@interface TYLNetworkManager ()
@property (nonatomic, readwrite) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *postTaskList;
@property (nonatomic, strong) NSMutableDictionary *uploadTaskList;

@property (nonatomic, copy) NSString *cacheUrl;
@property (nonatomic, strong) id cacheParams;
@property (nonatomic, copy) HttpClientCallBack cacheCallBack;
@end

@implementation TYLNetworkManager

+ (instancetype)shareInstance {
    static TYLNetworkManager *networkManger;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        networkManger = [TYLNetworkManager new];
    });
    
    return networkManger;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.postTaskList = @{}.mutableCopy;
        self.uploadTaskList = @{}.mutableCopy;
        [self configure];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Method

- (void)configure {
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:dBASE_URL_HTTP]];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [self createRequestSerializer];
    
    if ([dBASE_URL_HTTP hasPrefix:@"https:"]) {
        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        self.manager.securityPolicy.validatesDomainName = NO;
    }
    
    // 监控网络状态变化
    NSOperationQueue *operationQueue = _manager.operationQueue;
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [self.manager.reachabilityManager startMonitoring];
}

- (AFJSONRequestSerializer *)createRequestSerializer {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    //连接超时时间设置为30秒
    requestSerializer.timeoutInterval = 30;
    
    return requestSerializer;
}

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

#pragma mark -
#pragma mark Token Process
- (NPTokenState)validateToken {
    NSString *token = [TYLTokenManager token];
    
    if ([token isEqualToString:@""]) {
        return eNPTokenStateNoValidate;
    }
    else if (!token || [TYLTokenManager isExpired]) {
        return eNPTokenStateExpired;
    }
    else if ([TYLTokenManager needRefreshToken]) {
        return eNPTokenStateNeedRefresh;
    }
    
    return eNPTokenStateValidate;
}

- (void)refreshToken {
    NSString *urlStr = [TYLBusinessUtil generateUrlStrWithModule:@"user"
                                                      interface:@"exchangeToken"];
    NSString *token = [TYLTokenManager expiredToken];
    NSString *pid = [UIDevice PID];
    NSDictionary *params = @{@"token" : token,
                             @"pid" : pid};
    
    @weakify(self);
    [self postWithUrlStr:urlStr params:params complete:^(id JSONResponse, NSError *error) {
        @strongify(self)
        if (!error && JSONResponse) {
            NSInteger status = [np_objectForKPath(JSONResponse, KResponseStatusKey) integerValue];
            
            if (status == ResponseStatus_ok) {
                NSDictionary *tokenInfo = np_objectForKPath(JSONResponse, @"data->token");
                NSDictionary *newTokenInfo = @{KPublicToken : tokenInfo[@"token"],
                                               KExpiredToken : tokenInfo[@"expiredToken"],
                                               KTokenExpiredTime : tokenInfo[@"tokenExpiredTime"],
                                               KExpiredTokenExpiredTime : tokenInfo[@"expiredTokenExpiredTime"]};
                
                [TYLTokenManager save:newTokenInfo];
                
                NSString *md5Uid = np_objectForKPath(JSONResponse, @"data->md5Uid");
                
                if ([NSString isNotEmpty:md5Uid]) {
                    [TYLTokenManager saveMd5Uid:md5Uid];
                }
                
                [self postWithUrlStr:self.cacheUrl params:self.cacheParams complete:self.cacheCallBack];
            }
            else {
                NSLog(@"刷新token失败，重新登录!");
                [self relogin];
            }
        }
    }];
}

#pragma mark -
#pragma mark Method of networking access
- (void)postWithModule:(NSString *)module
             interface:(NSString *)interface
                params:(id)params
              complete:(HttpClientCallBack)complete {
    NSString * urlStr = [TYLBusinessUtil generateUrlStrWithModule:module interface:interface];
    
    //cache current request info
    self.cacheUrl = urlStr;
    self.cacheParams = params;
    self.cacheCallBack = complete;
    
    NPTokenState tokenState = [self validateToken];
    
    switch (tokenState) {
        case eNPTokenStateValidate:
        case eNPTokenStateNoValidate:
        {
            [self postWithUrlStr:urlStr params:params complete:complete];
            return;
        }
            break;
        case eNPTokenStateNeedRefresh:
        {
            [self refreshToken];
        }
            break;
        case eNPTokenStateExpired:
        {
            [self relogin];
        }
            break;
    }
}

/**
 POST Convinient Method
 
 @param urlStr 完整的url请求地址
 @param params request请求额外的params
 @param complete 回调
 */
- (void)postWithUrlStr:(NSString *)urlStr params:(id)params complete:(HttpClientCallBack)complete {
    if (self.manager.operationQueue.suspended) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:KNoNetWorkWord code:KNoNetworkCode userInfo:nil];
            complete(nil, error);
        }
    }
    
    @synchronized(self.postTaskList) {
        NSDictionary * tParams = [self createHttpParms:params];
        NSURLSessionDataTask *task;
        
        if (dIsNOTNullOrEmptyOfDictionary(self.postTaskList)) {
            task = self.postTaskList[urlStr];
            if (task) {
                [task cancel];
            }
        }
        
        @weakify(self);
        task = [self.manager POST:urlStr parameters:tParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
             NSLog(@"\n ********** 发送信令 (成功) ********* \n服务器接口: %@ \n参数: %@ \n服务器响应: %@ \n ************* 信令结束 (成功) ********** ", task.originalRequest.URL, tParams, responseObject);
            
            NSInteger errorCode = [np_objectForKPath(responseObject, KResponseErrorCodeKey) integerValue];
            NSInteger status = [np_objectForKPath(responseObject, KResponseStatusKey) integerValue];
            if (status != ResponseStatus_ok && errorCode == ResponseErrorCode_706) {
                // 通知多点登录或token过期
                [self relogin];
            }
            
            //回调请求结果
            if (complete) {
                complete(responseObject, nil);
            }
            
            [self clearPostTaskListUrl:urlStr];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败: 请求地址: %@\n  请求参数 : %@\n 错误信息 : %@", task.originalRequest.URL, tParams, error);
            if (error.code != NSURLErrorCancelled) {
                if (complete) {
                    complete(nil, error);
                }
            }
            
            [self clearPostTaskListUrl:urlStr];
        }];
        
        //记录请求的任务
        if (task) {
            [self.postTaskList setObject:task forKey:urlStr];
        }
    }
}

#pragma mark -
#pragma mark 清理
- (void)clearPostTaskListUrl:(NSString *)urlStr {
    if (dIsNOTNullOrEmptyOfDictionary(self.postTaskList)) {
        [self.postTaskList removeObjectForKey:urlStr];
    }
}

- (void)clearUploadTaskListUrl:(NSString *)urlStr {
    if (dIsNOTNullOrEmptyOfDictionary(self.uploadTaskList)) {
        [self.uploadTaskList removeObjectForKey:urlStr];
    }
}

/**
 重新登录
 */
- (void)relogin {
    [[NSNotificationCenter defaultCenter] multilogin];
    [[NSNotificationCenter defaultCenter] loginStatusChange];
    [TYLTokenManager clear];
    [TYLUserManager clear];
}

#pragma mark -
#pragma mark 上传文件(formData)
- (void)uploadFile:(NSString *)filePath toServer:(NSString *)urlStr complete:(HttpClientCallBack)complete {
    if (self.manager.operationQueue.suspended) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:KNoNetWorkWord code:KNoNetworkCode userInfo:nil];
            complete(nil, error);
        }
    }
    
    @synchronized(self.uploadTaskList) {
        NSURLSessionUploadTask *task;
        
        if (dIsNOTNullOrEmptyOfDictionary(self.uploadTaskList)) {
            task = self.uploadTaskList[urlStr];
            if (task) {
                [task cancel];
            }
        }
        
        NSURL *filePathUrl = [NSURL fileURLWithPath:filePath];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:urlStr
                                                                                                 parameters:nil
                                                                                  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileURL:filePathUrl name:@"ps" error:nil];
        } error:nil];
        
        @weakify(self);
        task = [self.manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            @strongify(self);
            
            if (error) {
                NSLog(@"上传文件失败: 请求地址: %@\n 文件地址: %@\n 错误信息 : %@", response.URL.absoluteString, filePath ,error);
            }
            else {
                NSLog(@"\n ********** 发送信令 (成功) ********* \n服务器接口: %@ \n文件地址: %@ \n服务器响应: %@ \n ************* 信令结束 (成功) ********** ",response.URL.absoluteString, filePath, responseObject)
            }
            
            if (complete) {
                complete(responseObject, nil);
            }
            
            [self clearUploadTaskListUrl:urlStr];
        }];
        
        [task resume];
        
        if (task) {
            [self.uploadTaskList setObject:task forKey:urlStr];
        }
    }
}
@end

