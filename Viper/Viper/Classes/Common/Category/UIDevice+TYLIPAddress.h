//
//  UIDevice+TYLIPAddress.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TYLIPAddress)

/**
 class method: 获取当前设备的IP地址(WIFI和WWAN)
 
 @return return ipAddress
 */
+ (NSString *)ipaddress;

/**
 method: 获取当前设备的IP地址(WIFI和WWAN)
 
 @return return ipAddress
 */
- (NSString *)ipaddress;

- (NSString *)ipAddressWIFI;

- (NSString *)ipAddressCell;

/**
 当前的网络类型
 
 @return networkType
 */
+ (TYLTrackNetworkType)curNetworkType;


/**
 获取运营商信息
 
 @return 运营商， eg: "中国移动"
 */
+ (NSString *)carrierName;

+ (TYLTrackMobileOperator)mobileCarrier;


/**
 获取当前WWAN网络类型
 
 @return return value 2g/3g/4g
 */
+ (TYLTrackNetworkType)networkWWANStatus;

@end
