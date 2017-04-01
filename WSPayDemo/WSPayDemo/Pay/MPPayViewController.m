//
//  MPPayViewController.m
//  Pods
//
//  Created by guojianfeng on 17/3/28.
//
//

#import "MPPayViewController.h"
#import "MPTopUpPayHeaderView.h"
#import "MPTradeHelper.h"
#import "DCPaymentView.h"

@interface MPPayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *surePayButton;
@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) MPTopUpPayHeaderView *headerView;
@property (nonatomic, strong) MPPayCheckModel *payCheckModel;
@property (nonatomic, strong) MPPrePayInfoModel *prePayInfoModel;
@property (nonatomic, assign) MPPayType selectedPayType;
@property (nonatomic, assign) MPPayService payService;
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@end

@implementation MPPayViewController

- (instancetype)initWithTitle:(NSString *)title
                   payService:(MPPayService)payService
          manaPrePayInfoModel:(MPPrePayInfoModel *)manaPrePayInfoModel{
    if (self = [super init]) {
        if (!isMPNULLString(title)) {
            self.title = title;
        }else{
            self.title = @"支付";
        }
        if (!isMPNULLString(manaPrePayInfoModel.amount)) {
            self.amount = manaPrePayInfoModel.amount;
        }
        self.prePayInfoModel = manaPrePayInfoModel;
        self.payService = payService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.backButtonItem;
    [self request];
}
- (UIRectEdge)edgesForExtendedLayout{
    return UIRectEdgeNone;
}
#pragma mark - private
- (void)surePayButtonClick{
    if (self.selectedPayType == MPPayTypeNone) {
        return ;
    }
    if (self.selectedPayType == MPPayTypeYue) {
        [self yuErPay];
    }else{
        [self doPayWithManaPrePayInfoModel:self.prePayInfoModel
                           platformPayType:self.selectedPayType
                                  password:nil];
    }
}

- (void)yuErPay{
    if (self.payCheckModel.tradePasswordStatus) {
        [self yePayWithPaymentViewTitle:@"请输入支付密码"];
    }else{
        //        [self isGotoPassword];
    }
}

//支付
- (void)doPayWithManaPrePayInfoModel:(MPPrePayInfoModel *)payInfoModel platformPayType:(MPPayType)payType password:(NSString *)password{
    __weak typeof(self) weakSelf = self;
    [[MPTradeHelper sharedInstance] payWithMPPrePayInfoModel:payInfoModel
                                                 payPassword:password
                                             platformPayType:payType
                                             completionBlock:^(MPPayType payType, BOOL success, NSString *message, NSInteger resultCode) {
        if (success) {
            if(_completionBlock){
                _completionBlock(payType, payInfoModel);
            }
        }else{
            switch (payType) {
                case MPPayTypeYue:{
                    if (resultCode == 15) {
                        [weakSelf yePayPasswordError];
                    }
                }
                    break;
                case MPPayTypeWeChat:
                case MPPayTypeAliPay:
                    [weakSelf showError:message];
                    break;
                default:
                    break;
            }
        }
        
    }];
}

- (void)yePayWithPaymentViewTitle:(NSString *)title{
    DCPaymentView *payAlert = [[DCPaymentView alloc] init];
    payAlert.title = title;
    payAlert.detail = @"支付订单";
    payAlert.amount = [self.prePayInfoModel.amount floatValue];
    payAlert.payType = @"余额";
    payAlert.alertHeight = 235;
    [payAlert show];
    __weak typeof(self) ws = self;
    payAlert.completeHandle = ^(NSString *inputPwd){
        [ws doPayWithManaPrePayInfoModel:ws.prePayInfoModel platformPayType:self.selectedPayType password:inputPwd];
    };
}

- (void)yePayPasswordError{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"支付密码错误，请重试"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *forgetAction = [UIAlertAction actionWithTitle:@"忘记密码"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             //                                                             [weakSelf showRegisterWithManaCodeSetType:ManaCodeSetTypeTradePassword
                                                             //                                                                                   codeCompletionBlock:^{
                                                             //
                                                             //                                                                                   }];
                                                             
                                                         }];
    UIAlertAction *inputPasswordAction = [UIAlertAction actionWithTitle:@"重试"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [weakSelf yePayWithPaymentViewTitle:@"请输入支付密码"];
                                                                }];
    [alertController addAction:forgetAction];
    [alertController addAction:inputPasswordAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - request
- (void)request{
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [[MPTradeHelper sharedInstance] payWithCheckInfoCompletionBlock:^(id response, MPResult *result) {
        [weakSelf hideLoading];
        if (result.success && [response isKindOfClass:[MPPayCheckModel class]]) {
            weakSelf.payCheckModel = response;
            [weakSelf updateUIWithCheckModel:response];
        }else{
            [weakSelf showError:result.message];
            [weakSelf performSelector:@selector(backItemClickEvent:) withObject:nil afterDelay:.30];
        }
    }];
}

- (void)updateHeadViewWithMPPayCheckModel:(MPPayCheckModel *)checkModel{
    
    NSString *priceStr = [NSString stringWithFormat:@"¥ %@",self.prePayInfoModel.amount];
    if (self.payService & MPPayServiceYuE) {
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 175);
        NSString *payIntro = nil;
        NSDecimalNumber *cashValueNumber = [[NSDecimalNumber alloc] initWithString:self.payCheckModel.cash];
        NSDecimalNumber *amountNumber = [[NSDecimalNumber alloc] initWithString:self.prePayInfoModel.amount];
        BOOL resultCheckMininumber = [cashValueNumber compare:amountNumber] == NSOrderedDescending || [cashValueNumber compare:amountNumber] == NSOrderedSame;
        if (resultCheckMininumber) {
            payIntro = [NSString stringWithFormat:@"¥ %@",self.payCheckModel.cash];
            self.headerView.userInteractionEnabled = YES;
        }else{
            payIntro = [NSString stringWithFormat:@"¥ %@(余额不足)",isMPNULLString(self.payCheckModel.cash) ? @"0.00":self.payCheckModel.cash];
            self.headerView.userInteractionEnabled = NO;
        }
        
        BOOL isSel = NO;
        if (self.selectedPayType == MPPayTypeYue) {
            isSel = YES;
        }
        [self.headerView updateWithManaPrice:priceStr
                                    yueIntro:payIntro needSelected:isSel];
        __weak typeof(self) weakSelf = self;
        self.headerView.paySelectedBlock = ^(){
            weakSelf.selectedPayType = MPPayTypeYue;
            [weakSelf updateHeadViewWithMPPayCheckModel:checkModel];
        };
        
    }else{
        self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 115);
        [self.headerView updateWithManaPrice:priceStr];
    }
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
    self.surePayButton.enabled = self.selectedPayType == MPPayTypeNone ? NO: YES;
}

