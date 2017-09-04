//
//  HKXSupplierSaleListHeaderView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKXSupplierOrderStoreModel.h"

@interface HKXSupplierSaleListHeaderView : UITableViewHeaderFooterView

@property(nonatomic ,strong)HKXSupplierOrderStoreModel * store;
@property(nonatomic ,strong)UIView * clientInfoView;

@property(nonatomic ,strong)UILabel * orderNumLabel;
@property(nonatomic ,strong)UILabel * clientNameLabel;
@property(nonatomic ,strong)UILabel * clientPhoneLabel;
@property(nonatomic ,strong)UILabel * clientAddressLabel;

@end
