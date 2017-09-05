//
//  HKXSupplierSaleListHeaderView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKXOrderStoreModel.h"

@interface HKXSaleListHeaderView : UITableViewHeaderFooterView

@property(nonatomic ,strong)HKXOrderStoreModel * store;
@property(nonatomic ,strong)UIView * clientInfoView;

@property(nonatomic ,strong)UILabel * orderNumLabel;
@property(nonatomic ,strong)UILabel * clientNameLabel;
@property(nonatomic ,strong)UILabel * clientPhoneLabel;
@property(nonatomic ,strong)UILabel * clientAddressLabel;

@end
