//
//  NSNotificationCenter+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (TYLSwizzler)

- (void)tyl_postNotification:(NSNotification *)notification;

- (void)tyl_postNotificationName:(NSString *)name
                         object:(nullable id)object
                       userInfo:(nullable NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
