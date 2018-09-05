//
//  NPTokenManager.m
//  Nirvana
//
//  Created by puhui on 2017/9/12.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import "TYLTokenManager.h"

@implementation TYLTokenManager

/**
 当前使用的token是否已经超过过期token的过期时间KExpiredTokenExpiredTime，如果过期，需要用户重新登录

 @return YES:过期, NO:未过期
 */
+ (BOOL)isExpired {
    NSNumber *expiredTokenExpiredTime = [self expiredTokenExpiredTime];
    
    if (expiredTokenExpiredTime == nil) {
        return YES;
    }
    
    //获取系统存储的过期token的过期时间(毫秒)
    NSTimeInterval expiredTimeStamp = [expiredTokenExpiredTime doubleValue];
    NSTimeInterval curTimeStamp = floor([[NSDate date] timeIntervalSince1970] * 1000);
    
    if (curTimeStamp > expiredTimeStamp) {
        return YES;
    }
    
    return NO;
}

/**
 是否需要到服务器获取一个新的token,只有当前时间介于“token过期时间”和“过期token的过期时间”之间时，才需要进行token的更新

 @return YES:需要更新， NO: 不需要更新
 */
+ (BOOL)needRefreshToken {
    NSString *token = [TYLUserDefaultsUtil userDefaultsObject:KPublicToken];
    NSString *expiredToken = [self expiredToken];
    
    if (!token || !expiredToken) {
        //如果未登录，不需要刷新token
        return NO;
    }
    
    NSNumber *expiredTime = [self expiredTime];
    NSNumber *expiredTokenExpiredTime = [self expiredTokenExpiredTime];
    
    NSAssert(expiredTime != nil, @"expiredTime not null");
    NSAssert(expiredTokenExpiredTime != nil, @"expiredTokenExpiredTime not null");
    
    NSTimeInterval expiredTimeStamp = [expiredTime doubleValue];
    NSTimeInterval expiredTokenExpiredTimeStamp = [expiredTokenExpiredTime doubleValue];

    NSTimeInterval interval = floor([[NSDate date] timeIntervalSince1970] * 1000);
    
    if ((interval > expiredTimeStamp) && (interval < expiredTokenExpiredTimeStamp)) {
        return YES;
    }
    
    //eqeals with expiredTimeStamp
    if ([TYLBusinessUtil doubleEqealWithValueA:interval valueB:expiredTimeStamp]) {
        return YES;
    }
    
    return NO;
}

+ (void)save:(NSDictionary *)tokenInfo {
    NSAssert(tokenInfo, @"tokeninfo not nil.");
    NSString *token = [tokenInfo objectForKey:KPublicToken];
    NSTimeInterval tokenExpiredTime = [[tokenInfo objectForKey:KTokenExpiredTime] doubleValue];
    NSString *expiredToken = [tokenInfo objectForKey:KExpiredToken];
    NSTimeInterval expiredTokenExpiredTime = [[tokenInfo objectForKey:KExpiredTokenExpiredTime] doubleValue];
    
    NSAssert(token, @"token not nil.");
    NSAssert(expiredToken, @"expiredToken not nil.");
    NSAssert(tokenExpiredTime > 0, @"");
    NSAssert(expiredTokenExpiredTime > 0, @"");
    
    [self clear];
    
    [TYLUserDefaultsUtil setUserDefaults:@{KPublicToken : token,
                                          KTokenExpiredTime : @(tokenExpiredTime),
                                          KExpiredToken : expiredToken,
                                          KExpiredTokenExpiredTime : @(expiredTokenExpiredTime)}];
}

+ (void)saveMd5Uid:(NSString *)md5Uid {
    NSAssert(md5Uid, @"md5Uid not null");
    [TYLUserDefaultsUtil setUserDefaultsObject:md5Uid forKey:KMd5Uid];
}

+ (void)clear {
    [TYLUserDefaultsUtil removeUserDefaults:KPublicToken];
    [TYLUserDefaultsUtil removeUserDefaults:KExpiredToken];
    [TYLUserDefaultsUtil removeUserDefaults:KExpiredTokenExpiredTime];
    [TYLUserDefaultsUtil removeUserDefaults:KTokenExpiredTime];
}

+ (NSString *)token {
    NSString *publicToken = [TYLUserDefaultsUtil userDefaultsObject:KPublicToken];
    if (!publicToken) {
        //对于不需要token的网络请求，提交给server的request中的token为空字符串
        return @"";
    }
    
    return [TYLUserDefaultsUtil userDefaultsObject:KPublicToken];
}

+ (NSString *)md5Uid {
    NSString *md5Uid = [TYLUserDefaultsUtil userDefaultsObject:KMd5Uid];
    
    if (!md5Uid) {
        return @"";
    }
    
    return md5Uid;
}

+ (NSString *)expiredToken {
    return [TYLUserDefaultsUtil userDefaultsObject:KExpiredToken];
}

+ (NSNumber *)expiredTime {
    return [TYLUserDefaultsUtil userDefaultsObject:KTokenExpiredTime];
}

+ (NSNumber *)expiredTokenExpiredTime {
    return [TYLUserDefaultsUtil userDefaultsObject:KExpiredTokenExpiredTime];
}

+ (void)needVerifytoken:(BOOL)flag handleBusiness:(NPValidTokenCallBack)callback {
    NSString *token = [self token];
    
    if (!flag) {
        callback(token, eNPTokenStateNoValidate);
    }
    else {
        if ([self needRefreshToken]) {
            [self refreshTokenSucceed:callback];
        }
        else if ([self isExpired]) {
            callback(token, eNPTokenStateExpired);
        }
        else {
            callback(token, eNPTokenStateValidate);
        }
    }
}

+ (void)refreshTokenSucceed:(NPValidTokenCallBack)callBack {
    NSString *urlStr = [TYLBusinessUtil generateUrlStrWithModule:@"user"
                                                      interface:@"exchangeToken"];
    NSString *token = [TYLTokenManager expiredToken];
    NSString *idfa = [UIDevice IDFA] ? [UIDevice IDFA] : @"";
    NSDictionary *params = @{@"token" : token ? token : @"",
                             @"deviceId" : idfa};
    TYLNetworkManager *manager = [TYLNetworkManager shareInstance];

    [manager postWithUrlStr:urlStr params:params complete:^(id JSONResponse, NSError *error) {
        /*
            1.成功获取toknen
            2.没有获取token，
         */
        if (JSONResponse[KResponseStatusKey] && [JSONResponse[KResponseStatusKey] longLongValue] == ResponseStatus_ok) {
            NSDictionary *tokenInfo = JSONResponse[@"data"][@"token"];
            if (tokenInfo) {
                NSDictionary *newTokenInfo = @{KPublicToken : tokenInfo[@"token"],
                                               KExpiredToken : tokenInfo[@"expiredToken"],
                                               KTokenExpiredTime : tokenInfo[@"tokenExpiredTime"],
                                               KExpiredTokenExpiredTime : tokenInfo[@"expiredTokenExpiredTime"]};
                [TYLTokenManager save:newTokenInfo];
                
                NSString *md5Uid = np_objectForKPath(tokenInfo, @"md5Uid");
                
                if ([NSString isNotEmpty:md5Uid]) {
                    [TYLTokenManager saveMd5Uid:md5Uid];
                }
            }
            
            NSString *token =  tokenInfo[@"token"] ? tokenInfo[@"token"] : @"";
            callBack(token, eNPTokenStateValidate);
        }
    }];
}

@end
