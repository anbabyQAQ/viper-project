//
//  UIView+TYLTrackProperties.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIView+TYLTrackProperties.h"

#import <objc/runtime.h>

static const void *_trackAnalyticsIgnoreView    = &_trackAnalyticsIgnoreView;
static const void *_trackAnalyticsViewProperties = &_trackAnalyticsViewProperties;

@implementation UIView (TYLTrackProperties)

@dynamic trackAnalyticsIgnoreView, trackAnalyticsViewProperties;

- (void)setTrackAnalyticsIgnoreView:(BOOL)trackAnalyticsIgnoreView {
    objc_setAssociatedObject(self, _trackAnalyticsIgnoreView, trackAnalyticsIgnoreView ? @1:@0, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)trackAnalyticsIgnoreView {
    return objc_getAssociatedObject(self, _trackAnalyticsIgnoreView);
}

- (void)setTrackAnalyticsViewProperties:(NSDictionary *)trackAnalyticsViewProperties {
    objc_setAssociatedObject(self, _trackAnalyticsViewProperties, trackAnalyticsViewProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)trackAnalyticsViewProperties {
    return objc_getAssociatedObject(self, _trackAnalyticsViewProperties);
}

@end
