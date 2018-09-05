//
//  NPTrackingNetWork.h
//  Nirvana
//
//  Created by puhui on 2018/1/10.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TYLTrackingNetWork : NSObject

+ (NSURLSession *)shareSession;

- (instancetype)initWithServerURL:(NSURL *)serverURL;


/**
 上传埋点记录

 @param records 埋点记录
 @param complete complete handler
 */
- (void)flushTtrackRecord:(NSArray *)records complete:(HttpClientCallBack)complete;


/**
 用POST方法上传信息

 @param parmas parmas 参数
 @param complete complete
 */
- (void)postWithParams:(id)parmas complete:(HttpClientCallBack)complete;

@end
NS_ASSUME_NONNULL_END
