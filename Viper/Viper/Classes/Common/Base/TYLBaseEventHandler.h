//
//  TYLBaseEventHandler.h
//  Nirvana
//
//  Created by xinglei on 23/09/2017.
//  Copyright © 2017 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLBaseEventHandler <TYLEventHandler>


@optional
/*************************************  可选协议 ***********************************/
/**
 处理多点登录
 */
- (void)handleMultilogin;

/**
 TableViewCell点击事件
 
 @param indexPath indexPath
 */
- (void)handleDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
