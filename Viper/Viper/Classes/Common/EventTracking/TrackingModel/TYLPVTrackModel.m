//
//  TYLPVTrackModel.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLPVTrackModel.h"

@implementation TYLPVTrackModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self generateInfo];
    }
    
    return self;
}

- (void)generateInfo {
    [super generateInfo];
    
    self.res = [UIDevice screenResolutionSizeStr];
}

- (NSString *)description {
    NSMutableString *desc = @"".mutableCopy;
    [desc appendFormat:@"type:%@;",self.type];
    [desc appendFormat:@"platform:%lu;",(unsigned long)self.platform];
    [desc appendFormat:@"deviceId:%@;",self.deviceId];
    [desc appendFormat:@"appv:%@;",self.appv];
    [desc appendFormat:@"ip:%@;",self.ip];
    [desc appendFormat:@"md5:%@;",self.md5];
    [desc appendFormat:@"packagetype:%@;",self.packageType];
    [desc appendFormat:@"deviceidtype:%@;",self.deviceIdType];
    [desc appendFormat:@"res:%@;",self.res];
    [desc appendFormat:@"uniqueId:%@;",self.uniqueId];
    [desc appendFormat:@"lastpage:%@;",self.lastPage?:@""];
    [desc appendFormat:@"pageurl:%@;",self.pageUrl?:@""];
    
    if (self.createTime > 0) {
        [desc appendFormat:@"starttime:%.0f;",self.createTime];
    }
    
    return desc.copy;
}

@end
