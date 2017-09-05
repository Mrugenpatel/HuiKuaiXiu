//
//  HKXSupplierSaleListFooterView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKXOrderStoreModel.h"

@protocol HKXSaleListBtnDelegate <NSObject>

- (void)btnClick:(UIButton *)actionBtn;

@end

@interface HKXSaleListFooterView : UITableViewHeaderFooterView
@property(nonatomic ,strong)HKXOrderStoreModel * store;
@property(nonatomic ,strong)UIButton * actionLeftBtn;
@property(nonatomic ,strong)UIButton * actionRightBtn;
@property(nonatomic ,weak)id<HKXSaleListBtnDelegate>delegate;
@end
