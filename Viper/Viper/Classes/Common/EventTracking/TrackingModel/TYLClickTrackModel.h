//
//  TYLClickTrackModel.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLTrackModel.h"

@interface TYLClickTrackModel : TYLTrackModel

@property (nonatomic, copy) NSString *page;             /** <页面 */
@property (nonatomic, copy) NSString *uniqueId;
@property (nonatomic, copy) NSString *inputContent;     /** <用户输入的信息，例如textfield等*/

@end
