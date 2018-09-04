//
//  UIViewController+TYLURL.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIViewController+TYLURL.h"

#import <objc/runtime.h>

static const void *_lastURL    = &_lastURL;
static const void *_currentURL = &_currentURL;

@implementation UIViewController (TYLURL)

@dynamic lastURL, currentURL;

- (void)setLastURL:(TYLURL *)lastURL {
    NSArray *vcs = self.childViewControllers;
    if (vcs.count > 0 && vcs) {
        [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __weak UIViewController *vc = obj;
            vc.lastURL = lastURL;
        }];
    }
    objc_setAssociatedObject(self, _lastURL, lastURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TYLURL *)lastURL {
    return objc_getAssociatedObject(self, _lastURL);
}

- (void)setCurrentURL:(TYLURL *)currentURL {
    NSArray *vcs = self.childViewControllers;
    if (vcs.count > 0 && vcs) {
        [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __weak UIViewController *vc = obj;
            vc.currentURL = currentURL;
        }];
    }
    objc_setAssociatedObject(self, _currentURL, currentURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TYLURL *)currentURL {
    return objc_getAssociatedObject(self, _currentURL);
}

@end
