//
//  WSTestTableViewController.m
//  WSPayDemo
//
//  Created by guojianfeng on 17/3/31.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import "WSTestTableViewController.h"

@interface WSTestTableViewController ()

@end

@implementation WSTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"kCellID"];
    }
    cell.textLabel.text = @"test";
    return cell;
}

@end
