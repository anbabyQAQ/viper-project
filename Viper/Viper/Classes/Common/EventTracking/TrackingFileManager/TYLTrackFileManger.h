//
//  TYLTrackFileManger.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLTrackFileManger : NSObject

dSINGLETON_FOR_CLASS_HEADER(TYLTrackFileManger)


/**
 埋点日志文件存放路径
 
 @return return value
 */
- (NSString *)trackFilePath;

/**
 判断埋点日志记录文件是否存在
 
 @return YES: 埋点日志记录不为空
 */
- (BOOL)trackFileIsNotEmpty;


/**
 判断打包文件是否不为空
 
 @return YES:不为空
 */
- (BOOL)archiveFileIsNotEmpty;

/**
 将埋点记录写入文件
 
 @param aTrackRecord aTrackRecord
 */
- (void)writeToFileWithRecord:(NSString *)aTrackRecord;

#pragma mark -
#pragma mark upload
/**
 把埋点数据的记录文件上传至服务器
 */
- (void)uploadTrackFileToServer;

- (void)uploadTrackFileToServerWithCompletion:(void (^)(BOOL success, NSError *error))handler;

/**
 上传埋点记录数据到埋点服务器
 
 @param records 埋点记录
 @param handler handler
 */
- (void)uploadTrackRecords:(NSArray *)records toServerWithCompletion:(void (^)(BOOL success, NSError *error))handler;

/**
 上传archive文件的日志记录到服务器
 
 @param handler handler
 */
- (void)uploadTrackArchiveToServerWithCompletion:(void (^)(BOOL success, NSError *error))handler;

#pragma mark -
#pragma mark clear
/**
 清除埋点日志文件内容
 */
- (void)clearContent;

/**
 清理埋点日志的压缩文件信息
 */
- (void)clearZipFile;

/**
 所有的埋点日志文件信息
 */
- (void)clearTrackFileInfo;

/**
 清理埋点的打包文件
 */
- (void)clearArchiveFile;

#pragma mark -
#pragma mark 压缩埋点日志文件

- (BOOL)zipEventTrackFile;

#pragma mark -
#pragma mark archive && unarchive
- (BOOL)archiveTrackRecords:(NSArray *)records;

- (NSArray *)unarchiveTrackFile;



@end
