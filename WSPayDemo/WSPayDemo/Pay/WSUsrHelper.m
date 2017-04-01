//
//  WSUsrHelper.m
//  WSPayDemo
//
//  Created by guojianfeng on 17/4/1.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import "WSUsrHelper.h"

@implementation WSUsrHelper
+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)wechatAppId{
    if (!_wechatAppId) {
        _wechatAppId = [[NSString alloc]init];
        _wechatAppId = @"1ee3121231231";
    }
    return _wechatAppId;
}
@end
