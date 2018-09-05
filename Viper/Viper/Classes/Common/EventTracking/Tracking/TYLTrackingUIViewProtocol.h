//
//  TYLTrackingUIViewProtocol.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLTrackingUIViewProtocol <NSObject>


@optional
/**
 实现该Protocol的UITableView对象的properties
 
 @return NSDictionary
 */
- (NSDictionary *)trackAnalytics_tableView:(UITableView *)tableView autoTrackPropertiesAtIndexPath:(NSIndexPath *)indexPath;



@optional
/**
 实现该Protocol的UICollectionView对象的properties
 
 @return NSDictionary
 */
- (NSDictionary *)trackAnalytics_collectionView:(UICollectionView *)collectionView autoTrackPropertiesAtIndexPath:(NSIndexPath *)indexPath;


@end
