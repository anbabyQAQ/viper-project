//
//  TYLConstants.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLConstants.h"

NSString *const KNoNetWorkWord = @"获取数据失败，请稍后尝试";       /**< 获取数据失败 */
NSInteger KNoNetworkCode = -1111111;

NSString *const KRequestNodeCommKey     = @"comm";
NSString *const KRequestNodeTokenKey    = @"token";
NSString *const KRequestNodeBodyKey     = @"body";
NSString *const KRequestNodeSignKey     = @"sign";

NSString *const KResponseTokenKey       = @"token";
NSString *const KResponseCodeKey        = @"code";
NSString *const KResponseErrorCodeKey   = @"errorcode";
NSString *const KResponseStatusKey      = @"status";
NSString *const KResponseBerrorCodeKey  = @"berrorcode";
NSString *const KResponseBerrorMsgKey   = @"berrormsg";
NSString *const KResponseErrorMsgKey   = @"errormsg";
NSString *const KResponseDataKey        = @"data";

#pragma mark - Token
NSString *const KPublicToken            = @"PublicToken";
NSString *const KTokenExpiredTime       = @"tokenExpiredTime";
NSString *const KExpiredToken           = @"expiredToken";
NSString *const KExpiredTokenExpiredTime= @"expiredTokenExpiredTime";
NSString *const KMd5Uid                 = @"md5Uid";


#pragma mark - 埋点 EventTrack
NSString *const KEventTrackRecordKey = @"trackRecord";
NSString *const KEventTrackTypeLaunch = @"launch";
NSString *const KEventTrackTypeTerminated = @"terminated";
NSString *const KEventTrackTypeClick = @"click";
NSString *const KEventTrackTypePvopen = @"pvopen";
NSString *const KEventTrackTypePvclose = @"pvclose";
NSString *const KEventTrackTypeInput = @"input";
NSString *const KEventTrackPagePause = @"pause";
NSString *const KEventTrackPageResume = @"resume";


#pragma mark - UserInfo
NSString *const KMultilogin = @"Multilogin";
NSString *const KUserName = @"userName";
NSString *const KUserNameMask = @"userNameMask";
NSString *const KMobile = @"mobile";
NSString *const KMobileMask = @"mobileMask";
NSString *const KRealNameAuth = @"isId5";
NSString *const KMail = @"mail";
NSString *const KIdNo = @"idNo";
NSString *const KIdNoMask = @"idNoMask";
NSString *const KCreateTime = @"createTime";

NSString *const KCoreCustomerId = @"coreCustomerId";
