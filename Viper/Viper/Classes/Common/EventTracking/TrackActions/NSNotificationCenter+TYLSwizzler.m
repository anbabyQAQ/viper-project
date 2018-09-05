//
//  NSNotificationCenter+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "NSNotificationCenter+TYLSwizzler.h"

@implementation NSNotificationCenter (TYLSwizzler)

- (void)tyl_postNotification:(NSNotification *)notification {
    if ([NSNotificationCenter shouldTrackNotificationNamed:notification.name] ) {
        [[TYLTracking sharedInstance] trackModel:nil];
    }
    
    [self tyl_postNotification:notification];
}

- (void)tyl_postNotificationName:(NSString *)name
                         object:(nullable id)object
                       userInfo:(nullable NSDictionary *)info {
    
    if ([NSNotificationCenter shouldTrackNotificationNamed:name] ) {
        if ([name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
            //app从后台被激活时
            [self processEventTrackAtLaunch];
        }
        else if ([name isEqualToString:UIApplicationWillResignActiveNotification] ||
                 [name isEqualToString:UIApplicationWillTerminateNotification]) {
            //app进入后台时
            [self processEventTrackAtTerminated];
        }
        else if ([name isEqualToString:UITextFieldTextDidChangeNotification]) {
            //TextField输入变化时
            [self processTextFieldChanged:object];
        }
    }
    
    [self tyl_postNotificationName:name object:object userInfo:info];
}

#pragma mark - app启动或者从后台被激活时

- (void)processEventTrackAtLaunch {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:3];
    
    [queue addOperationWithBlock:^{
        TYLLaunchTrackModel *lauchModel = [TYLLaunchTrackModel new];
        lauchModel.type = KEventTrackTypeLaunch;
        NSTimeInterval timestamp = floor([[NSDate date] timeIntervalSince1970] * 1000);
        NSString *uuid = [UIDevice deviceIdentifierID];
        NSString *flag = [TYLEncryptManager Sha256:[NSString stringWithFormat:@"%@%f",uuid,timestamp]];
        //flag
        if (flag) {
            [TYLUserDefaultsUtil setUserDefaultsObject:flag forKey:@"EventTracking_Launch_Flag"];
            lauchModel.flag = flag;
        }
        
        lauchModel.businessContent = @"启动app";
        [[TYLTracking sharedInstance] trackModel:lauchModel];
    }];
    
    [queue addOperationWithBlock:^{
        TYLTrackFileManger *tfManger =  [TYLTrackFileManger sharedInstance];
        if ([tfManger archiveFileIsNotEmpty]) {
            [tfManger uploadTrackArchiveToServerWithCompletion:^(BOOL success, NSError *error) {
                if (success) {
                    [tfManger clearArchiveFile];
                }
            }];
        }
    }];
    
    [queue addOperationWithBlock:^{
        [[TYLMapTranslator sharedInstance] fetchTrackingMapFile];
    }];
}

- (void)processEventTrackAtTerminated {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *termminateOpe = [NSBlockOperation blockOperationWithBlock:^{
        TYLLaunchTrackModel *lauchModel = [TYLLaunchTrackModel new];
        lauchModel.type = KEventTrackTypeTerminated;
        lauchModel.createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
        lauchModel.businessContent = @"退出app";
        [[TYLTracking sharedInstance] trackModel:lauchModel];
        
        NSString *flag = [TYLUserDefaultsUtil userDefaultsObject:@"EventTracking_Launch_Flag"];
        if (flag) {
            [TYLUserDefaultsUtil removeUserDefaults:@"EventTracking_Launch_Flag"];
        }
    }];
    
    NSBlockOperation *flushOpe = [NSBlockOperation blockOperationWithBlock:^{
        [[TYLTracking sharedInstance] flush];
    }];
    
    [flushOpe addDependency:termminateOpe];
    
    [queue addOperations:@[termminateOpe, flushOpe] waitUntilFinished:NO];
}

#pragma mark - UITextField 输入信息变化时
- (void)processTextFieldChanged:(UITextField *)textField {
    TYLClickTrackModel *model = [TYLClickTrackModel new];
    model.type = KEventTrackTypeInput;      //暂时把textField的textChange作为click事件，待需求明确后再修改
    model.createTime = floor([[NSDate date] timeIntervalSince1970] * 1000);
    model.uniqueId = [TYLEncryptManager Sha256:[self uniqueIdOfHierarchyOnView:textField]];
    model.inputContent = textField.text;
    model.biEvent = [[TYLMapTranslator sharedInstance] biEventWithUniqueKey:model.uniqueId];
    
    if ([NSString isNotEmpty:model.biEvent]) {
        model.content = [[TYLMapTranslator sharedInstance] biContentWithUniqueKey:model.uniqueId];
        model.businessContent = [NSString stringWithFormat:@"输入:%@",[self businessContentOn:textField]];
        
        [[TYLTracking sharedInstance] trackModel:model];
    }
}

- (NSString *)businessContentOn:(UITextField *)textField {
    UIView *curView = textField;
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

/**
 获取view层级树的倒序排列的sha256哈希
 
 @return return sha256 Hashvalue
 */
- (NSString *)uniqueIdOfHierarchyOnView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView *curView = view;
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

+ (BOOL)shouldTrackNotificationNamed:(NSString *)name {
    //白名单
    NSArray *names = @[
                       // UITextField Editing
                       UITextFieldTextDidEndEditingNotification,
                       UITextFieldTextDidChangeNotification,
                       
                       // UIApplication Lifecycle
                       UIApplicationDidFinishLaunchingNotification,
                       UIApplicationDidBecomeActiveNotification,
                       UIApplicationWillResignActiveNotification,
                       UIApplicationWillTerminateNotification];
    NSSet<NSString *> *whiteListedNotificationNames = [NSSet setWithArray:names];
    
    return [whiteListedNotificationNames containsObject:name];
}


@end
