//
//  TYLClassUtil.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLClassUtil : NSObject

/**
 批量赋值(类型自解析)
 
 @param obj 要赋值的对象
 @param paramDict 赋值字典
 */
+ (void)batchAssign:(id)obj params:(NSDictionary *)paramDict;

@end
