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
