//
//  CTTopUpPayHeaderView.h
//  dataBank
//
//  Created by 郭建峰 on 16/9/2.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MPBaseView.h"


@interface MPTopUpPayHeaderView : MPBaseView
@property (nonatomic, copy) PaySelectedBlock paySelectedBlock;
- (void)updateWithManaPrice:(NSString *)price;
- (void)updateWithManaPrice:(NSString *)price
                   yueIntro:(NSString *)yueIntro
               needSelected:(BOOL)selected;
@end

static NSString *kMPTopUpPayCellID = @"MPTopUpPayCell";

@interface MPTopUpPayCell : UITableViewCell
@property (nonatomic, copy) PaySelectedBlock paySelectedBlock;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateWithPayIcon:(UIImage *)icon payTitle:(NSString *)title payInfo:(NSString *)payInfo needSelected:(BOOL)selected;
@end
