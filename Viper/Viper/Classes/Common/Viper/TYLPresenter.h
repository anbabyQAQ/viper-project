//
//  TYLPresenter.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLEventHandler ,TYLDataSource;

@interface TYLPresenter : NSObject <TYLEventHandler, TYLDataSource>

@end
