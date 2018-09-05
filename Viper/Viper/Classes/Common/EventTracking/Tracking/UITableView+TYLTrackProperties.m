//
//  UITableView+TYLTrackProperties.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UITableView+TYLTrackProperties.h"

#import <objc/runtime.h>

static const void *_trackDelegate = &_trackDelegate;

@implementation UITableView (TYLTrackProperties)

- (void)setTrackDelegate:(id<TYLTrackingUIViewProtocol>)trackDelegate {
    objc_setAssociatedObject(self, _trackDelegate, trackDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<TYLTrackingUIViewProtocol>)trackDelegate {
    return  objc_getAssociatedObject(self, _trackDelegate);
}

@end
