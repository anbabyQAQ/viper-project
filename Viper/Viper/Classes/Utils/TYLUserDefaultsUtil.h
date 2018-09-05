//
//  NPUserDefaultsUtil.h
//  Nirvana
//
//  Created by huangqun on 2017/9/11.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLUserDefaultsUtil : NSObject


+ (void)setUserDefaults:(NSDictionary *)dic;

+ (void)setUserDefaultsObject:(id)obj forKey:(NSString *)key;

+ (id)userDefaultsObject:(NSString *)key;

+ (void)removeUserDefaults:(NSString *)key;

+ (void)removeUserDefaultsKeys:(NSArray *)keys;

@end
