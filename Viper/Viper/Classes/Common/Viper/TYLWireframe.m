//
//  TYLWrieframe.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLWireframe.h"

@implementation TYLWireframe

- (void)pushNativeByHost:(NSString *)host {
    [self pushNativeByHost:host query:nil];
}

- (void)pushNativeByHost:(NSString *)host query:(NSDictionary *)query {
    TYLURL *url = [TYLURL new];
    url.scheme = dSN_SCHEME;
    url.host = host;
    url.query = query;
    [self pushByURLString:url.urlString];
}

- (void)pushByURLString:(NSString *)urlString {
    [TYLURLHandler loadURL:[[TYLURL alloc] initWithString:urlString]];
}

- (void)dealloc {
    NSLog(@"%@ released.", [self class]);
}

@end
