//
//  NPUserDefaultsUtil.m
//  Nirvana
//
//  Created by huangqun on 2017/9/11.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLUserDefaultsUtil.h"

@implementation TYLUserDefaultsUtil

+ (void)setUserDefaults:(NSDictionary *)dic {
    NSAssert(dic != nil, nil);
    NSAssert(dic.count > 0, nil);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [def setObject:obj forKey:key];
    }];
    [def synchronize];
}

+ (void)setUserDefaultsObject:(id)obj forKey:(NSString *)key {
    NSAssert(obj != nil, nil);
    NSAssert(key != nil, nil);
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)userDefaultsObject:(NSString *)key {
    NSAssert(key != nil, nil);
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeUserDefaults:(NSString *)key {
    NSAssert(key != nil, nil);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefaultsKeys:(NSArray *)keys {
    NSAssert(keys != nil, nil);
    NSAssert(keys.count > 0, nil);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [def removeObjectForKey:obj];
    }];
    
    [def synchronize];
}

@end
