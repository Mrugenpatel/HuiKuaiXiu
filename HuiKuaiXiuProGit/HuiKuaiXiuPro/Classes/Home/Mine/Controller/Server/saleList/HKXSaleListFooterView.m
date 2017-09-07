//
//  HKXSupplierSaleListFooterView.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSaleListFooterView.h"

#import "CommonMethod.h"

@implementation HKXSaleListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.actionLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionLeftBtn.frame = CGRectMake(22 * myDelegate.autoSizeScaleX,5 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        self.actionLeftBtn.layer.cornerRadius = 2;
        self.actionLeftBtn.clipsToBounds = YES;
        self.actionLeftBtn.tag = self.tag + 1000;
        [self.actionLeftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.actionLeftBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa302"];
        [self addSubview:self.actionLeftBtn];
        
        self.actionRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionRightBtn.frame = CGRectMake(22 * myDelegate.autoSizeScaleX + 180 * myDelegate.autoSizeScaleX,5 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        self.actionRightBtn.layer.cornerRadius = 2;
        self.actionRightBtn.clipsToBounds = YES;
        self.actionRightBtn.tag = self.tag + 100;
        [self.actionRightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.actionRightBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa302"];
        [self addSubview:self.actionRightBtn];
    }
    return self;
}

- (void)setStore:(HKXOrderStoreModel *)store{
    
    _store = store;
    
    if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"-1"]) {
        
        
        self.actionLeftBtn.hidden = YES;
        [self.actionRightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"0"]) {
        
        self.actionLeftBtn.hidden = YES;
        [self.actionRightBtn setTitle:@"完成" forState:UIControlStateNormal];

    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"10"]) {
        
        self.actionLeftBtn.hidden = NO;
        [self.actionLeftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.actionRightBtn setTitle:@"确认发货" forState:UIControlStateNormal];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"11"]) {
        
        self.actionLeftBtn.hidden = YES;
        [self.actionRightBtn setTitle:@"待买家付款" forState:UIControlStateNormal];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"2"]) {
        
        self.actionLeftBtn.hidden = YES;
        [self.actionRightBtn setTitle:@"待确认收货" forState:UIControlStateNormal];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"3"]) {
        
        self.actionLeftBtn.hidden = YES;
        [self.actionRightBtn setTitle:@"待收款" forState:UIControlStateNormal];
        
    }else {
        
        self.actionLeftBtn.hidden = YES;
        [self.actionRightBtn setTitle:@"未知状态" forState:UIControlStateNormal];
        
    }
    
}


- (void)leftBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        
        [self.delegate btnClick:btn];
    }
}

- (void)rightBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        
        [self.delegate btnClick:btn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
