//
//  NSData+NPMD5.h
//  Nirvana
//
//  Created by puhui on 2017/9/21.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NPMD5)

- (NSString *)md5String;

- (NSData *)md5Data;

@end
