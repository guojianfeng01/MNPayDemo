//
//  WSUsrHelper.h
//  WSPayDemo
//
//  Created by guojianfeng on 17/4/1.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSUsrHelper : NSObject
@property (nonatomic, strong) NSString *apiHost;
@property (nonatomic, strong) NSString *webHost;
@property (nonatomic, strong) NSString *wechatAppId;
@property (nonatomic, strong) NSString *appPubURLScheme;
+ (instancetype)sharedInstance;
@end
