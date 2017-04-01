//
//  CTTopUpPayHeaderView.m
//  dataBank
//
//  Created by 郭建峰 on 16/9/2.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MPTopUpPayHeaderView.h"
#import "Masonry.h"

@interface MPTopUpPayHeaderView ()
@property (nonatomic, strong) UIImageView *manaIconView;
@property (nonatomic, strong) UILabel *manaValueLabel;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UIButton *selectSignBtn;

@end

@implementation MPTopUpPayHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.804 green:0.886 blue:1.000 alpha:1.00];
        [self makeConstraints];
    }
    return self;
}

- (void)updateWithManaPrice:(NSString *)price{
    self.manaIconView.image = [UIImage imageNameBundle:@"recharge_icon_mana"];
    self.manaValueLabel.text = price;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

- (void)updateWithManaPrice:(NSString *)price
                   yueIntro:(NSString *)yueIntro
               needSelected:(BOOL)selected{
    self.manaIconView.image = [UIImage imageNameBundle:@"group8"];
    self.manaValueLabel.text = price;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    self.iconImageView.image = [UIImage imageNameBundle:@"recharge_icon_yue"];
    self.introLabel.text = yueIntro;
    self.selectSignBtn.selected = selected;
}

#pragma mark  private
- (void)makeConstraints{
    [self.manaIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.manaValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.manaIconView.mas_centerX);
        make.top.equalTo(self.manaIconView.mas_bottom).offset(10);
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@60);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.mas_equalTo(22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top);
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.selectSignBtn.mas_left);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.selectSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)selectSignBtnAction:(id)sender{
    if (_paySelectedBlock) {
        _paySelectedBlock();
    }
}

- (void)onTapAction:(id)sender{
    if (_paySelectedBlock) {
        _paySelectedBlock();
    }
}
#pragma mark - get
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(onTapAction:)];
        _contentView.userInteractionEnabled = YES;
        [_contentView addGestureRecognizer:tap];
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kMPFont_4;
        _titleLabel.textColor = kMPColor_4;
        _titleLabel.text = @"账户余额:";
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.font = kMPFont_5;
        _introLabel.textColor = kMPColor_1;
        _introLabel.text = @"￥0.00";
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}

- (UIButton *)selectSignBtn {
    if (!_selectSignBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setImage:[UIImage imageNameBundle:@"choose_icon_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNameBundle:@"choose_icon_sel"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectSignBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        _selectSignBtn = button;
    }
    return _selectSignBtn;
}
- (UIImageView *)manaIconView{
    if (!_manaIconView) {
        _manaIconView = [[UIImageView alloc] init];
        _manaIconView.image = [UIImage imageNameBundle:@"recharge_icon_mana"];
        [self addSubview:_manaIconView];
    }
    return _manaIconView;
}

- (UILabel *)manaValueLabel{
    if (!_manaValueLabel) {
        _manaValueLabel = [[UILabel alloc]init];
        _manaValueLabel.font = [UIFont systemFontOfSize:22.0];
        _manaValueLabel.textColor = kMPColor_1;
        _manaValueLabel.text = @"0";
        [self addSubview:_manaValueLabel];
    }
    return _manaValueLabel;
}

@end

@interface MPTopUpPayCell ()
@property (nonatomic, strong) UIImageView *paySignImageView;
@property (nonatomic, strong) UIButton *selectSignBtn;
@property (nonatomic, strong) UILabel *payTypeLabel;
@property (nonatomic, strong) UILabel *descTypeLabel;
@property (nonatomic, strong) UIView *underLine;
@end

@implementation MPTopUpPayCell
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryView = self.selectSignBtn;
        [self makeConstraints];
    }
    return self;
}

- (void)updateWithPayIcon:(UIImage *)icon payTitle:(NSString *)title payInfo:(NSString *)payInfo needSelected:(BOOL)selected{
    self.paySignImageView.image = icon;
    self.payTypeLabel.text = title;
    if (payInfo) {
        self.descTypeLabel.text = payInfo;
        
        [self.payTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
        }];
        
    }else{
        [self.payTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
        }];
    }
    self.selectSignBtn.selected = selected;
    
}

#pragma mark - configUI
- (void)makeConstraints{
    [self.paySignImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.mas_equalTo(22);
    }];
    
    [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.paySignImageView.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [self.descTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTypeLabel.mas_bottom);
        make.left.equalTo(self.payTypeLabel.mas_left);
        make.right.equalTo(self.payTypeLabel.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payTypeLabel.mas_left);
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)selectSignBtnAction:(id)sender{
    if (_paySelectedBlock) {
        _paySelectedBlock();
    }
}
#pragma mark - get
- (UIImageView *)paySignImageView{
    if (!_paySignImageView) {
        _paySignImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_paySignImageView];
    }
    return _paySignImageView;
}

- (UILabel *)payTypeLabel{
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.font = kMPFont_4;
        _payTypeLabel.textColor = kMPColor_4;
        [self.contentView addSubview:_payTypeLabel];
    }
    return _payTypeLabel;
}

- (UILabel *)descTypeLabel{
    if (!_descTypeLabel) {
        _descTypeLabel = [[UILabel alloc] init];
        _descTypeLabel.font = kMPFont_8;
        _descTypeLabel.textColor = kMPColor_6;
        [self.contentView addSubview:_descTypeLabel];
    }
    return _descTypeLabel;
}


- (UIButton *)selectSignBtn {
    if (!_selectSignBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setImage:[UIImage imageNameBundle:@"choose_icon_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNameBundle:@"choose_icon_sel"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectSignBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _selectSignBtn = button;
    }
    return _selectSignBtn;
}

- (UIView *)underLine{
    if (!_underLine) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = kMPColor_9;
        [self.contentView addSubview:_underLine];
    }
    return _underLine;
}

@end
