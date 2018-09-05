//
//  NSObject+TYLCheck.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TYLCheck)

// 判断是否为空
+ (BOOL)isEmpty:(id _Nullable)obj;

// 判断是否不为空
+ (BOOL)isNotEmpty:(id _Nullable)obj;

// 不为空的对象
+ (nonnull id)nonnullObject:(id _Nullable)obj;

@end
