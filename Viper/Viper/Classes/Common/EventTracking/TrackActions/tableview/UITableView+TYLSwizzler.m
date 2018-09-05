//
//  UITableView+TYLSwizzler.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "UITableView+TYLSwizzler.h"
#import "TYLTableViewDelegateSwizzler.h"

@implementation UITableView (TYLSwizzler)

- (void)tyl_setDelegate:(id<UITableViewDelegate>)delegate {
    [self tyl_setDelegate:(id<UITableViewDelegate>)delegate];
    
    if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        Class aClass = [delegate class];
        NSError *error = NULL;
        
        
        [TYLSwizzler swizzleWithOriginClass:aClass
                                 originSel:@selector(tableView:didSelectRowAtIndexPath:)
                              swizzleClass:[TYLTableViewDelegateSwizzler class]
                           swizzleSelector:@selector(tyl_tableView:didSelectRowAtIndexPath:)
                                     error:&error];
        
        if (error) {
            NSLog(@"Failed to swizzle tableView:didSelectRowAtIndexPath: on UITableView. Details: %@", error);
        }
    }
}
@end
