//
//  WSTestTableViewController.m
//  WSPayDemo
//
//  Created by guojianfeng on 17/3/31.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import "WSTestTableViewController.h"
#import "WSTradeHelper.h"

@interface WSTestTableViewController ()
@property (nonatomic, strong) NSArray *testTitles;
@end

@implementation WSTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private
- (void)wechatPay{
    [[WSTradeHelper sharedInstance] payWithMPPrePayInfoModel:nil platformPayType:WSPayTypeWeChat completionBlock:^(WSPayType payType, BOOL success, NSString *message, NSInteger resultCode) {
        
    }];
}

- (void)alipayPay{
    [[WSTradeHelper sharedInstance] payWithMPPrePayInfoModel:nil platformPayType:WSPayTypeAliPay completionBlock:^(WSPayType payType, BOOL success, NSString *message, NSInteger resultCode) {
        
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"kCellID"];
    }
    cell.textLabel.text = self.testTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        [self wechatPay];
    }else if (1 == indexPath.row){
        [self alipayPay];
    }
}

#pragma mark - get
- (NSArray *)testTitles{
    if (!_testTitles) {
        _testTitles = [[NSArray alloc] init];
        _testTitles = @[@"微信支付",@"支付宝支付"];
    }
    return _testTitles;
}
@end
