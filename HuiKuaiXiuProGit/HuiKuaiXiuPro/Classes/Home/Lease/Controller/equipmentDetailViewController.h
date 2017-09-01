//
//  equipmentDetailViewController.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/21.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface equipmentDetailViewController : UIViewController


//brandmodel:品牌型号；modelid：设备ID；address：设备所在地；picture：图片；oil：是否含油；driver：是否带司机
//cost：台班费；machinephone：联系电话；mId：用户编号
@property(nonatomic ,strong)NSString *brandmodel;
@property(nonatomic ,strong)NSString *address;
@property(nonatomic ,strong)NSString *picture;
@property(nonatomic ,strong)NSString *oil;
@property(nonatomic ,strong)NSString *driver;
@property(nonatomic ,strong)NSString *machinephone;

@property (strong, nonatomic)  NSString *cost;

@property (strong, nonatomic)  NSString *state;

@end
