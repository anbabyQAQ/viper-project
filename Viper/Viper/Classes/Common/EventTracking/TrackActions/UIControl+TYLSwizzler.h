//
//  UIControl+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (TYLSwizzler)

/**
 hook UIControl的方法sendAction:to:forEvent:
 
 @param action action
 @param target target
 @param event event
 */
- (void)tyl_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END

