//
//  TYLTrackingProtocol.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLTrackingProtocol <NSObject>

@required
/**
 实现该Protocol的Controller对象的title
 
 @return title
 */
- (NSString *)trackTitle;

@optional
/**
 实现该Protocol的Controller对象可以通过接口向自动采集的事件中加入属性
 
 @return property
 */
- (NSDictionary *)trackProperties;




@end
