//
//  NSObject+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "NSObject+TYLSwizzler.h"

@implementation NSObject (TYLSwizzler)


- (UIViewController *)currentController {
    if ([self isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)self;
    }
    
    if (![self isKindOfClass:[UIView class]] || ![self isKindOfClass:[UIResponder class]]) {
        return nil;
    }
    
    UIViewController *curVC = nil;;
    UIResponder *responder = [(UIResponder *)self nextResponder];
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    
    if (responder) {
        curVC = (UIViewController *)responder;
    }
    
    return curVC;
}

- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
        
    }
    return [UIApplication sharedApplication].keyWindow;
}


@end
