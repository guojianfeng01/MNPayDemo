//
//  MPWechatHelper.m
//  Pods
//
//  Created by liu nian on 2017/3/28.
//
//

#import "WSWechatHelper.h"
#import "WSUsrHelper.h"

static NSString *kStateLogin = @"manaLogin";

@interface WSWechatHelper ()<WXApiDelegate>
@property (nonatomic, copy) WSCompleteBlock authBlock;
@property (nonatomic, copy) ShareCompleteBlock shareBlock;
@property (nonatomic, copy) WSPayCompletionBlock wxPayBlock;
@end
@implementation WSWechatHelper
+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        NSString *wechatAppId = [WSUsrHelper sharedInstance].wechatAppId;
        //微信注册
        NSAssert(wechatAppId != nil, @"wechatAppId must not be nil!");
        [WXApi registerApp:wechatAppId];
    }
    return self;
}

#pragma mark  public
- (BOOL)applicationOpenURL:(NSURL *)url{
    NSString *wechatAppId = [WSUsrHelper sharedInstance].wechatAppId;
    NSAssert(wechatAppId != nil, @"wechatAppId must not be nil!");
    if ([[url scheme] isEqualToString:wechatAppId]) {
        [WXApi handleOpenURL:url delegate:self];
        return YES;
    }
    return NO;
}
- (void)authWeixinViewController:(UIViewController *)viewController authCompleteBlock:(WSCompleteBlock)block{
    NSString *wechatAppId = [WSUsrHelper sharedInstance].wechatAppId;
    NSAssert(wechatAppId != nil, @"wechatAppId must not be nil!");
    if (![WXApi isWXAppInstalled] && block) {
        block(nil, @{@"respCode":@(1),@"respMsg":@"请检查您是否安装微信"});
        return;
    }
    self.authBlock = block;
    SendAuthReq * req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = kStateLogin;
    req.openID = wechatAppId;
    
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
}

- (void)shareInfoToWechat:(MPShareInfoModel *)shareInfo shareType:(MPShareType)shareType shareCompleteBlock:(ShareCompleteBlock)block{
    if (![WXApi isWXAppInstalled] && block) {
        block(NO, @"请检查您是否安装微信", 1);
        return;
    }
    self.shareBlock = block;
    switch (shareType) {
        case MPShareTypeWxSession:
            [self sendShareInfoModel:shareInfo wxScene:WXSceneSession];
            break;
        case MPShareTypeWxTimeline:
            [self sendShareInfoModel:shareInfo wxScene:WXSceneTimeline];
            break;
        default:
            break;
    }
}
- (void)weChatPayWithOrderModel:(WSWeChatPayOrderModel *)weChatPayOrderModel
                completionBlock:(WSPayCompletionBlock)completionBlock{
    
    if (![WXApi isWXAppInstalled] && completionBlock) {
        completionBlock(WSPayTypeWeChat, NO, @"请检查您是否有该支付工具", 0);
        return;
    }
    
    if (!weChatPayOrderModel){
        if (completionBlock) {
            completionBlock(WSPayTypeWeChat, NO, @"商品支付信息不完善", 0);
        }
        return;
    }
    self.wxPayBlock = completionBlock;
    PayReq *payReq             = [[PayReq alloc] init];
    payReq.partnerId           = weChatPayOrderModel.partnerid;
    payReq.prepayId            = weChatPayOrderModel.prepayid;
    payReq.nonceStr            = weChatPayOrderModel.noncestr;
    payReq.timeStamp           = [weChatPayOrderModel.timestamp intValue];
    payReq.package             = weChatPayOrderModel.package;
    payReq.sign                = weChatPayOrderModel.sign;
    [WXApi sendReq:payReq];
}

#pragma mark  private
- (void)sendShareInfoModel:(MPShareInfoModel *)shareInfoModel wxScene:(NSInteger)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareInfoModel.title;
    message.description = shareInfoModel.desc;
    
    if (shareInfoModel.image) {
        [message setThumbImage:shareInfoModel.image];
    }else{
        [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareInfoModel.link;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = (int)scene;
    
    [WXApi sendReq:req];
}
//绑定微信
- (void)fetchWexinTokenWithRespCode:(NSString *)wxCode authCompleteBlock:(WSCompleteBlock)completeBlock{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"code"] = wxCode;
    NSLog(@"%@",params);
}

#pragma mark  WXApiDelegate
- (void)onReq:(BaseReq*)req{
}

- (void)onResp:(BaseResp*)resp{
    NSInteger errCode = resp.errCode;
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess) {
            SendAuthResp *aResp = (SendAuthResp *)resp;
            NSString *weixinCode = aResp.code;
            if ([aResp.state isEqualToString:kStateLogin]) {
                [self fetchWexinTokenWithRespCode:weixinCode authCompleteBlock:self.authBlock];
            }
        }else{
            if (_authBlock) {
                _authBlock(nil,@{@"respCode":@(errCode),@"respMsg":@"分享失败，请稍后再试"});
            }
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        PayResp *aResp = (PayResp *)resp;
        NSString *returnKey = aResp.returnKey;
        if (errCode == 0) {
            if (_wxPayBlock) {
                _wxPayBlock(WSPayTypeWeChat, YES, @"支付成功", errCode);
            }
        }else{
            NSString *message = @"支付失败";
            if (errCode == WXErrCodeUserCancel) {
                message = @"用户取消支付";
            }else{
                if(returnKey && returnKey.length && ![returnKey isKindOfClass:[NSNull class]]){
                    message = returnKey;
                }
            }
            
            if (_wxPayBlock) {
                _wxPayBlock(WSPayTypeWeChat, NO, message, errCode);
            }
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        SendMessageToWXResp *aResp = (SendMessageToWXResp *)resp;
        BOOL success = YES;
        if (aResp.errCode != 0) {
            success = NO;
        }
        self.shareBlock(success,@"分享成功",aResp.errCode);
    }
}

#pragma mark  getter
- (BOOL)isWechatInstalled{
    BOOL installed = [WXApi isWXAppInstalled];
    return installed;
}
@end

@implementation MPShareInfoModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"title"] ||
        [propertyName isEqualToString:@"link"]) {
        return NO;
    }
    return YES;
}
@end
