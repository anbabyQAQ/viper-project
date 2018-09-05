//
//  TYLSwizzler.h
//  Nirvana
//
//  Created by tianyulong on 2017/12/4.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLSwizzler : NSObject


/**
 对指定的类的指定方法进行swizzle

 @param processedClass 指定类
 @param originSelector 原有方法
 @param swizzlSelector swizzle方法
 */
+ (void)swizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector;

+ (void)swizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector error:(NSError**)error;

+ (void)swizzleWithOriginClass:(Class)originalClass originSel:(SEL)originSelector swizzleClass:(Class)replacedClass swizzleSelector:(SEL)swizzlSelector error:(NSError**)error;

@end
