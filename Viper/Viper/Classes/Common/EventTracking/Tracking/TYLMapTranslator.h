//
//  NPMapTranslator.h
//  Nirvana
//
//  Created by tianyulong on 2018/1/15.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    埋点唯一标记（unique id）和bi的统计标识之间的映射翻译
 */

NS_ASSUME_NONNULL_BEGIN
@interface TYLMapTranslator : NSObject
dSINGLETON_FOR_CLASS_HEADER(TYLMapTranslator)


/**
 根据uniqueKey获取biContent属性

 @param uniqueKey uniqueKey
 @return return value biContent
 */
- (NSString *)biContentWithUniqueKey:(NSString *)uniqueKey;


/**
 根据uniqueKey获取biEvent属性

 @param uniqueKey uniqueKey
 @return return value biEvent
 */
- (NSString *)biEventWithUniqueKey:(NSString *)uniqueKey;

/**
 更新埋点配置文件的版本信息
 
 @param version 新的版本
 */

- (void)updateTrackingVersion:(NSString *)version;

/**
 更新埋点配置文件
 
 @param channel channel description
 */
- (void)updateTrackingChannel:(NSString *)channel;


/**
 获取map配置文件
 */
- (void)fetchTrackingMapFile;

@end
NS_ASSUME_NONNULL_END
