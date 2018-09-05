//
//  TYLViewControllerFactory.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 ViewController工厂
 */
@interface TYLViewControllerFactory : NSObject

+ (UIViewController *)viewControllerFromHost:(NSString *)host;
+ (UIViewController *)viewControllerFromHost:(NSString *)host info:(NSDictionary *)info;


@end
