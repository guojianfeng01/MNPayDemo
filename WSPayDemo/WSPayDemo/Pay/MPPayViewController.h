//
//  MPPayViewController.h
//  Pods
//
//  Created by guojianfeng on 17/3/28.
//
//

#import "MPBaseViewController.h"
#import "MPTradeHelper.h"

//可用的支付服务，可多选
typedef NS_OPTIONS(NSInteger, MPPayService) {
    MPPayServiceNone   = 0,
    MPPayServiceYuE    = 1 << 0,
    MPPayServiceWeChat = 1 << 1,
    MPPayServiceAlipay = 1 << 2
};

typedef void(^MPPayVCCompleteBlock)(MPPayType type, MPPrePayInfoModel *payInfoModel);
@interface MPPayViewController : MPBaseViewController
@property (nonatomic, copy) MPPayVCCompleteBlock completionBlock;

- (instancetype)initWithTitle:(NSString *)title
                   payService:(MPPayService)payService
          manaPrePayInfoModel:(MPPrePayInfoModel *)manaPrePayInfoModel;
@end
