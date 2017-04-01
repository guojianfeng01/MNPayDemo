//
//  WSTradeHelper.h
//  WSPayDemo
//
//  Created by guojianfeng on 17/4/1.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
//此模型是自己服务器公司支付所需模型
@interface WSPrePayInfoModel : JSONModel
#pragma mark - 支付参数
//支付类型，recharge：充值，pay：支付，exchange：数据交易 默认值: recharge 允许值: recharge, pay, exchange
@property (nonatomic, assign) NSString *type;
//订单名
@property (nonatomic, strong) NSString *name;@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *dimension;
//用户类型，0：用户，1：商户 默认值: 0 允许值: 0, 1
@property (nonatomic, strong) NSString *isMerchant;
//备注，原样写入流水记录
@property (nonatomic, strong) NSString *remark;
//支付目标对象
@property (nonatomic, strong) NSString *target;
//订单号
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *amount;//支付金额，单位元
@property (nonatomic, strong) NSString *mobile;
@end

//微信支付
@interface WSWeChatPayOrderModel : JSONModel
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *sign;
@end
//支付宝
@interface WSAliPayOrderModel : JSONModel
@property (nonatomic, strong) NSString *orderInfo;
@end

typedef NS_ENUM (NSInteger, WSPayType){
    WSPayTypeNone            = 0,
    WSPayTypeYue             = 1,
    WSPayTypeWeChat          = 2,
    WSPayTypeAliPay          = 3
};

typedef void(^WSPayCompletionBlock)(WSPayType payType, BOOL success, NSString *message, NSInteger resultCode);
typedef void (^WSCompleteBlock)(id response, id result);

@interface WSTradeHelper : NSObject
/**
 生成单例
 
 @return 单例对象
 */
+ (instancetype)sharedInstance;

/**
 当完成支付之后负责回调数据处理的，在AppDelegate的'- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url'中执行
 
 @param url 收到的回执url
 @return 是否处理
 */
- (BOOL)applicationOpenURL:(NSURL *)url;

/**
 支付和充值业务
 
 @param prePayInfoModel 支付前预数据模型
 @param payType 支付平台类型
 @param completionBlock 支付完成的结果回调
 */
- (void)payWithMPPrePayInfoModel:(WSPrePayInfoModel *)prePayInfoModel
                 platformPayType:(WSPayType)payType
                 completionBlock:(WSPayCompletionBlock)completionBlock;
@end
