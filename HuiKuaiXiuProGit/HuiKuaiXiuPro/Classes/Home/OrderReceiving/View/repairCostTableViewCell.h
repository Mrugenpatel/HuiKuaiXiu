//
//  repairCostTableViewCell.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface repairCostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *costType;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;
@property (weak, nonatomic) IBOutlet UITextField *costNum;

@end
