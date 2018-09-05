//
//  TYLPVTrackModel.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLTrackModel.h"

@interface TYLPVTrackModel : TYLTrackModel

@property (nonatomic, copy) NSString *lastPage;         /** <页面跳转来源 */
@property (nonatomic, copy) NSString *pageUrl;          /** <页面url */
@property (nonatomic, copy) NSString *uniqueId;         /** <页面所在类名称 */
@property (nonatomic, copy) NSString *pauseResume;      /**< 表示页面进入（resume）或者离开（pause）*/


@end
