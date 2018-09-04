//
//  TYLViperViewController_Private.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLViperViewController.h"

@protocol TYLEventHandler, TYLEventHandler_Private, TYLDataSource;

@interface TYLViperViewController ()

- (void)configEventHandler:(id<TYLEventHandler, TYLEventHandler_Private>)eventHandler;
- (void)configDataSource:(id<TYLDataSource>)dataSource;

@end
