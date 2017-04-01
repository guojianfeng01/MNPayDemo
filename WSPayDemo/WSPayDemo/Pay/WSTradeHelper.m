//
//  WSTradeHelper.m
//  WSPayDemo
//
//  Created by guojianfeng on 17/4/1.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import "WSTradeHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WechatSDK/WechatAuthSDK.h"
#import "WSUsrHelper.h"
#import "WSWechatHelper.h"

@implementation WSWeChatPayOrderModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"appid"]) {
        return NO;
    }
    return YES;
}
@end

@implementation WSAliPayOrderModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"payStr"]) {
        return NO;
    }
    return YES;
}
@end

@interface WSTradeHelper ()
@property (nonatomic, copy) WSPayCompletionBlock wxPayBlock;
@property (nonatomic, copy) WSPayCompletionBlock alipayPayBlock;
@property (nonatomic, strong) WSWeChatPayOrderModel *MPWeChatPayOrderModel;
@end

@implementation WSTradeHelper
+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - private

- (void)aliPayWithOrderModel:(WSAliPayOrderModel *)aliPayOrderModel
             completionBlock:(WSPayCompletionBlock)completionBlock{
    NSString *appPubURLScheme = [WSUsrHelper sharedInstance].appPubURLScheme;
    NSAssert(appPubURLScheme != nil, @"manaPubURLScheme must not be nil!");
    self.alipayPayBlock = completionBlock;
    [[AlipaySDK defaultService] payOrder:aliPayOrderModel.orderInfo fromScheme:appPubURLScheme callback:^(NSDictionary *resultDic) {
        NSInteger code = [resultDic[@"resultStatus"] integerValue];
        BOOL success = NO;
        NSString *message = @"订单支付成功";
        switch (code) {
            case 6002:
                message = @"网络连接出错";
                break;
            case 6001:
                message = @"用户中途取消";
                break;
            case 4000:
                message = @"订单支付失败";
                break;
            case 8000:
                message = @"正在处理中";
                break;
            case 9000:{
                success = YES;
                message = @"订单支付成功";
            }
                break;
            default:
                break;
        }
        if (completionBlock) {
            completionBlock(WSPayTypeAliPay, success, message, code);
        }
    }];
}

- (void)aliPayPayCallback:(NSDictionary *)dic{
    
    NSInteger code = [dic[@"resultStatus"] integerValue];
    BOOL success = NO;
    NSString *message = @"订单支付成功";
    switch (code) {
        case 6002:
            message = @"网络连接出错";
            break;
        case 6001:
            message = @"用户中途取消";
            break;
        case 4000:
            message = @"订单支付失败";
            break;
        case 8000:
            message = @"正在处理中";
            break;
        case 9000:{
            success = YES;
            message = @"订单支付成功";
        }
            break;
        default:
            break;
    }
    self.alipayPayBlock(WSPayTypeAliPay, success, message, code);
}

#pragma mark - public
- (BOOL)applicationOpenURL:(NSURL *)url{
    NSString *manaPubURLScheme = [WSUsrHelper sharedInstance].appPubURLScheme;
    NSAssert(manaPubURLScheme != nil, @"manaPubURLScheme must not be nil!");
    if ([[url scheme] isEqualToString:manaPubURLScheme] && [url.host isEqualToString:@"safepay"]) {
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf aliPayPayCallback:resultDic];
        }];
        return YES;
    }
    return NO;
}

- (void)payWithMPPrePayInfoModel:(WSPrePayInfoModel *)prePayInfoModel
                     payPassword:(NSString *)payPassword
                 platformPayType:(WSPayType)payType
                 completionBlock:(WSPayCompletionBlock)completionBlock{
    switch (payType) {
        case WSPayTypeYue:{
        }
            break;
        case WSPayTypeWeChat:{//自己服务器生成支付model
            WSWeChatPayOrderModel *infoModel = nil;
            [[WSWechatHelper sharedInstance] weChatPayWithOrderModel:infoModel
                                                     completionBlock:completionBlock];
        }
            break;
        case WSPayTypeAliPay:{
            WSAliPayOrderModel *infoModel = nil;
            [self aliPayWithOrderModel:infoModel completionBlock:completionBlock];
            
        }
            break;
        default:
            break;
    }
}

@end
