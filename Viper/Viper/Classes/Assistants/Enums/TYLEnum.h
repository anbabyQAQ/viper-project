//
//  TYLEnum.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//


/*
 *  定义枚举常量
 */

#ifndef TYLEnum_h
#define TYLEnum_h

/**
 网络加载时的loading视图状态
 */
typedef NS_ENUM(NSInteger, UILoadStatus) {
    UILoadStart = 5,        //开始加载&提交数据
    UILoadFail,             //加载&提交失败
    UILoadSuccess,          //加载&提交成功
    UILoadHide,             //隐藏视图
    UILoadOnlyText,         //只有文字的提示
};


/**
 *
 */

typedef NS_ENUM(NSInteger, TYLResponseErrorCode) {
    //status
    ResponseStatus_ok = 0,              // 服务器处理成功
    ResponseStatus_error = 1,           // 服务器处理错误
    ResponseStatus_exception = -1,      // 服务器处理异常
    
    
    //erro
    ResponseErrorCode_706 = 706,        // token过期或多点登录，需要重新登录
};

typedef NS_ENUM(NSUInteger, TYLTrackPlatform) {
    TYLTrackPlatformAndroid = 1,
    TYLTrackPlatformiOS,
    TYLTrackPlatformH5,
    TYLTrackPlatformPC,
};

// 运营商类型
typedef NS_ENUM(NSUInteger, TYLTrackMobileOperator) {
    TYLTrackMobileOperator_ChinaMobile = 1,
    TYLTrackMobileOperator_ChinaComm,
    TYLTrackMobileOperator_ChinaTelecom,
    TYLTrackMobileOperator_Other,
};
// 网络类型
typedef NS_ENUM(NSUInteger, TYLTrackNetworkType) {
    TYLTrackNetworkTypeWifi = 1,
    TYLTrackNetworkType2G,
    TYLTrackNetworkType3G,
    TYLTrackNetworkType4G,
    TYLTrackNetworkTypeOther,
};



#endif /* TYLEnum_h */
