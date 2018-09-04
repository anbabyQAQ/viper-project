//
//  TYLURL.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dSN_SCHEME @"souhunews" // viper app的通用协议

@interface TYLURL : NSObject

@property (nonatomic, copy, readonly) NSString *urlString;   /**< URL字符串 */
@property (nonatomic, copy) NSString *scheme;                /**< 协议 */
@property (nonatomic, copy) NSString *host;                  /**< 域 */
@property (nonatomic, copy) NSString *path;                  /**< 地址 */
@property (nonatomic, copy) NSDictionary *query;             /**< 参数列表 */

- (instancetype)initWithString:(NSString *)string;

@end
