//
//  UIControl+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UIControl+TYLSwizzler.h"

@implementation UIControl (TYLSwizzler)

- (void)tyl_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self tyl_sendAction:action to:target forEvent:event];
    
    if ([self shouldTrackClass:self.class]) {
        TYLClickTrackModel *model = [TYLClickTrackModel new];
        model.type = KEventTrackTypeClick;
        NSString *strOfHiera = [self uniqueIdOfHierarchy];
        
        UIViewController *curVC = [self currentController];
        if (curVC) {
            NSString *clsName = NSStringFromClass(curVC.class);
            model.page = clsName;
            
            NSString *urlStr = curVC.currentURL.urlString?:@"";
            model.uniqueId = [TYLEncryptManager Sha256:[NSString stringWithFormat:@"%@%@%@",clsName,urlStr,strOfHiera]];
        }
        else {
            model.uniqueId = [TYLEncryptManager Sha256:strOfHiera];
        }
        
        if (self.trackAnalyticsIgnoreView) {
            if ([NSObject nonnullObject:self.trackAnalyticsViewProperties]) {
                [TYLClassUtil batchAssign:model params:self.trackAnalyticsViewProperties];
            }
        }
        
        model.biEvent = [[TYLMapTranslator sharedInstance] biEventWithUniqueKey:model.uniqueId];
        if ([NSString isNotEmpty:model.biEvent]) {
            model.content = [[TYLMapTranslator sharedInstance] biContentWithUniqueKey:model.uniqueId];
            model.businessContent = [NSString stringWithFormat:@"点击:%@",[self businessContent]];
            [[TYLTracking sharedInstance] trackModel:model];
        }
        else {
            NSString *urlStr = curVC.currentURL.urlString?:@"";
            NSString *actionStr = NSStringFromSelector(action);
            
            model.businessContent = [NSString stringWithFormat:@"点击:%@_url[%@]_action:[%@]",[self businessContent],urlStr, actionStr];
            [[TYLTracking sharedInstance] trackModel:model];
        }
    }
}

/**
 获取view层级树的倒序排列的sha256哈希
 
 @return return sha256 Hashvalue
 */
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

- (NSString *)uniqueIdOfContentByAction:(SEL)action {
    //Sha(ControllerName + className +  actionName)
    UIViewController *curController = [self currentController];
    NSString *ctrlName = NSStringFromClass(curController.class);
    NSString *className = NSStringFromClass(self.class);
    NSString *actionName = NSStringFromSelector(action);
    
    NSMutableString *content = [NSMutableString new];
    [content appendFormat:@"%@%@%@",ctrlName,className,actionName];
    
    return [TYLEncryptManager Sha256:content];
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

#pragma mark - NPAutoTrackingProtocol
- (NSString *)trackTitle {
    if ([self isKindOfClass:[UIButton class]]) {
        return ((UIButton *)self).titleLabel.text;
    }
    
    return @"";
}

- (BOOL)shouldTrackClass:(Class)aClass {
    static NSSet *blacklistedClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不需要跟踪的UIControl类添加到这里
        NSArray *blacklistedClassNames = @[];
        NSMutableSet *transformedClasses = [NSMutableSet setWithCapacity:blacklistedClassNames.count];
        for (NSString *className in blacklistedClassNames) {
            [transformedClasses addObject:NSClassFromString(className)];
        }
        blacklistedClasses = [transformedClasses copy];
    });
    
    return ![blacklistedClasses containsObject:aClass];
}


@end
