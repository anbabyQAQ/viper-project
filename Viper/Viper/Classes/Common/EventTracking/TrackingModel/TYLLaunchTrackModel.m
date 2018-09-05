//
//  TYLLaunchTrackModel.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLLaunchTrackModel.h"

@implementation TYLLaunchTrackModel

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
    
    return desc.copy;
}

@end
