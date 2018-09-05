//
//  TYLBaseURLMacro.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#ifndef TYLBaseURLMacro_h
#define TYLBaseURLMacro_h

#define dURL_HTTP_KEY @"URL_HTTP_KEY"    // 缓存HTTP_URL的KEY
#define dURL_WEB_KEY @"URL_WEB_KEY"      // 缓存WEB_URL的KEY


#ifdef dUSE_DEBUG_URL
/**
 * 测试时使用的URL
 */

    #define dDEFAULT_URL_TRACK @"https://"
    #define dDEFAULT_URL_HTTP @"https://"

#else
/**
 * 发布时使用的URL
 */

    #define dDEFAULT_URL_TRACK @"https://"
    #define dDEFAULT_URL_HTTP @"https://"

#endif



/**
 * 从缓存中读取URL
 */
#define dCACHE_URL(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

/**
 * 获取HTTP基础接口（如何缓存中存在则从缓存中获取，否则使用默认的接口）
 */
#define dBASE_URL_HTTP  dCACHE_URL(dURL_HTTP_KEY) && ![dCACHE_URL(dURL_HTTP_KEY) isEqualToString:@""] ? dCACHE_URL(dURL_HTTP_KEY) : dDEFAULT_URL_HTTP

/**
 * 获取WEB基础接口（如何缓存中存在则从缓存中获取，否则使用默认的接口）
 */
#define dBASE_URL_WEB  dCACHE_URL(dURL_WEB_KEY) && ![dCACHE_URL(dURL_WEB_KEY) isEqualToString:@""] ? dCACHE_URL(dURL_WEB_KEY) : dDEFAULT_URL_WEB



#endif /* TYLBaseURLMacro_h */
