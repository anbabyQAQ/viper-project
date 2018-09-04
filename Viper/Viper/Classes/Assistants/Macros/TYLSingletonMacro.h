//
//  TYLSingletonMacro.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#ifndef TYLSingletonMacro_h
#define TYLSingletonMacro_h


#if __has_feature(objc_arc)

#define dSINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)sharedInstance;

#define dSINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
return shared##classname; \
}

#else

#define dSINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)sharedInstance;

#define dSINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
return shared##classname; \
} \

#endif


#endif /* TYLSingletonMacro_h */
