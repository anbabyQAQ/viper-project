//
//  TYLMacro.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//


/*
 *  定义宏
 */

#ifndef TYLMacro_h
#define TYLMacro_h

#import "TYLWeakStrongMacro.h"

//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define dSCREEN_WIDTH     ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define dSCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define dSCREEN_SIZE     ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#define dSCREENH_AVERAGE_HEIGHT  [UIScreen mainScreen].bounds.size.height/667
#define dSCREENH_AVERAGE_WIDTH  [UIScreen mainScreen].bounds.size.width/375

#else
#define dSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define dSCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define dSCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define dSCREENH_AVERAGE_HEIGHT  667/[UIScreen mainScreen].bounds.size.height

#endif

#define dSCREEN_WIDTH_320 dSCREEN_WIDTH <= 320.0

#define dNPNotificationCenter [NSNotificationCenter defaultCenter]

#ifdef RELEASE
#define NSLog(format, ...)
#else
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#endif

// 加载
#define dShowNetworkActivityIndicator()         [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define dHideNetworkActivityIndicator()          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define dNetworkActivityIndicatorVisible(x)      [UIApplication sharedApplication].networkActivityIndicatorVisible = x

#define dWindow [UIApplication sharedApplication].keyWindow


//判断当前的iPhone设备/系统版本
//判断是否为iPhone
#define dIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define dIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define dIS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 4S/4
#define dIPhone4 [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f
// 判断是否为 iPhone 5SE
#define dIPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

// 判断是否为iPhone 6/6s/7
#define dIPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

// 判断是否为iPhone 6Plus/6sPlus/7PLus
#define dIPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

// 判断是否为iPhone X
#define dIPhoneX [UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f

//获取系统版本
#define dIOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断 iOS 8 或更高的系统版本
#define dIOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))

//判断 iOS 9 或更高的系统版本
#define dIOS_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))

//判断 iOS系统版本为x版本或更晚的版本 (包含x版本)
#define dIOS_VERSION_OR_LATER(x) (([[[UIDevice currentDevice] systemVersion] floatValue] >= x)? (YES):(NO))

//判断 iOS系统版本为x版本更早的版本 (不包含x版本)
#define dIOS_VERSION_EARLIER(x) (([[[UIDevice currentDevice] systemVersion] floatValue] < x)? (YES):(NO))

//沙盒目录文件
//获取temp
#define dPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define dPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define dPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//GCD - 一次性执行
#define dDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define dDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define dDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

//判断数组 和 Map 是否为空
#define dIsNOTNullOrEmptyOfArray(_ARRAY___) (_ARRAY___ && [_ARRAY___ isKindOfClass:[NSArray class]] && [_ARRAY___ count])
#define dIsNOTNullOrEmptyOfDictionary(_DICTIONARY___) (_DICTIONARY___ && [_DICTIONARY___ isKindOfClass:[NSDictionary class]] && [_DICTIONARY___ count])

#define dIDFA    [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
#define dUUID   [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//-----------------------系统权限设置路径(iOS8以后适用)---------------------
//url
#define dSettingURL [NSURL URLWithString:UIApplicationOpenSettingsURLString]
//跳到设置_iOS8
#define dGoToSetting if([[UIApplication sharedApplication] canOpenURL:SettingURL]) { \
[[UIApplication sharedApplication] openURL:SettingURL];}
//跳到设置_iOS10
#define dGoToSetting_iOS10 if([[UIApplication sharedApplication] canOpenURL:SettingURL]) { \
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) { \
\
}];}

#define dKEY_WINDOW                  [[UIApplication sharedApplication] keyWindow]
#define dTOP_VIEWCONTROLLER          [[UIApplication sharedApplication] keyWindow].rootViewController
#define dTOP_VIEW                    [[UIApplication sharedApplication] keyWindow].rootViewController.view
#define dGET_APP_DELEGATE            (NPAppDelegate *)([UIApplication sharedApplication].delegate)
#define dROOT_NAVIGATECONTROLLER     [GET_APP_DELEGATE window].rootViewController

// 像素
#define dPixelValue(s)         ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0) * (s)

// 字体 9系统及之后用平方字体
#define dFONT(s)               dIOS_VERSION_9_OR_LATER ? [UIFont pingFangRegularWithSize:s] : [UIFont systemFontOfSize:s]
#define dFONT_BOLD(s)          dIOS_VERSION_9_OR_LATER ? [UIFont pingFangSemiboldWithSize:s] : [UIFont boldSystemFontOfSize:s]

//颜色
#define dHEXCOLOR(c)                 [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
#define dHEXCOLOR_ALPHA(c, a)        [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:a]
#define dRANDOM_COLOR                [UIColor colorWithHue:(arc4random() % 256 / 256.f) saturation:(arc4random() % 128 / 256.f) + .5f brightness:(arc4random() % 128 / 256.f) + .5f alpha:1.f]

//根据图片名字获取图片
#define dGetImageWithName(imageName) [UIImage imageNamed:imageName]

#define dHEIGHT_TABBAR           (dIPhoneX ? 83.0f : 49.0f)
#define dHEIGHT_STATUS           (dIPhoneX ? 44.0f : 20.0f)
#define dHEIGHT_NAVIBAR          44.0f

//设置NSError
#define dSetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)    \
if (ERROR_VAR) {    \
NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
code:-1    \
userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}
#define dSetNSError(ERROR_VAR, FORMAT,...) dSetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)


#endif /* TYLMacro_h */
