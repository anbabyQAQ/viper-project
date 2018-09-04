//
//  NSString+TYLURL.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TYLURL)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters;

@end
