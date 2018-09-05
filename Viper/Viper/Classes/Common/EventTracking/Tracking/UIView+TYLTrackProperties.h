//
//  UIView+TYLTrackProperties.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TYLTrackProperties)

// viewID
/*
 此 viewID 与 我之前定义的 uniqueId 功效一致，没必要再次扩展
@property (assign,nonatomic) NSString* sensorsAnalyticsViewID;
 */

// Track 时，是否忽略该 View
@property (nonatomic, assign) BOOL trackAnalyticsIgnoreView;

// Track 时，View 的扩展属性
@property (nonatomic, strong) NSDictionary* trackAnalyticsViewProperties;

@end
