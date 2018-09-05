//
//  UIView+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIView+TYLSwizzler.h"

@implementation UIView (TYLSwizzler)

- (void)tyl_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self tyl_addGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] ||
        [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        
        UIView *targetView = gestureRecognizer.view;
        UIViewController *curVC = [self currentController];
        
        if (targetView && curVC) {
            NSString *vcClass = [NSStringFromClass([curVC class]) uppercaseString];
            BOOL shouldTrack = [self shouldTrackGestureClass:[targetView class]];
            
            if ([vcClass hasPrefix:@"TYL"] && shouldTrack) {
                TYLClickTrackModel *model = [TYLClickTrackModel new];
                model.type = KEventTrackTypeClick;
                NSString *strOfHiera = [self uniqueIdOfHierarchy];
                model.page = vcClass;
                
                NSString *urlStr = curVC.currentURL.urlString?:@"";
                model.uniqueId = [TYLEncryptManager Sha256:[NSString stringWithFormat:@"%@%@",vcClass,strOfHiera]];
                model.biEvent = [[TYLMapTranslator sharedInstance] biEventWithUniqueKey:model.uniqueId];
                
                if (self.trackAnalyticsIgnoreView) {
                    if ([NSObject nonnullObject:self.trackAnalyticsViewProperties]) {
                        [TYLClassUtil batchAssign:model params:self.trackAnalyticsViewProperties];
                    }
                }
                
                if ([NSString isNotEmpty:model.biEvent]) {
                    model.content = [[TYLMapTranslator sharedInstance] biContentWithUniqueKey:model.uniqueId];
                    model.businessContent = [NSString stringWithFormat:@"点击(gesture):%@",[self businessContent]];
                    [[TYLTracking sharedInstance] trackModel:model];
                }
                else {
                    model.businessContent = [NSString stringWithFormat:@"点击(gesture):%@",[self businessContent]];
                    [[TYLTracking sharedInstance] trackModel:model];
                }
            }
        }
    }
}

- (NSString *)businessContent {
    if (![self isKindOfClass:[UIView class]]) {
        return @"";
    }
    
    UIView *curView = self;
    NSMutableString *content = [NSMutableString new];
    NSArray *sViews = [curView subviews];
    
    for (UIView *view in sViews) {
        if ([view isKindOfClass:[UILabel class]]) {
            NSString *text = [((UILabel *)view) text];
            if (text) {
                [content appendString:text];
                [content appendString:@"-"];
            }
        }
        
        if ([view isKindOfClass:[UIButton class]]) {
            NSString *text = [[((UIButton *)view) titleLabel] text];
            if (text) {
                [content appendString:text];
                [content appendString:@"-"];
            }
        }
    }
    
    return [content copy];
}

- (NSString *)uniqueIdOfHierarchy {
    if (![self isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView *curView = self;
    UIView *superView = curView.superview;
    NSMutableString *content = [NSMutableString new];
    
    while (superView) {
        NSArray *subviews = superView.subviews;
        NSInteger counts = subviews.count;
        for (NSInteger index = 0; index < counts; index++) {
            UIView *tView = subviews[index];
            if ([tView isEqual:curView]) {
                [content appendFormat:@"%@[%ld]",NSStringFromClass([tView class]),(long)index];
            }
        }
        
        curView = superView;
        superView = curView.superview;
    }
    
    return content;
}

- (UIViewController *)currentController {
    if (![self isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIViewController *curVC = nil;;
    UIResponder *responder = [self nextResponder];
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    
    if (responder) {
        curVC = (UIViewController *)responder;
    }
    
    return curVC;
}

- (BOOL)shouldTrackGestureClass:(Class)aClass {
    static NSSet *blacklistedClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不需要跟踪的UIView类添加到这里
        NSArray *blacklistedClassNames = @[@"UIButton",@"UITextField"];
        NSMutableSet *transformedClasses = [NSMutableSet setWithCapacity:blacklistedClassNames.count];
        for (NSString *className in blacklistedClassNames) {
            [transformedClasses addObject:NSClassFromString(className)];
        }
        blacklistedClasses = [transformedClasses copy];
    });
    
    BOOL shouldTrack = ![blacklistedClasses containsObject:aClass];
    
    return shouldTrack;
}

@end
