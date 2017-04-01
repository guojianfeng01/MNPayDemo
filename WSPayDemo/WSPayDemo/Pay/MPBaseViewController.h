//
//  MPBaseViewController.h
//  Pods
//
//  Created by liu nian on 2017/3/27.
//
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIImage+Extension.h"
#import "MPUsrHelper.h"

// 颜色
/**
 *  RGBAcolor
 */
#define kColorA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
/**
 *  RGBcolor
 */
#define kColor(R,G,B) kColorA(R,G,B,1.0)

#define kColor_1 kColor(20,148,255)

UIImage *kImageWithColor(UIColor *color);

@interface MPNavigationBarConfig : NSObject
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *barBackgroundImageColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *itemColor;
@property (nonatomic, assign) BOOL showShadowImage;
@property (nonatomic, assign) CGFloat backgroundAlpha;
@property (nonatomic, assign) BOOL translucent;
@end

@interface MPBaseViewController : UIViewController{
    MPNavigationBarConfig *_navigationBarConfig;
}
@property (nonatomic, strong) MPNavigationBarConfig *navigationBarConfig;
/** 是否开启右滑返回,默认为YES,开启*/
@property (nonatomic, assign, getter=isCanSideBack) BOOL canSideBack;

- (void)updateNavigationBarDisplay;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message alertButtons:(NSArray <UIAlertAction *>*)alertActions preferredStyle:(UIAlertControllerStyle)preferredStyle;
#pragma mark - HUD
- (void)showLoadingText:(NSString *)text;
- (void)showLoading;
- (void)hideLoading;
- (void)showError:(NSString *)error;
- (void)showSuccess:(NSString *)success;
@end
