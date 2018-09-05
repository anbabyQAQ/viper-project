//
//  TYLViperViewController.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLViperViewController.h"
#import "TYLEventHandler_Private.h"
#import <objc/runtime.h>

@protocol TYLEventHandler, TYLEventHandler_Private, TYLDataSource;

@interface TYLViperViewController () {
    BOOL _hasLoaded;
}

@property (nonatomic, strong) id<TYLEventHandler, TYLEventHandler_Private> innerEventHandler;
@property (nonatomic, strong) id<TYLDataSource> innerDataSource;

@end

@implementation TYLViperViewController

- (instancetype)init {
    if (self = [super init]) {
        _hasLoaded = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // View did load
    if (!_hasLoaded) {
        _hasLoaded = YES;
        if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(handleViewDidLoad)]) {
            [self.innerEventHandler handleViewDidLoad];
        }
    }
    // View will appear
    [super viewWillAppear:animated];
    if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(handleViewWillAppear)]) {
        [self.innerEventHandler handleViewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(handleViewDidAppear)]) {
        [self.innerEventHandler handleViewDidAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(handleViewWillDisappear)]) {
        [self.innerEventHandler handleViewWillDisappear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(handleViewDidDisappear)]) {
        [self.innerEventHandler handleViewDidDisappear];
    }
}

- (void)dealloc {
    if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(handleViewWillDestroy)]) {
        [self.innerEventHandler handleViewWillDestroy];
    }
    NSLog(@"%@ released.", [self class]);
}

- (void)goBack {
    if (self.innerEventHandler && [self.innerEventHandler respondsToSelector:@selector(innerHandleGoBack)]) {
        [self.innerEventHandler innerHandleGoBack];
    }
}

- (void)configEventHandler:(id<TYLEventHandler, TYLEventHandler_Private>)eventHandler {
    self.innerEventHandler = eventHandler;
    SEL eventHandlerSEL = NSSelectorFromString(@"setEventHandler:");
    if ([self respondsToSelector:eventHandlerSEL] &&
        [eventHandler conformsToProtocol:@protocol(TYLEventHandler)]) {
        // ignore: NPEventHandler_Private
        IMP imp = [self methodForSelector:eventHandlerSEL];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, eventHandlerSEL, eventHandler);
    }
}

- (void)configDataSource:(id<TYLDataSource>)dataSource {
    self.innerDataSource = dataSource;
    SEL dataSourceSEL = NSSelectorFromString(@"setDataSource:");
    if ([self respondsToSelector:dataSourceSEL] &&
        [dataSource conformsToProtocol:@protocol(TYLDataSource)]) {
        IMP imp = [self methodForSelector:dataSourceSEL];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, dataSourceSEL, dataSource);
    }
}

#pragma mark - NPViperProcotol
- (NSString *)interactorClassName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)presenterClassName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)wireframeClassName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
