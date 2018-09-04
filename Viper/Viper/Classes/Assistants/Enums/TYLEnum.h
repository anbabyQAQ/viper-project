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

#endif /* TYLEnum_h */
