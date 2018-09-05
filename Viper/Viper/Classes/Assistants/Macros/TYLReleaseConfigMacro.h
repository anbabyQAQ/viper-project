//
//  TYLReleaseConfigMacro.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

/*/********************* 重要的项目内配置文件，发布AppStore时一定要注意检查 *****************************
 
 1、检查证书
 2、接口地址改为正式环境：BaseURLMacro.h 类中
 3、版本号信息：TYLVersionMacro_h 类中
 4、摇一摇功能是否关闭
 5、有无写死的测试代码
 
 ***************************************************************************************************///

#ifndef TYLReleaseConfigMacro_h
#define TYLReleaseConfigMacro_h


//使用摇一摇修改IP地址功能能打开宏  《发布时》或不使用时《必须注释本宏》
#define dUSE_SHAKE_WINDOW

//使用测试时的接口地址 《发布时》或不使用时《必须注释本宏》
#define dUSE_DEBUG_URL


#endif /* TYLReleaseConfigMacro_h */
