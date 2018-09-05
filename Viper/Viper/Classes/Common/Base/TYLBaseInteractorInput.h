//
//  TYLBaseInteractorInput.h
//  Nirvana
//
//  Created by huangqun on 2017/10/23.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLBaseInteractorInput <NSObject>

@required
#pragma mark -
#pragma mark - clear data
/**
 清除所有数据
 */
- (void)clearAllData;

@optional
/*************************************  可选协议 ***********************************/
#pragma mark -
#pragma mark - tableView
/**
 获取tableView Section数量
 
 @return Section count
 */
- (NSInteger)numberOfSectionsInTableView;

/**
 获取对应Section内的行数
 
 @param section section
 @return row count
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/**
 获取对应cell的布局样式
 
 @param section section
 @return 返回样式编号
 */
- (NSInteger)cellLayoutStyleOfRowsInSection:(NSInteger)section;

/**
 获取首页每个cell的高度
 
 @param indexPath indexPath
 @return cell height
 */
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