- (void)updateUIWithCheckModel:(MPPayCheckModel *)checkModel{
    MPPayService service = MPPayServiceNone;
    
    if (checkModel.yepayStatus && self.payService & MPPayServiceYuE) {
        service = MPPayServiceYuE;
    }
    if (checkModel.wxpayStatus && self.payService & MPPayServiceWeChat) {
        service = service | MPPayServiceWeChat;
    }
    if (checkModel.alipayStatus && self.payService & MPPayServiceAlipay) {
        service = service | MPPayServiceAlipay;
    }
    self.payService = service;
    [self.surePayButton setTitle:[NSString stringWithFormat:@"确认支付 ¥%@",self.prePayInfoModel.amount]
                        forState:UIControlStateNormal];
    [self updateHeadViewWithMPPayCheckModel:checkModel];
}

- (UITableViewCell *)configCell:(MPTopUpPayCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.datasource[indexPath.row];
    UIImage *image = [UIImage imageNameBundle:array[0]];
    NSString *payTitle = array[1];
    NSString *payInfo = array[2];
    BOOL isSel = NO;
    
    if (indexPath.row == 0 && self.selectedPayType == MPPayTypeWeChat) {
        isSel = YES;
    }else if (indexPath.row == 1 && self.selectedPayType == MPPayTypeAliPay){
        isSel = YES;
    }
    [cell updateWithPayIcon:image payTitle:payTitle payInfo:payInfo needSelected:isSel];
    __weak typeof(self) weakSelf = self;
    cell.paySelectedBlock = ^(){
        weakSelf.selectedPayType = MPPayTypeWeChat;
        if (indexPath.row == 1) {
            weakSelf.selectedPayType = MPPayTypeAliPay;
        }
        [weakSelf updateHeadViewWithMPPayCheckModel:weakSelf.payCheckModel];
    };
    
    return cell;
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.payService&MPPayServiceWeChat){
        count++;
    }
    
    if (self.payService&MPPayServiceAlipay){
        count++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPTopUpPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kMPTopUpPayCellID];
    if (!cell) {
        cell = [[MPTopUpPayCell alloc] initWithReuseIdentifier:kMPTopUpPayCellID];
    }
    return  [self configCell:cell indexPath:indexPath];
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.payService & MPPayServiceYuE) {
        return 15;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedPayType = MPPayTypeWeChat;
    if (indexPath.row == 1) {
        self.selectedPayType = MPPayTypeAliPay;
    }
    [self updateHeadViewWithMPPayCheckModel:self.payCheckModel];
}

- (void)backItemClickEvent:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get
- (UIBarButtonItem *)backButtonItem{
    if (!_backButtonItem) {
        _backButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNameBundle:@"nav_return"]
                                                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(backItemClickEvent:)];
    }
    return _backButtonItem;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kMPColor_3;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (MPTopUpPayHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MPTopUpPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];
    }
    return _headerView;
}

- (NSArray *)datasource{
    if (!_datasource) {
        _datasource = @[@[@"recharge_icon_wechat",@"微信支付",@"推荐安装微信5.0以上版本的使用"],@[@"recharge_icon_alipay",@"支付宝支付",@"推荐常用支付宝的使用"]];
    }
    return _datasource;
}

- (UIButton *)surePayButton{
    if (!_surePayButton) {
        _surePayButton = [[UIButton alloc] init];
        [_surePayButton setTitle:@"确认支付 ¥0.00" forState:UIControlStateNormal];
        [_surePayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _surePayButton.layer.masksToBounds = YES;
        _surePayButton.layer.cornerRadius = 3;
        [_surePayButton addTarget:self action:@selector(surePayButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalImage = kImageWithColor(kColor_1);
        UIImage *disableImage = kImageWithColor([UIColor lightGrayColor]);
        
        [_surePayButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_surePayButton setBackgroundImage:disableImage forState:UIControlStateDisabled];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80)];
        self.tableView.tableFooterView = footerView;
        [footerView addSubview:_surePayButton];
        
        [_surePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(12);
            make.bottom.equalTo(footerView.mas_bottom).offset(-15);
            make.right.equalTo(footerView.mas_right).offset(-12);
            make.height.equalTo(@50);
        }];
        
    }
    return _surePayButton;
}
@end
