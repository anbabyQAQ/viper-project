//
//  UIApplication+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (TYLSwizzler)

- (BOOL)tyl_sendAction:(SEL)action to:(id)to from:(id)from forEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
