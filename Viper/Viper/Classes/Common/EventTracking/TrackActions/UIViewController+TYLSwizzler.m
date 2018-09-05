//
//  UIViewController+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIViewController+TYLSwizzler.h"

@implementation UIViewController (TYLSwizzler)

- (void)tyl_viewDidAppear:(BOOL)animated {
    if ([self shouldTrackClass:self.class]) {
        TYLPVTrackModel *model = [TYLPVTrackModel new];
        model.type = KEventTrackTypePvopen;
        model.pauseResume = KEventTrackPageResume;
        model.uniqueId = NSStringFromClass(self.class);
        model.lastPage = self.lastURL.urlString;
        model.pageUrl = self.currentURL.urlString;
        model.createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
        model.biEvent = [[TYLMapTranslator sharedInstance] biEventWithUniqueKey:model.uniqueId];
        
        if ([self respondsToSelector:@selector(trackProperties)] && [self conformsToProtocol:@protocol(TYLTrackingProtocol)]) {
            [TYLClassUtil batchAssign:model params:[self trackProperties]];
        }
        
        if ([NSString isNotEmpty:model.biEvent]) {
            model.content = [[TYLMapTranslator sharedInstance] biContentWithUniqueKey:model.uniqueId];
            model.businessContent = [NSString stringWithFormat:@"进入:%@",model.biEvent];
            [[TYLTracking sharedInstance] trackModel:model];
        }
    }
    
    [self tyl_viewDidAppear:animated];
}

- (void)tyl_viewDidDisappear:(BOOL)animated {
    if ([self shouldTrackClass:self.class]) {
        TYLPVTrackModel *model = [TYLPVTrackModel new];
        model.type = KEventTrackTypePvopen;
        model.pauseResume = KEventTrackPagePause;
        model.uniqueId = NSStringFromClass(self.class);
        model.lastPage = self.lastURL.urlString;
        model.pageUrl = self.currentURL.urlString;
        model.createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
        model.biEvent = [[TYLMapTranslator sharedInstance] biEventWithUniqueKey:model.uniqueId];
        if ([NSString isNotEmpty:model.biEvent]) {
            model.content = [[TYLMapTranslator sharedInstance] biContentWithUniqueKey:model.uniqueId];
            model.businessContent = [NSString stringWithFormat:@"离开:%@",model.biEvent];
            [[TYLTracking sharedInstance] trackModel:model];
        }
    }
    
    [self tyl_viewDidDisappear:animated];
}

#pragma mark - NPAutoTrackingProtocol
- (NSString *)trackTitle {
    NSString *curTitle = self.navigationItem.title;
    return [NSString isNotEmpty:curTitle] ? curTitle : self.title;
}

//ViewController跟踪的黑名单
- (BOOL)shouldTrackClass:(Class)aClass {
    static NSSet *blacklistedClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *blacklistedClassNames = @[ @"UICompatibilityInputViewController",
                                            @"UIKeyboardCandidateGridCollectionViewController",
                                            @"UIInputWindowController",
                                            @"UICompatibilityInputViewController"
                                            ];
        NSMutableSet *transformedClasses = [NSMutableSet setWithCapacity:blacklistedClassNames.count];
        for (NSString *className in blacklistedClassNames) {
            [transformedClasses addObject:NSClassFromString(className)];
        }
        blacklistedClasses = [transformedClasses copy];
    });
    
    return ![blacklistedClasses containsObject:aClass];
}


@end
