//
//  TYLConstants.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  定义字符长常量
 */

#pragma mark - Network
FOUNDATION_EXPORT NSString *const KNoNetWorkWord;
FOUNDATION_EXPORT NSInteger KNoNetworkCode;

FOUNDATION_EXPORT NSString *const KRequestNodeCommKey;
FOUNDATION_EXPORT NSString *const KRequestNodeTokenKey;
FOUNDATION_EXPORT NSString *const KRequestNodeBodyKey;
FOUNDATION_EXPORT NSString *const KRequestNodeSignKey;

FOUNDATION_EXPORT NSString *const KResponseTokenKey;
FOUNDATION_EXPORT NSString *const KResponseCodeKey;
FOUNDATION_EXPORT NSString *const KResponseErrorCodeKey;
FOUNDATION_EXPORT NSString *const KResponseStatusKey;
FOUNDATION_EXPORT NSString *const KResponseBerrorCodeKey;
FOUNDATION_EXPORT NSString *const KResponseBerrorMsgKey;
FOUNDATION_EXPORT NSString *const KResponseErrorMsgKey;
FOUNDATION_EXPORT NSString *const KResponseDataKey;

#pragma mark - Token
FOUNDATION_EXPORT NSString *const KPublicToken;
FOUNDATION_EXPORT NSString *const KTokenExpiredTime;
FOUNDATION_EXPORT NSString *const KExpiredToken;
FOUNDATION_EXPORT NSString *const KExpiredTokenExpiredTime;
FOUNDATION_EXPORT NSString *const KMd5Uid;


#pragma mark - 埋点 EventTrack
FOUNDATION_EXPORT NSString *const KEventTrackRecordKey;
FOUNDATION_EXPORT NSString *const KEventTrackTypeLaunch;
FOUNDATION_EXPORT NSString *const KEventTrackTypeTerminated;
FOUNDATION_EXPORT NSString *const KEventTrackTypeClick;
FOUNDATION_EXPORT NSString *const KEventTrackTypePvopen;
FOUNDATION_EXPORT NSString *const KEventTrackTypePvclose;
FOUNDATION_EXPORT NSString *const KEventTrackPagePause;
FOUNDATION_EXPORT NSString *const KEventTrackPageResume;
FOUNDATION_EXPORT NSString *const KEventTrackTypeInput;


#pragma mark - User
FOUNDATION_EXPORT NSString *const KMultilogin;
FOUNDATION_EXPORT NSString *const KUserName;
FOUNDATION_EXPORT NSString *const KUserNameMask;
FOUNDATION_EXPORT NSString *const KMobile;
FOUNDATION_EXPORT NSString *const KMobileMask;
FOUNDATION_EXPORT NSString *const KRealNameAuth;
FOUNDATION_EXPORT NSString *const KMail;
FOUNDATION_EXPORT NSString *const KIdNo;
FOUNDATION_EXPORT NSString *const KIdNoMask;
FOUNDATION_EXPORT NSString *const KCreateTime;
FOUNDATION_EXPORT NSString *const KCoreCustomerId;
