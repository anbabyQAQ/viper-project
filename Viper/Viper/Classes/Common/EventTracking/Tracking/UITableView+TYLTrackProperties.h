//
//  UITableView+TYLTrackProperties.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYLTrackingUIViewProtocol.h"

@interface UITableView (TYLTrackProperties)

@property (nonatomic, weak) id<TYLTrackingUIViewProtocol> trackDelegate;

@end
