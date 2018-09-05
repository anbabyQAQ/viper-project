//
//  NPMapTranslator.m
//  Nirvana
//
//  Created by tianyulong on 2018/1/15.
//  Copyright © 2018年 finupgroup. All rights reserved.
//

#import "TYLMapTranslator.h"

#define kNPBiContent    @"biContent"
#define kNPBiEvent      @"biEvent"

static NSString *const kNPTrackingFilePrefix  = @"TrackingMapConfig";
static NSString *const kNPTrackingFilePostfix = @"plist";

@interface TYLMapTranslator()

@property (nonatomic) NSArray *uniqueKeys;

@property (nonatomic) NSDictionary *allTrackingMap;

@end

@implementation TYLMapTranslator
dSINGLETON_FOR_CLASS(TYLMapTranslator)

- (instancetype)init {
    self = [super init];
    if (self) {
        //读取map配置文件
        /*
         1.首先从document中读取配置文件
         2.document不存在，则从app中读取;
         3.同时，根据版本号，下载最新的配置那文件，存储到document中
         */
        
        [self parseMapConfig];
    }
    
    return self;
}

- (NSString *)documentTrackingMapConfigFilePath {
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",kNPTrackingFilePrefix,kNPTrackingFilePostfix];
    return [dPathDocument stringByAppendingPathComponent:fileName];
}

- (void)parseMapConfig {
    NSString *plistPath = [self documentTrackingMapConfigFilePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:plistPath]) {
        NSString *docPlistPath = [[NSBundle mainBundle] pathForResource:kNPTrackingFilePrefix
                                                                 ofType:kNPTrackingFilePostfix];
        NSError *error = NULL;
        BOOL flag =  [fm copyItemAtPath:docPlistPath toPath:plistPath error:&error];
        if (!flag && error) {
            plistPath = docPlistPath;
        }
    }
    
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if (dataDic) {
        self.uniqueKeys = [dataDic allKeys];
        self.allTrackingMap = [dataDic copy];
    }
    else {
        self.allTrackingMap = nil;
    }
    
    NSLog(@"%@",dataDic);//直接打印数据
}

- (NSString *)biContentWithUniqueKey:(NSString *)uniqueKey {
    if (!uniqueKey || uniqueKey.length == 0) {
        NSLog(@"uniqueKey 不存在!");
        return @"";
    }
    
    if (self.allTrackingMap) {
        NSDictionary *dict = [self.allTrackingMap objectForKey:uniqueKey];
        if (dict) {
            return [dict objectForKey:kNPBiContent];
        }
    }
    
    return @"";
}

- (NSString *)biEventWithUniqueKey:(NSString *)uniqueKey; {
    if (!uniqueKey || uniqueKey.length == 0) {
        NSLog(@"uniqueKey 不存在!");
        return @"";
    }
    
    if (self.allTrackingMap) {
        NSDictionary *dict = [self.allTrackingMap objectForKey:uniqueKey];
        if (dict) {
            return [dict objectForKey:kNPBiEvent];
        }
    }
    
    return @"";
}

#pragma mark -
#pragma mark Map文件管理
- (void)fetchTrackingMapFile {
    NSString *configVersion = [TYLUserDefaultsUtil userDefaultsObject:@"kTrackingVersionKey"];
    if (!configVersion) {
        configVersion = dTRACKINGINITIALVERSION;
    }
    NSString *app = dTRACKINGCHANNEL;
    
    NSString *type = @"point";
    NSDictionary *params = NSDictionaryOfVariableBindings(configVersion,app,type);
    
    @weakify(self);
    NSString *urlStr = [NSString stringWithFormat:@"%@/statistic/point/config",dDEFAULT_URL_TRACK];
    NSURL *url = [NSURL URLWithString:urlStr];
    TYLTrackingNetWork *network = [[TYLTrackingNetWork alloc] initWithServerURL:url];
    [network postWithParams:params complete:^(id JSONResponse, NSError *error) {
        @strongify(self);
        BOOL flag = np_dictionaryContainsKey(JSONResponse, @"data");
        if (!error && flag) {
            NSDictionary *data = np_objectForKPath(JSONResponse, @"data");
            
            id updateObj = np_objectForKPath(data, @"update");
            
            if (updateObj && [updateObj boolValue]) {
                NSString *newVersion = np_objectForKPath(data, @"version");
                [self updateTrackingVersion:newVersion];
                
                NSString *value = np_objectForKPath(data, @"value");
                if (value) {
                    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                    BOOL success = [self updateTrackingMapFileWithData:data];
                    
                    if (success) {
                        //更新内存中的map
                        [self parseMapConfig];
                    }
                }
            }
        }
    }];
}

- (BOOL)updateTrackingMapFileWithData:(NSData *)data {
    if (!data) { return NO; }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [self documentTrackingMapConfigFilePath];
    
    if ([fm fileExistsAtPath:plistPath]) {
        [fm removeItemAtPath:plistPath error:nil];
    }
    
    return [fm createFileAtPath:plistPath contents:data attributes:nil];
}

#pragma mark - tracking version&&Channel
- (void)updateTrackingVersion:(NSString *)version {
    if (!version) return;

    NSString *oldVersion = [TYLUserDefaultsUtil userDefaultsObject:@"kTrackingVersionKey"];
    if (!oldVersion || oldVersion.integerValue <= version.integerValue) {
        [TYLUserDefaultsUtil setUserDefaultsObject:version forKey:@"kTrackingVersionKey"];
        
    }
}

- (void)updateTrackingChannel:(NSString *)channel {
    if (!channel) return;
    [TYLUserDefaultsUtil setUserDefaultsObject:channel forKey:@"kTrackingChannelKey"];
}

@end
