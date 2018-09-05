//
//  UIApplication+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIApplication+TYLSwizzler.h"

@implementation UIApplication (TYLSwizzler)

- (BOOL)tyl_sendAction:(SEL)action to:(id)to from:(id)from forEvent:(UIEvent *)event {
    /*
     跟踪application的行为事件
     */
    
    return [self tyl_sendAction:action to:to from:from forEvent:event];
}

@end
