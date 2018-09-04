//
//  TYLPresenter.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLPresenter.h"
#import "TYLEventHandler_Private.h"

@class TYLInteractor, TYLWireframe;
@protocol TYLViewProtocol;

@interface TYLPresenter () <TYLEventHandler_Private>

@property (nonatomic, strong) TYLInteractor *innerInteractor;
@property (nonatomic, strong) TYLWireframe  *innerWirframe;
@property (nonatomic, weak) id<TYLViewProtocol>  innerViewProtocol;

@end

@implementation TYLPresenter

/* 防止空指针异常 start */
- (void)handleViewDidLoad{}
- (void)handleViewWillAppear{}
- (void)handleViewDidAppear{}
- (void)handleViewWillDisappear{}
- (void)handleViewDidDisappear{}
- (void)handleViewWillDestroy{}
- (void)handleViewWillGoBack{}
- (void)handleViewDidGoBack{}
/* 防止空指针异常 end */

- (void)configInteractor:(TYLInteractor *)interactor {
    self.innerInteractor = interactor;
    SEL interactorSEL = NSSelectorFromString(@"setInteractor:");
    if ([self respondsToSelector:interactorSEL] &&
        [interactor isKindOfClass:[TYLInteractor class]]) {
        IMP imp = [self methodForSelector:interactorSEL];
        void (*func)(id,SEL,id) = (void *)imp;
        func(self, interactorSEL, interactor);
    }
}
- (void)configWireframe:(TYLWireframe *)wireframe {
    self.innerWirframe = wireframe;
    SEL wireframeSEL = NSSelectorFromString(@"setWireframe:");
    if ([self respondsToSelector:wireframeSEL] &&
        [wireframe isKindOfClass:[TYLWireframe class]]) {
        IMP imp = [self methodForSelector:wireframeSEL];
        void (*func)(id,SEL,id) = (void *)imp;
        func(self, wireframeSEL, wireframe);
    }
}
- (void)configViewProtocol:(id<TYLViewProtocol>)viewProtocol {
    self.innerViewProtocol = viewProtocol;
    SEL viewProtocolSEL = NSSelectorFromString(@"setViewProcotol:");
    if ([self respondsToSelector:viewProtocolSEL] &&
        [viewProtocol conformsToProtocol:@protocol(TYLViewProtocol)]) {
        IMP imp = [self methodForSelector:viewProtocolSEL];
        void(*func)(id,SEL,id) = (void *)imp;
        func(self, viewProtocolSEL, viewProtocol);
    }
}

- (void)innerHandleViewWillGoBack {
    [self handleViewWillGoBack];
}

- (void)innerHandleGoBack {
    [self innerHandleViewWillGoBack];
//    [self.innerWireframe goBack];
    [self innerHandleViewDidGoBack];
}

- (void)innerHandleViewDidGoBack {
    [self handleViewDidGoBack];
}

- (void)dealloc {
    NSLog(@"%@ released.", [self class]);
}

@end
