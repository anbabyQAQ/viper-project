//
//  TYLPresenter_Private.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLPresenter.h"

@class TYLInteractor, TYLWireframe;
@protocol TYLViewProtocol;

@interface TYLPresenter ()

- (void)configInteractor:(TYLInteractor *)interactor;
- (void)configWireframe:(TYLWireframe *)wireframe;
- (void)configViewProtocol:(id<TYLViewProtocol>)viewProtocol;

@end
