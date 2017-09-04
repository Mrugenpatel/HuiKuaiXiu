//
//  HKXSupplierSaleListFooterView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKXSupplierOrderStoreModel.h"

@protocol HKXSupplierSaleListBtnDelegate <NSObject>

- (void)btnClick:(UIButton *)actionBtn;

@end

@interface HKXSupplierSaleListFooterView : UITableViewHeaderFooterView
@property(nonatomic ,strong)HKXSupplierOrderStoreModel * store;
@property(nonatomic ,strong)UIButton * actionLeftBtn;
@property(nonatomic ,strong)UIButton * actionRightBtn;
@property(nonatomic ,weak)id<HKXSupplierSaleListBtnDelegate>delegate;
@end
