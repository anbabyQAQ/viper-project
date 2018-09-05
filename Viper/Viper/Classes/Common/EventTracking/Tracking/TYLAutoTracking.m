//
//  TYLAutoTracking.m
//  Nirvana
//
//  Created by tianyulong on 2017/12/5.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLAutoTracking.h"

@implementation TYLAutoTracking
dSINGLETON_FOR_CLASS(TYLAutoTracking)

+ (void)load {
    [self addSwizzles];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[TYLMapTranslator sharedInstance] updateTrackingVersion:dTRACKINGINITIALVERSION];
        [[TYLMapTranslator sharedInstance] updateTrackingChannel:dTRACKINGCHANNEL];
    });
}


/**
 对需要的类，添加swizzle
 */
+ (void)addSwizzles {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = NULL;
        //UIViewController
        [TYLSwizzler swizzleWithClass:[UIViewController class]
                    originalSelector:@selector(viewDidAppear:)
                     swizzleSelector:@selector(np_viewDidAppear:)
                               error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle viewDidAppear: on UIViewController. Details: %@", error);
            error = NULL;
        }
        
        [TYLSwizzler swizzleWithClass:[UIViewController class]
                    originalSelector:@selector(viewDidDisappear:)
                     swizzleSelector:@selector(np_viewDidDisappear:)];
        
        if (error) {
            NSLog(@"Failed to swizzle viewDidDisappear: on UIViewController. Details: %@", error);
            error = NULL;
        }
        
        //UIControl
        [TYLSwizzler swizzleWithClass:[UIControl class]
                    originalSelector:@selector(sendAction:to:forEvent:)
                     swizzleSelector:@selector(np_sendAction:to:forEvent:)
                               error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle sendAction:to:forEvent:: on UIControl. Details: %@", error);
            error = NULL;
        }
        
        //postNotificationName:object:userInfo:
        [TYLSwizzler swizzleWithClass:[NSNotificationCenter class]
                    originalSelector:@selector(postNotification:)
                     swizzleSelector:@selector(np_postNotification:)
                               error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle postNotification on NSNotificationCenter. Details: %@", error);
            error = NULL;
        }
        
        [TYLSwizzler swizzleWithClass:[NSNotificationCenter class]
                    originalSelector:@selector(postNotificationName:object:userInfo:)
                     swizzleSelector:@selector(np_postNotificationName:object:userInfo:)
                               error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle postNotificationName:object:userInfo: on NSNotificationCenter. Details: %@", error);
            error = NULL;
        }
        
        //UIApplication
//        [NPSwizzler swizzleWithClass:[UIApplication class]
//                    originalSelector:@selector(sendAction:to:from:forEvent:)
//                     swizzleSelector:@selector(np_sendAction:to:from:forEvent:)
//                               error:&error];
//
//        if (error) {
//            NSLog(@"Failed to swizzle sendAction:to:from:forEvent: on UIApplication. Details: %@", error);
//        }
        
        //UITableView
        [TYLSwizzler swizzleWithClass:[UITableView class]
                    originalSelector:@selector(setDelegate:)
                     swizzleSelector:@selector(np_setDelegate:)
                               error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle np_setDelegate: on UITableView. Details: %@", error);
            error = NULL;
        }
        
        //UIView
        [TYLSwizzler swizzleWithClass:[UIView class]
                    originalSelector:@selector(addGestureRecognizer:)
                     swizzleSelector:@selector(np_addGestureRecognizer:)
                               error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle np_addGestureRecognizer: on UIView. Details: %@", error);
        }
    });
}
@end
