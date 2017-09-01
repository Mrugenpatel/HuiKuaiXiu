//
//  goodsTableViewCell.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsBrand;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsCompany;
@property (weak, nonatomic) IBOutlet UILabel *goodsAddress;

@end
