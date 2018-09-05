//
//  TYLUserManager.m
//  Nirvana
//
//  Created by tianyulong on 2017/9/17.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLUserManager.h"

@implementation TYLUserManager

+ (BOOL)isLogin {
    return !([TYLTokenManager isExpired] ||
             [TYLTokenManager needRefreshToken]);
}

+ (BOOL)isRealNameAuth {
    if (![self isLogin]) {
        return NO;
    }
    
    return [[TYLUserDefaultsUtil userDefaultsObject:KRealNameAuth] boolValue];
}

+ (NSString *)userName {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KUserName];
}

+ (void)saveUserName:(NSString *)userName {
    NSAssert(userName, @"userName not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:userName forKey:KUserName];
}

+ (NSString *)userNameMask {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KUserNameMask];
}

+ (void)saveUserNameMask:(NSString *)userNameMask {
    NSAssert(userNameMask, @"userNameMask not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:userNameMask forKey:KUserNameMask];
}

+ (NSString *)mobile {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KMobile];
}

+ (void)saveMobile:(NSString *)mobile {
    NSAssert(mobile, @"mobile not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:mobile forKey:KMobile];
}

+ (NSString *)mobileMask {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KMobileMask];
}

+ (void)saveMobileMask:(NSString *)mobilemask {
    NSAssert(mobilemask, @"mobilemask not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:mobilemask forKey:KMobileMask];
}

+ (NSString *)mail {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KMail];
}

+ (void)saveMail:(NSString *)mail {
    NSAssert(mail, @"mail not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:mail forKey:KMail];
}

+ (NSString *)idNo {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KIdNo];
}

+ (void)saveIdNo:(NSString *)idNO {
    NSAssert(idNO, @"mail not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:idNO forKey:KIdNo];
}

+ (NSString *)idNoMask {
    if (![self isLogin]) {
        return nil;
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KIdNoMask];
}

+ (void)saveIdNoMask:(NSString *)idNoMask {
    NSAssert(idNoMask, @"idNoMask not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:idNoMask forKey:KIdNoMask];
}

+ (NSNumber *)createTime {
    return [TYLUserDefaultsUtil userDefaultsObject:KCreateTime];
}

+ (void)saveCreateDate:(NSNumber *)createTime {
    NSAssert(createTime != nil, @"createTime not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:createTime forKey:KCreateTime];
}

+ (void)saveCoreCustomerId:(NSString *)coreCustomerId {
    [TYLUserDefaultsUtil setUserDefaultsObject:coreCustomerId forKey:KCoreCustomerId];
}

+ (NSString *)coreCustomerId {
    return [TYLUserDefaultsUtil userDefaultsObject:KCoreCustomerId];
}

+ (BOOL)validateCoreCustomerId {
    NSString *coreCustomerId = [self coreCustomerId];
    if ([self coreCustomerId] && ![coreCustomerId isEqualToString:@"0"]) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)isId5 {
    return [TYLUserDefaultsUtil userDefaultsObject:KRealNameAuth];
}

+ (void)saveIsId5:(NSString *)isId5 {
    NSAssert(isId5, @"isId5 not null");
    
    [TYLUserDefaultsUtil setUserDefaultsObject:isId5 forKey:KRealNameAuth];
}

#pragma mark -
#pragma mark Private

+ (void)fetchUserInfomationSucceed:(UserInfoCallBack)callback {
    NSString *token = [TYLTokenManager token];
    NSString *pid = [UIDevice PID];
    NSDictionary *params = @{@"token":token,@"pid" : pid};
    @weakify(self);
    [[TYLNetworkManager shareInstance] postWithModule:@"user"
                                           interface:@"getUserInfo"
                                              params:params complete:^(id JSONResponse, NSError *error) {
        @strongify(self);
        if (!error && JSONResponse) {
            NSInteger status = [np_objectForKPath(JSONResponse, KResponseStatusKey) integerValue];
            
            if (status == ResponseStatus_ok) {
                NSDictionary *user = np_objectForKPath(JSONResponse, @"data->user" );
                
                if ([NSDictionary isNotEmpty:user]) {
                    [self saveUserInfo:user];
                    callback(user,nil,nil);
                }
            }
            else {
                NSError *error = [NSError errorWithDomain:@"error.fetchUserInfo"
                                                     code:ResponseStatus_error
                                                 userInfo:JSONResponse];
                
                NSString *berrormsg = [JSONResponse objectForKey:KResponseBerrorMsgKey];
                callback(nil, error, berrormsg);
            }
        } else {
            NSString *berrormsg = [JSONResponse objectForKey:KResponseBerrorMsgKey];
            callback(nil, error, berrormsg);
        }
    }];
}

+ (void)saveUserInfo:(NSDictionary *)data {
    NSAssert(data, @"data not null");
    /*
        1.解密
        2.调用存储管理（存数据库 || 存文件）
     */
    
    NSString *isId5 = [data objectForKey:@"isId5"];
    
    if (isId5 && [isId5 isEqualToString:@"1"]) {
        //实名状态
        NSString *username = [data objectForKey:@"realName"];
        NSString *usernameMask = [data objectForKey:@"realNameMask"];
        NSString *idNo = [data objectForKey:@"idNo"];
        NSString *email = [data objectForKey:@"email"];
        NSString *idNoMask = [data objectForKey:@"idNoMask"];
        
        if ([NSString isNotEmpty:username]) {
            [self saveUserName:username];
        }
        
        if ([NSString isNotEmpty:usernameMask]) {
            [self saveUserNameMask:usernameMask];
        }
        
        if ([NSString isNotEmpty:email]) {
            [self saveMail:email];
        }
        
        if ([NSString isNotEmpty:idNo]) {
            [self saveIdNo:idNo];
        }
        
        if ([NSString isNotEmpty:idNoMask]) {
            [self saveIdNoMask:idNoMask];
        }
    }
    
    [self saveIsId5:isId5];

    NSString *mobile = [data objectForKey:@"mobile"];
    NSString *mobileMask = [data objectForKey:@"mobileMask"];
    NSNumber *createTime = [data objectForKey:@"createTime"];
    NSString *coreCustomerId = [data objectForKey:@"coreCustomerId"];
    
    if ([NSString isNotEmpty:coreCustomerId]) {
        [self saveCoreCustomerId:coreCustomerId];
    }
    
    if ([NSString isNotEmpty:mobile]) {
        [self saveMobile:mobile];
    }
    
    if ([NSString isNotEmpty:mobileMask]) {
        [self saveMobileMask:mobileMask];
    }
    
    if (createTime != nil) {
        [self saveCreateDate:createTime];
    }
}

+ (void)clear {
    [TYLUserDefaultsUtil removeUserDefaultsKeys:@[KUserName,
                                                 KUserNameMask,
                                                 KMobile,
                                                 KMobileMask,
                                                 KRealNameAuth,
                                                 KMail,
                                                 KIdNo,
                                                 KMobileMask,
                                                 KCreateTime,
                                                 KCoreCustomerId]];
}

@end
