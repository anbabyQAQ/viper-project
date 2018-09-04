//
//  TYLViperViewController.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYLViperProtocol, TYLViewProtocol;

@interface TYLViperViewController : UIViewController<TYLViewProtocol, TYLViperProtocol>

@end
