//
//  UIDevice+TYLIdentifier.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIDevice+TYLIdentifier.h"

#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <objc/runtime.h>

@import AdSupport;

#define kDeviceIdentifierID @"deviceIdentifierID"

static void * const kUIDeviceIdentifierIDKey     = (void*)&kUIDeviceIdentifierIDKey;

@implementation UIDevice (TYLIdentifier)

- (void)setDeviceIdentifierID:(NSString *)deviceIdentifierID {
    objc_setAssociatedObject(self, &kUIDeviceIdentifierIDKey, deviceIdentifierID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)deviceIdentifierID {
    NSString *identifierID = objc_getAssociatedObject(self, &kUIDeviceIdentifierIDKey);
    if ( identifierID == nil ) {
        identifierID = [UIDevice deviceIdentifierID];
        self.deviceIdentifierID = identifierID;
    }
    return identifierID;
}

+ (NSString *)deviceIdentifierID {
#if TARGET_IPHONE_SIMULATOR
    NSString *identifierID = [TYLUserDefaultsUtil userDefaultsObject:kDeviceIdentifierID];
    if ( identifierID == nil || [identifierID isEqualToString:@""] ) {
        identifierID = [self getUUID];
        [TYLUserDefaultsUtil setUserDefaultsObject:identifierID forKey:kDeviceIdentifierID];
    }
    return identifierID;
#else
    NSString *identifierID = nil;
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:[UICKeyChainStore defaultService]];
    if ( store ) {
        identifierID = store[kDeviceIdentifierID];
        if ( identifierID == nil || [identifierID isEqualToString:@""] ) {
            identifierID = [self getUUID];
            store[kDeviceIdentifierID] = identifierID;
        }
    }
    return identifierID;
#endif
}

+ (NSString*)getUUID {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault, UUID);
    NSString *result = [NSString stringWithFormat:@"%@", UUIDString];
    CFRelease(UUID);
    CFRelease(UUIDString);
    return result;
}

#pragma mark -
#pragma mark - 获取设备具体型号
//eg : @"iPhone6,1"
+ (NSString *)getDeviceModel {
    struct utsname u;
    uname(&u);
    NSString *machine = [[NSString alloc] initWithUTF8String:u.machine];
    
    //Simulator
    if ([machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"]) {
        machine = @"Simulator";
    }
    
    return machine;
}

+ (NSString *)IDFA {
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    return [idfa stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //    return idfa
}

+ (NSDictionary *)generatePIDInfo {
    NSString *idfa = [self IDFA];
    
    if (!idfa || [idfa isEqualToString:@""] || [idfa containsString:@"00000000000000000000000000000000"]) {
        NSString *uuid = [self deviceIdentifierID];
        
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        return @{@"pid" : uuid, @"pidType" : @"uuid"};
    }
    
    return @{@"pid" : idfa, @"pidType" : @"idfa"};
}

+ (NSString *)PID {
    NSString *idfa = [self IDFA];
    
    if (!idfa || [idfa isEqualToString:@""] || [idfa containsString:@"00000000000000000000000000000000"]) {
        NSString *uuid = [self deviceIdentifierID];
        
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        return uuid;
    }
    
    return idfa;
}

+ (CGSize)screenResolution {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return CGSizeMake(dSCREEN_WIDTH * scale, dSCREENH_HEIGHT * scale);
}

//"320x480"
+ (NSString *)screenResolutionSizeStr {
    CGSize size = [self screenResolution];
    
    return [NSString stringWithFormat:@"%.0fx%.0f",ceilf(size.width),ceilf(size.height)];
}


@end
