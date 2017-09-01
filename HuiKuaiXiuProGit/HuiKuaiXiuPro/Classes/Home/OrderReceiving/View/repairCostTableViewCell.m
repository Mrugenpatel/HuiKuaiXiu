//
//  repairCostTableViewCell.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "repairCostTableViewCell.h"

@implementation repairCostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.costNum.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    self.costNum.leftView = view;
    self.costNum.leftViewMode = UITextFieldViewModeAlways;
    self.costNum.keyboardType = UIKeyboardTypeNumberPad;
    self.costNum.layer.cornerRadius = 4.0f;
    self.costNum.layer.borderWidth = 1.0f;
    self.costNum.layer.borderColor = [[UIColor grayColor] CGColor];
    self.costNum.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
