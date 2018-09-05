//
//  TYLTableViewDelegateSwizzler.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLTableViewDelegateSwizzler : NSObject

- (void)tyl_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
