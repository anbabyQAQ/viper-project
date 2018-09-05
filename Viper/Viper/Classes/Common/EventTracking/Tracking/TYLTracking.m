//
//  TYLTracking.m
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLTracking.h"


@interface TYLTracking ()

@property (nonatomic, strong) NSMutableArray *eventQueue;

@end

@implementation TYLTracking

dSINGLETON_FOR_CLASS(TYLTracking);


- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventQueue = @[].mutableCopy;
    }
    
    return self;
}

#pragma mark - eventTrack

- (void)trackModel:(id)model {
    if (!model) return;
    
    @synchronized(self.eventQueue) {
        [self.eventQueue addObject:model];
    }
}

+ (void)trackProperties:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *record = [info objectForKey:KEventTrackRecordKey];
    [[TYLTrackFileManger sharedInstance] writeToFileWithRecord:record];
}

#pragma mark - save eventTrack to server
- (void)flush {
    [self flushWithCompletion:nil];
}

- (void)flushWithCompletion:(void (^)(void))handler {
    if (self.eventQueue.count <= 0) return;
    
    NSArray *trackInfo = [self.eventQueue yy_modelToJSONObject];
    
    [[TYLTrackFileManger sharedInstance] uploadTrackRecords:trackInfo toServerWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            //if failed,archive to file
            [[TYLTrackFileManger sharedInstance] archiveTrackRecords:trackInfo];
        }
        else {
            TYLTrackFileManger *tfManger =  [TYLTrackFileManger sharedInstance];
            if ([tfManger archiveFileIsNotEmpty]) {
                [tfManger uploadTrackArchiveToServerWithCompletion:^(BOOL success, NSError *error) {
                    if (success) {
                        [tfManger clearArchiveFile];
                    }
                }];
            }
        }
        
        [self.eventQueue removeAllObjects];
        
        if (handler) {
            handler();
        }
    }];
}

#pragma mark -
#pragma mark Method for H5 event tracking flush
- (void)flushH5Records:(NSArray *)jsonObjs completion:(void (^)(BOOL success, NSError *error))handler {
    if (!jsonObjs || jsonObjs.count == 0) return;
    
    [[TYLTrackFileManger sharedInstance] uploadTrackRecords:jsonObjs toServerWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"H5 event tracking upload successfully!");
        }
        
        if (handler) {
            handler(success, error);
        }
    }];
}


@end
