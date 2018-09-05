//
//  TYLNetworkManager.h
//  Nirvana
//
//  Created by puhui on 2017/9/11.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HttpClientCallBack)(id JSONResponse, NSError *error);

@interface TYLNetworkManager : NSObject
@property (nonatomic, strong) NSString * baseUrl;           /**< 自定义服务器IP 方便测试时切换IP */

+ (instancetype)shareInstance;
/**
 POST

 @param module url中的模块
 @param interface url中的接口（interface）
 @param params request请求额外的params
 @param complete 回调
 
 eg:
    postWithModule:@"app-m/customer" interface:@"getQQMailUrl"
 */
- (void)postWithModule:(NSString *)module
             interface:(NSString *)interface
                params:(id)params
              complete:(HttpClientCallBack)complete;


/**
 POST Convinient Method:(不进行token验证)
 
 @param urlStr 完整的url请求地址
 @param params request请求额外的params
 @param complete 回调
 */
- (void)postWithUrlStr:(NSString *)urlStr params:(id)params complete:(HttpClientCallBack)complete;



/**
 上传文件到指定服务器

 @param filePath file
 @param urlStr urlStr
 @param complete complete
 */
- (void)uploadFile:(NSString *)filePath toServer:(NSString *)urlStr complete:(HttpClientCallBack)complete;

@end
