//
//  UIViewController+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TYLSwizzler) <TYLTrackingProtocol>

- (void)tyl_viewDidAppear:(BOOL)animated;

- (void)tyl_viewDidDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
