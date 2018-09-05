//
//  TYLInteractor.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLInteractor.h"

@protocol TYLEventHandler, TYLDataSource;

@interface TYLInteractor ()

@property (nonatomic, copy) NSDictionary *prefixInfo;
@property (nonatomic, weak) id<TYLEventHandler> innerEventHandler;
@property (nonatomic, weak) id<TYLDataSource> innerDataSource;

@end


@implementation TYLInteractor

- (void)configPrefixInfo:(NSDictionary *)info {
    self.prefixInfo = info;
    [TYLClassUtil batchAssign:self params:info];
}

- (void)configEventHandler:(id<TYLEventHandler>)eventHandler {
    self.innerEventHandler = eventHandler;
    SEL eventHandlerSEL = NSSelectorFromString(@"setEventHandler:");
    if ([self respondsToSelector:eventHandlerSEL] &&
        [eventHandler conformsToProtocol:@protocol(TYLEventHandler)]) {
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

- (void)dealloc {
    NSLog(@"%@ released.", [self class]);
}


@end
