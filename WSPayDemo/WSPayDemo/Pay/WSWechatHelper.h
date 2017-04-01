//
//  MPWechatHelper.h
//  Pods
//
//  Created by liu nian on 2017/3/28.
//
//

#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>
#import "WXApi.h"
#import "WSTradeHelper.h"

typedef NS_ENUM(NSUInteger, MPShareType) {
    MPShareTypeNone         = 0,
    MPShareTypeWxSession    = 1 << 0, //好友
    MPShareTypeWxTimeline   = 1 << 1, //朋友圈
    MPShareTypeAll          = MPShareTypeWxSession | MPShareTypeWxTimeline
};

typedef enum WSThirdAuthErrorType{
    WSThirdAuthErrorTypeeNone,
    WSThirdAuthErrorTypeUserCancel,//用户取消授权
}MPThirdAuthErrorType;

@interface MPShareInfoModel : JSONModel
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *icon;
@end

typedef void (^ ShareCompleteBlock)(BOOL success, NSString *message, NSInteger responseCode);

@interface WSWechatHelper : NSObject
@property (nonatomic, assign, getter=isWechatInstalled) BOOL wechatInstalled;
/**默认的微信分享静态图片,默认为AppIcon*/
@property (nonatomic, strong) UIImage *defaultShareImage;

/**
 初始化微信事务助手类
 
 @return 微信助手实例对象
 */
+ (instancetype)sharedInstance;

/**
 当完成分享或者支付之后负责回调数据处理的，在AppDelegate的'- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url'中执行

 @param url 收到的回执url
 @return 是否处理
 */
- (BOOL)applicationOpenURL:(NSURL *)url;

/**
 进行微信绑定和登录
 
 @param viewController 发起绑定或者登录的控制器
 @param block 绑定结果的回调
 */
- (void)authWeixinViewController:(UIViewController *)viewController authCompleteBlock:(WSCompleteBlock)block;

/**
 分享内容模型到微信
 
 @param shareInfo 内容模型
 @param shareType 分享类型
 @param block 分享完成后的数据回调
 */
- (void)shareInfoToWechat:(MPShareInfoModel *)shareInfo shareType:(MPShareType)shareType shareCompleteBlock:(ShareCompleteBlock)block;

/**
 调用微信支付
 
 @param weChatPayOrderModel 微信支付模型
 @param completionBlock 回调函数
 */
- (void)weChatPayWithOrderModel:(WSWeChatPayOrderModel *)weChatPayOrderModel
                completionBlock:(WSPayCompletionBlock)completionBlock;
@end

