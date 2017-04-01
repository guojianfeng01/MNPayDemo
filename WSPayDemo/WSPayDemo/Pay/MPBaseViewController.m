//
//  MPBaseViewController.m
//  Pods
//
//  Created by liu nian on 2017/3/27.
//
//

#import "MPBaseViewController.h"
#import "UINavigationBar+MPNavigationBarTransition.h"
#import <MBProgressHUD/MBProgressHUD.h>

UIImage *kImageWithColor(UIColor *color) {
    if (!color) {
        return nil;
    }
    CGSize size = CGSizeMake(1, 1);
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation MPNavigationBarConfig
@end

static const NSInteger loadingTag = 10101;
@interface MPBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //默认支持左滑返回
    [self setCanSideBack:YES];
    [self devBackBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavigationBarDisplay];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}
- (UIRectEdge)edgesForExtendedLayout{
    return UIRectEdgeAll;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    //just for test
    if (self.navigationBarConfig.backgroundAlpha < 0.5 ||
        (!self.navigationBarConfig.barTintColor && !self.navigationBarConfig.barBackgroundImageColor)) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}

//只显示一个loading
+ (void)showLoadingSingleInView:(UIView *)view animated:(BOOL)animated {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    for (MBProgressHUD *subview in view.subviews) {
        if (subview.tag == loadingTag) {
            return;
        }
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.tag = loadingTag;
    [view addSubview:hud];
    [hud showAnimated:animated];
}

+ (void)showManaLoadingInView:(UIView *)view animated:(BOOL)animated{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    for (MBProgressHUD *subview in view.subviews) {
        if (subview.tag == loadingTag) {
            return;
        }
    }
    
    CGFloat width = CGRectGetWidth(view.bounds)/6;
    UIImageView *animationView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, width, width)];
    animationView.animationDuration = 1;
    animationView.animationRepeatCount = 100;
    animationView.image = [UIImage imageNameBundle:@"loading_1"];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        UIImage *image = [UIImage imageNameBundle:[NSString stringWithFormat:@"loading_%d",i+1]];
        [temp addObject:image];
    }
    animationView.animationImages = temp;
    [animationView startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = loadingTag;
    hud.customView = animationView;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:animated];
}
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view bringSubviewToFront:hud];
    if (text.length > 10) {
        hud.detailsLabel.text = text;
    }else{
        hud.label.text = text;
    }
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNameBundle:icon]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"37x-Checkmark" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [view bringSubviewToFront:hud];
     hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
    
    return hud;
}
#pragma mark  hud
- (void)showLoadingText:(NSString *)text{
    [[self class] showMessag:text toView:self.view];
}
- (void)showLoading{
    [[self class] showManaLoadingInView:self.view animated:YES];
}
- (void)hideLoading{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showError:(NSString *)error{
    [[self class] showError:error toView:self.view];
}

- (void)showSuccess:(NSString *)success{
    [[self class] showSuccess:success toView:self.view];
}


#pragma mark private methods
- (void)devBackBarButton{
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNameBundle:@"nav_return"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNameBundle:@"nav_return"]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backItemClickEvent:)];
    self.navigationItem.backBarButtonItem = backItem;
}
/*** 关闭ios右滑返回*/
- (void)cancelSideBack{
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

/*开启ios右滑返回*/
- (void)startSideBack {
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark  evnet
- (void)backItemClickEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateNavigationBarDisplay {
    MPNavigationBarConfig *config = self.navigationBarConfig;
    
    //if config is nil, reset to default, please change logic below with your own default
    
    [self.navigationController.navigationBar setBarTintColor:config.barTintColor];
    
    [self.navigationController.navigationBar setBackgroundImage:kImageWithColor(config.barBackgroundImageColor) forBarMetrics:UIBarMetricsDefault];
    if (config) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:config.titleColor}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:nil];
    }
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
        item.tintColor = config.itemColor;
    }
    
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.tintColor = config.itemColor;
    }
    //back button tint color
    self.navigationController.navigationBar.tintColor = config.itemColor;
    
    //alpha
    self.navigationController.navigationBar.ml_backgroundView.alpha = config?config.backgroundAlpha:1.0f;
    
    //shadow hidden
    self.navigationController.navigationBar.ml_backgroundShadowView.hidden = config?!config.showShadowImage:NO;
    
    //other default
    //Please set translucent to YES,.
    //If it's YES, the self.view.frame.origin.y would be zero.
    //Or if ml_backgroundView.alpha<1.0f, the views below it would be displayed.
    self.navigationController.navigationBar.translucent = config?config.translucent:YES;
    [self.navigationController.navigationBar layoutIfNeeded];
    //update status bar style
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message alertButtons:(NSArray <UIAlertAction *>*)alertActions preferredStyle:(UIAlertControllerStyle)preferredStyle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    for (id obj in alertActions) {
        if ([obj isKindOfClass:[UIAlertAction class]]) {
            [alert addAction:(UIAlertAction *)obj];
        }
    }
    if ([self showAlertMessageAlignmentLeft]) {
        [self messageLabelOfAlert:alert].textAlignment = NSTextAlignmentLeft;
    }
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)showAlertMessageAlignmentLeft{
    return NO;
}

- (UILabel *)messageLabelOfAlert:(UIAlertController *)alert{
    return [self viewArray:alert.view][1];
}

- (NSArray *)viewArray:(UIView *)root{
    static NSArray *_subviews = nil;
    _subviews = nil;
    for (UIView *v in root.subviews) {
        if (_subviews) {
            break;
        }
        if ([v isKindOfClass:[UILabel class]]) {
            _subviews = root.subviews;
            return _subviews;
        }
        [self viewArray:v];
    }
    return _subviews;
}
#pragma mark  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}

#pragma mark getter
- (MPNavigationBarConfig *)navigationBarConfig{
    if (!_navigationBarConfig) {
        _navigationBarConfig = [[MPNavigationBarConfig alloc] init];
        _navigationBarConfig.titleColor = [UIColor darkTextColor];
        _navigationBarConfig.showShadowImage = YES;
        _navigationBarConfig.backgroundAlpha = 1;
        _navigationBarConfig.translucent = YES;
        _navigationBarConfig.titleColor = [UIColor darkTextColor];
        _navigationBarConfig.barBackgroundImageColor = [UIColor whiteColor];
        _navigationBarConfig.itemColor = kColor_1;
    }
    
    return _navigationBarConfig;
}
#pragma mark  setter
- (void)setCanSideBack:(BOOL)canSideBack{
    _canSideBack = canSideBack;
    if (canSideBack) {
        [self startSideBack];
    }else{
        [self cancelSideBack];
    }
}

@end
