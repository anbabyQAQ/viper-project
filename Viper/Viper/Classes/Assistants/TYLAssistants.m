//
//  TYLAssistants.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLAssistants.h"

// 按路径获取属性, 路径连接符"->"
__kindof NSObject * np_objectForKPath(NSDictionary *dict, NSString *path) {
    if (![path isKindOfClass:[NSString class]] || [path length] == 0) {
        return nil;
    }
    NSArray *kPath = [path componentsSeparatedByString:@"->"];
    if (!kPath || [kPath count] == 0) {
        return nil;
    }
    id obj = nil;
    id data = dict;
    for (int i = 0; i < [kPath count]; i++) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *key = kPath[i];
            if (!np_dictionaryContainsKey(data, key)) {
                return nil;
            } else if(i == [kPath count] - 1) {
                obj = [data objectForKey:key];
            } else {
                data = [data objectForKey:key];
            }
        } else if ([data isKindOfClass:[NSArray class]]) {
            id index = kPath[i];
            NSInteger idx = [index integerValue];
            if (idx < 0) {
                return nil;
            } else if(i == [kPath count] - 1) {
                obj = [data objectAtIndex:idx];
            } else {
                data = [data objectAtIndex:idx];
            }
        } else {
            return obj;
        }
    }
    return obj;
}

