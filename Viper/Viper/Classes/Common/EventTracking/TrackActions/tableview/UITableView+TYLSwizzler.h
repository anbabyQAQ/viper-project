//
//  UITableView+TYLSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TYLSwizzler)  <TYLTrackingUIViewProtocol>

- (void)tyl_setDelegate:(id<UITableViewDelegate>)delegate;


@end
NS_ASSUME_NONNULL_END
