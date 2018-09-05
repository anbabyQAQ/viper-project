//
//  TYLViewControllerFactory.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLViewControllerFactory.h"

#import "TYLPresenter_Private.h"
#import "TYLInteractor_Private.h"
#import "TYLEventHandler_Private.h"
#import "TYLViperViewController_Private.h"

@interface TYLViewControllerFactory ()

+ (UIViewController *)viewControllerFromClassName:(NSString *)className;
+ (UIViewController *)viewControllerFromClassName:(NSString *)className info:(NSDictionary *)info;

@end

@implementation TYLViewControllerFactory

+ (UIViewController *)viewControllerFromHost:(NSString *)host {
    return [[self class] viewControllerFromClassName:host info:nil];
}

+ (UIViewController *)viewControllerFromHost:(NSString *)host info:(NSDictionary *)info {
    if (![host isKindOfClass:[NSString class]] || [host length] == 0) {
        return nil;
    }
    // 首字母大写
    NSString *className = [NSString stringWithFormat:@"TYL%@%@ViewController",[[host substringToIndex:1] uppercaseString], [host substringFromIndex:1]];
    return [[self class] viewControllerFromClassName:className info:info];
}

+ (UIViewController *)viewControllerFromClassName:(NSString *)className {
    return [[self class] viewControllerFromClassName:className info:nil];
}

+ (UIViewController *)viewControllerFromClassName:(NSString *)className info:(NSDictionary *)info {
    if (![className isKindOfClass:[NSString class]] || [className length] == 0) {
        return nil;
    }
    Class vcClass = NSClassFromString(className);
    if (![vcClass isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    UIViewController *vc = [vcClass new];
//    [self class] configvi
    return vc;
}

+ (void)configViper:(UIViewController *)vc info:(NSDictionary *)info {
    if (![vc isKindOfClass:[TYLViperViewController class]]) {
        return ;
    }
    TYLViperViewController *viperVC = (TYLViperViewController *)vc;
    
    [TYLClassUtil batchAssign:viperVC params:info];
    
    // 展示器 presenter
    NSString *presenterClassName = [viperVC presenterClassName];
    Class presenterClass = NSClassFromString(presenterClassName);
    TYLPresenter *presenter = nil;
    if (![presenterClass isSubclassOfClass:[TYLPresenter class]]) {
        return;
    }
    presenter = [presenterClass new];
    [presenter configViewProtocol:viperVC]; // 配置presenter的UI，由viperVC 实现viewProtocol协议
    
    // 路由 wireframe
    NSString *wireframeClassName = [viperVC wireframeClassName];
    Class wireframeClass = NSClassFromString(wireframeClassName);
    TYLWireframe *wireframe = nil;
    if ([wireframeClass isSubclassOfClass:[TYLWireframe class]]) {
        wireframe = [wireframeClass new];
        [presenter configWireframe:wireframe];  // 配置presenter的路由，由presenter负责app的控制器栈线框
    }
    
    // 交互器 interactor
    NSString *interactorClassName = [viperVC interactorClassName];
    Class interactorClass = NSClassFromString(interactorClassName);
    TYLInteractor *interactor = nil;
    if ([interactorClass isSubclassOfClass:[TYLInteractor class]]) {
        interactor = [interactorClass new];
        [interactor configPrefixInfo:info];  // 配置interactor的参数赋值
        [interactor configDataSource:presenter];  // 配置interactor的全局datasource数据源
        [interactor configEventHandler:presenter];  // 配置interactor的全局presenter展示器
        [presenter configInteractor:interactor];  // 配置presenter的交互器，由presenter负责调起交互事件
    }
    
    [viperVC configEventHandler:(id<TYLEventHandler_Private,TYLEventHandler>)presenter];
    [viperVC configDataSource:(id<TYLDataSource>)presenter];
}

@end
