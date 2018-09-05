//
//  TYLAssistants.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

@import Foundation;

/**
 字典是否包含键
 
 @param dict 字典对象
 @param key 键名
 @return 是否包含
 */
static inline BOOL np_dictionaryContainsKey(NSDictionary *dict, id key) {
    return [dict isKindOfClass:[NSDictionary class]] && [dict count] > 0 && [dict.allKeys containsObject:key];
}

/**
 按路径获取值
 
 @param dict 字典对象
 @param path 路径, 连接符"->"
 @return 值对象
 */
__kindof NSObject * np_objectForKPath(NSDictionary *dict, NSString *path);
