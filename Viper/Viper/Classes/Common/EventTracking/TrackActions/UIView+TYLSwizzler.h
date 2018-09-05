//
//  UIView+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TYLSwizzler)

/**
 UIView的addGesture
 
 @param gestureRecognizer gestureRecognizer
 */
- (void)tyl_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

@end
