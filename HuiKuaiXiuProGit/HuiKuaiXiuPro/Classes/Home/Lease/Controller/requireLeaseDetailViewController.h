//
//  requireLeaseDetailViewController.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface requireLeaseDetailViewController : UIViewController
//  type:设备类型；brand：品牌；model：型号；size：吨位/米；address：设备所在地；workcontext：工况
//  contact：联系人；phone：电话；mid：用户编号

@property(nonatomic ,strong) NSString *type;
@property(nonatomic ,strong)NSString *brand;
@property(nonatomic ,strong)NSString *model;
@property(nonatomic ,strong)NSString *size;
@property(nonatomic ,strong)NSString *address;
@property(nonatomic ,strong)NSString *workcontext;
@property(nonatomic ,strong)NSString *contact;
@property(nonatomic ,strong)NSString *phone;
@property(nonatomic ,strong)NSString *mid;
@property(nonatomic ,strong)NSString *mark;
@end
