//
//  TYLTrackModel.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLTrackModel.h"
#import "UIDevice+TYLIPAddress.h"

@implementation TYLTrackModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self generateInfo];
    }
    
    return self;
}

- (void)generateInfo {
    self.createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
    self.platform = TYLTrackPlatformiOS;
    self.deviceId = [UIDevice PID] ?: @"";
    NSString *idfa = [UIDevice IDFA];
    self.deviceIdType =  (!idfa || [idfa isEqualToString:@""] || [idfa containsString:@"00000000000000000000000000000000"]) ? @"uuid" : @"idfa";
    self.appv = [TYLBusinessUtil getAppVersion];
    self.ip = [UIDevice ipaddress];
    self.md5 = [TYLUserManager isLogin] ? [TYLTokenManager md5Uid] : @"0";
    self.packageType = kPACKAGETYPE;
    self.system = [UIDevice getDeviceModel];
    self.equipmentType = @"Apple";
    self.net = [UIDevice curNetworkType];
    self.res = [UIDevice screenResolutionSizeStr];
    self.mobileOperator = [UIDevice mobileCarrier];
    
    NSString *flag = [TYLUserDefaultsUtil userDefaultsObject:@"EventTracking_Launch_Flag"];
    if (flag) {
        self.flag = flag;
    }
}

- (NSString *)description {
    NSMutableString *desc = @"".mutableCopy;
    [desc appendFormat:@"type:%@;",self.type];
    [desc appendFormat:@"platform:%lu;",(unsigned long)self.platform];
    [desc appendFormat:@"device_id:%@;",self.deviceId];
    [desc appendFormat:@"appv:%@;",self.appv];
    [desc appendFormat:@"packagetype:%@;",self.packageType];
    [desc appendFormat:@"deviceidtype:%@;",self.deviceIdType];
    [desc appendFormat:@"ip:%@;",self.ip];
    [desc appendFormat:@"md5:%@;",self.md5];
    [desc appendFormat:@"equipment_type:%@;",self.equipmentType];
    [desc appendFormat:@"system:%@;",self.system];
    [desc appendFormat:@"net:%lu;",self.net];
    [desc appendFormat:@"res:%@;",self.res];
    [desc appendFormat:@"operator:%lu;",self.mobileOperator];
    
    if (self.createTime > 0) {
        [desc appendFormat:@"starttime:%.0f;",self.createTime];
    }
    return desc.copy;
}


@end
