//
//  UIDevice+TYLIdentifier.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TYLIdentifier)

+ (NSString *)deviceIdentifierID;

- (NSString *)deviceIdentifierID;

+ (NSString *)getDeviceModel;

+ (NSString *)IDFA;

+ (NSString *)PID;

+ (NSDictionary *)generatePIDInfo;

+ (CGSize)screenResolution;

//"320x480"
+ (NSString *)screenResolutionSizeStr;

@end
