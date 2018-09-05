//
//  TYLTableViewDelegateSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLTableViewDelegateSwizzler.h"
#import "UITableView+TYLTrackProperties.h"

@implementation TYLTableViewDelegateSwizzler

- (void)tyl_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYLClickTrackModel *model = [TYLClickTrackModel new];
    model.type = KEventTrackTypeClick;
    model.uniqueId = [TYLTableViewDelegateSwizzler uniqueIdOfTableView:tableView atRowAtIndexPath:indexPath];
    
    UIViewController *curVC = [self currentController];
    if (curVC) {
        model.page = NSStringFromClass(curVC.class);
    }
    
    if ([tableView conformsToProtocol:@protocol(TYLTrackingUIViewProtocol)]) {
        
    }
    
    model.biEvent = [[TYLMapTranslator sharedInstance] biEventWithUniqueKey:model.uniqueId];

    //    NSLog(@"model.uniqueId : %@",model.uniqueId);
    
    if ([self conformsToProtocol:@protocol(TYLTrackingUIViewProtocol)] && [self respondsToSelector:@selector(trackAnalytics_tableView:autoTrackPropertiesAtIndexPath:)]) {
        NSDictionary *propertiesDic = [tableView.trackDelegate trackAnalytics_tableView:tableView autoTrackPropertiesAtIndexPath:indexPath];
        [TYLClassUtil batchAssign:model params:propertiesDic];
    }
    
    if ([NSString isNotEmpty:model.biEvent]) {
        model.content = [[TYLMapTranslator sharedInstance] biContentWithUniqueKey:model.uniqueId];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *business = [TYLTableViewDelegateSwizzler businessContentOnCell:cell];
        model.businessContent = [NSString stringWithFormat:@"点击(tableView):%@",business];
        
        [[TYLTracking sharedInstance] trackModel:model];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *business = [TYLTableViewDelegateSwizzler businessContentOnCell:cell];
        model.businessContent = [NSString stringWithFormat:@"点击(tableView):%@_row:%@",business,@(indexPath.row)];
        
        [[TYLTracking sharedInstance] trackModel:model];
    }
    
    [self tyl_tableView:tableView didSelectRowAtIndexPath:indexPath];
}


+ (NSString *)uniqueIdOfTableView:(UITableView *)tableView atRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    return [TYLTableViewDelegateSwizzler uniqueIdOfHierarchyOnView:cell atIndexPath:indexPath];;
}

+ (NSString *)uniqueIdOfHierarchyOnView:(UIView *)view atIndexPath:(NSIndexPath *)indexPath {
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView *curView = view;
    UIView *superView = view.superview;
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
    
    //add indexPath
    [content appendString:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
    
    //    NSLog(@"conent : %@",content);
    
    return [TYLEncryptManager Sha256:content];;
}

+ (NSString *)businessContentOnCell:(UITableViewCell *)cell {
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        return @"";
    }
    
    UIView *curView = cell;
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
        
        Class contentView = NSClassFromString(@"UITableViewCellContentView");
        if ([view isKindOfClass:contentView]) {
            [content appendString:[self processCellContentView:view]];
        }
    }
    
    return [content copy];
}

+ (NSString *)processCellContentView:(UIView *)view {
    NSArray *subViews = [view subviews];
    NSMutableString *content = [NSMutableString new];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UILabel class]] && !view.isHidden) {
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


@end
