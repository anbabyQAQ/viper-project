//
//  TYLInteractor_Private.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLInteractor.h"

@protocol TYLDataSource, TYLEventHandler;

@interface TYLInteractor ()

- (void)configPrefixInfo:(NSDictionary *)info;
- (void)configEventHandler:(id<TYLEventHandler>)eventHandler;
- (void)configDataSource:(id<TYLDataSource>)dataSource;

@end
