//
//  TYLWrieframe.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLWireframe : NSObject

- (void)pushNativeByHost:(NSString *)host;
- (void)pushNativeByHost:(NSString *)host query:(NSDictionary *)query;
- (void)pushByURLString:(NSString *)urlString;

@end
