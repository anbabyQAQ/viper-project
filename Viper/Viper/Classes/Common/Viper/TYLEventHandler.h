//
//  TYLEventHandler.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLEventHandler <NSObject>

@optional
- (void)handleViewDidLoad;
- (void)handleViewWillAppear;
- (void)handleViewDidAppear;
- (void)handleViewWillDisappear;
- (void)handleViewDidDisappear;
- (void)handleViewWillDestroy;
- (void)handleViewWillGoBack;
- (void)handleViewDidGoBack;

@end
