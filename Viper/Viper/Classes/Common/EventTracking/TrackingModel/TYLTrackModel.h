//
//  TYLTrackModel.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLTrackModel : NSObject

@property (nonatomic) NSString *type;                         /**< 埋点日志类型 */
@property (nonatomic) TYLTrackPlatform platform;               /**< 平台 */
@property (nonatomic, copy) NSString *deviceId;               /**< 手机端：手机id，iOS获取idfa(uuid)，安卓获取imei；h5／pc：cookie */
@property (nonatomic, copy) NSString *appv;                   /**< 版本，如v1.0，v1.01 */
@property (nonatomic, copy) NSString *ip;                     /**< 用户ip地址，用来统计用户地理位置 */
@property (nonatomic, copy) NSString *md5;                    /**< 编译后的user_id，为了规避法律风险 */
@property (nonatomic,copy) NSString *packageType;             /**< 包类型 */
@property (nonatomic,copy) NSString *deviceIdType;            /**< deviceid类型 */
@property (nonatomic, copy) NSString *system;                 /**< 操作系统 */
@property (nonatomic, copy) NSString *equipmentType;          /**< 仅移动端投递，如xiaomi，Huawei等 */
@property (nonatomic) TYLTrackNetworkType net;                 /**< 网络类型 */
@property (nonatomic, copy) NSString *res;                    /**< 显示器分辨率 */
@property (nonatomic) TYLTrackMobileOperator mobileOperator;   /**< 运营商 */
@property (nonatomic) NSTimeInterval createTime;              /**< 页面打开时间 */


@property (nonatomic, copy) NSString *biEvent;                /**< 用于bi系统识别 */
@property (nonatomic, copy) NSString *content;                /**< 用于bi系统识别 */
@property (nonatomic, copy) NSString *businessContent;        /**< 用于业务逻辑识别 */
@property (nonatomic, copy) NSString *flag;                   /**< 用于标识单次launch */


- (void)generateInfo;

@end

