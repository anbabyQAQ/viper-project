//
//  NSObject+TYLCheck.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "NSObject+TYLCheck.h"

@implementation NSObject (TYLCheck)


+ (BOOL)isEmpty:(id)obj {
    // nil
    if (!obj) {
        return YES;
    }
    
    // Null
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    // String
    if ([obj isKindOfClass:[NSString class]]) {
        // 长度为0
        if ([obj length] == 0) {
            return YES;
        }
        
        // null
        if ([obj caseInsensitiveCompare:@"<null>"] == NSOrderedSame) {
            return YES;
        }
        return NO;
    }
    
    // Dictionary, Array, Set
    if ([obj isKindOfClass:[NSDictionary class]] ||
        [obj isKindOfClass:[NSArray class]] ||
        [obj isKindOfClass:[NSSet class]]) {
        return [obj count] == 0;
    }
    
    return !obj;
}

+ (BOOL)isNotEmpty:(id)obj {
    return ![[self class] isEmpty:obj];
}

+ (id)nonnullObject:(id)obj {
    return [[self class] isNotEmpty:obj] ? obj : [[self class] new];
}


@end
