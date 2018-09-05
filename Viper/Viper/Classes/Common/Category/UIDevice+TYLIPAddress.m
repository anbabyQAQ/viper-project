//
//  UIDevice+TYLIPAddress.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIDevice+TYLIPAddress.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (TYLIPAddress)

#pragma mark - IP地址(WiFi地址（ipv4、6）、WWAN地址)
+ (NSString *)ipaddress {
    return [[self currentDevice] ipaddress];
}

- (NSString *)ipaddress {
    AFNetworkReachabilityManager *rm = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus status = rm.networkReachabilityStatus;
    
    NSString *ipAddr = nil;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        {}
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            ipAddr = [self ipAddressCell];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            ipAddr = [self ipAddressWIFI];
        }
            break;
    }
    
    return ipAddr;
}

- (NSString *)ipAddressWithIfName:(NSString *)name {
    if (name.length == 0) return nil;
    
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    if (getifaddrs(&interfaces) == 0) {
        //获取所有设备的网卡接口信息
        struct ifaddrs *ifaddr = interfaces;
        while (ifaddr) {
            if ([[NSString stringWithUTF8String:ifaddr->ifa_name] isEqualToString:name]) {
                sa_family_t family = ifaddr->ifa_addr->sa_family;
                
                switch (family) {
                    case AF_INET:
                    {
                        //ipv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)ifaddr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        break;
                    case AF_INET6:
                    {
                        //ipv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)ifaddr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        break;
                        
                    default: break;
                }
                
                if (address) break;
            }
            
            ifaddr = ifaddr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

- (NSString *)ipAddressWIFI {
    return [self ipAddressWithIfName:@"en0"];
}

- (NSString *)ipAddressCell {
    return [self ipAddressWithIfName:@"pdp_ip0"];
}


#pragma mark - 运营商
+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    //当前手机所属运营商名称
    NSString *carrierName;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        carrierName = @"无运营商";
    }
    else {
        carrierName = [carrier carrierName];
    }
    
    return carrierName;
}

+ (TYLTrackMobileOperator)mobileCarrier {
    NSString *carrierName = [self carrierName];
    
    if ([carrierName isEqualToString:@"中国移动"]) {
        return TYLTrackMobileOperator_ChinaMobile;
    }
    else if ([carrierName isEqualToString:@"中国联通"]) {
        return TYLTrackMobileOperator_ChinaComm;
    }
    else if ([carrierName isEqualToString:@"中国电信"]) {
        return TYLTrackMobileOperator_ChinaTelecom;
    }
    
    return TYLTrackMobileOperator_Other;
}

#pragma mark - 网络类型（WiFi、WWAN）
+ (TYLTrackNetworkType)curNetworkType {
    AFNetworkReachabilityManager *rm = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus status = rm.networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        {}
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            return [self networkWWANStatus];
        }
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            return TYLTrackNetworkTypeWifi;
        }
    }
    
    return TYLTrackNetworkTypeOther;
}

/**
 获取当前WWAN网络类型
 
 @return return value 2g/3g/4g
 */
+ (TYLTrackNetworkType)networkWWANStatus {
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS : @(TYLTrackNetworkType2G),  // 2.5G   171Kbps
                CTRadioAccessTechnologyEdge : @(TYLTrackNetworkType2G),  // 2.75G  384Kbps
                CTRadioAccessTechnologyWCDMA : @(TYLTrackNetworkType3G), // 3G     3.6Mbps/384Kbps
                CTRadioAccessTechnologyHSDPA : @(TYLTrackNetworkType3G), // 3.5G   14.4Mbps/384Kbps
                CTRadioAccessTechnologyHSUPA : @(TYLTrackNetworkType3G), // 3.75G  14.4Mbps/5.76Mbps
                CTRadioAccessTechnologyCDMA1x : @(TYLTrackNetworkType3G), // 2.5G
                CTRadioAccessTechnologyCDMAEVDORev0 : @(TYLTrackNetworkType3G),
                CTRadioAccessTechnologyCDMAEVDORevA : @(TYLTrackNetworkType3G),
                CTRadioAccessTechnologyCDMAEVDORevB : @(TYLTrackNetworkType3G),
                CTRadioAccessTechnologyeHRPD : @(TYLTrackNetworkType3G),
                CTRadioAccessTechnologyLTE : @(TYLTrackNetworkType4G)}; // LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
    });
    
    CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
    if (!teleInfo) return TYLTrackNetworkTypeOther;
    NSString *status = teleInfo.currentRadioAccessTechnology;
    if (!status) return TYLTrackNetworkTypeOther;
    
    NSNumber *num = dic[status];
    if (num) return num.unsignedIntegerValue;
    else return TYLTrackNetworkTypeOther;
}

@end
