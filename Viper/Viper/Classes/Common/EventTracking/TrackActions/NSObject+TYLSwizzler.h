//
//  NSObject+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (TYLSwizzler)

/**
 获取object所在的Controller
 
 @return return Controller
 */
- (UIViewController *)currentController;

- (UIWindow *)lastWindow;

@end
NS_ASSUME_NONNULL_END
