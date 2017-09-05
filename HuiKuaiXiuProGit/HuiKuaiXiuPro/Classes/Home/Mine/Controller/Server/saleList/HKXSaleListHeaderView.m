//
//  HKXSupplierSaleListHeaderView.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSaleListHeaderView.h"

#import "CommonMethod.h"

@implementation HKXSaleListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //    客户信息
        self.clientInfoView = [[UIView alloc] initWithFrame:CGRectMake(16 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 351 * myDelegate.autoSizeScaleX, 75 * myDelegate.autoSizeScaleY)];
        self.clientInfoView.tag = 9000;
        self.clientInfoView.layer.borderWidth = 0.5;
        self.clientInfoView.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa302"].CGColor;
        self.clientInfoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.clientInfoView];
        
        self.orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 335 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
                self.orderNumLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
        [self.clientInfoView addSubview:self.orderNumLabel];
        
       self.clientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.orderNumLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"姓名：郭得友" WithFont:12 * myDelegate.autoSizeScaleX], 12 * myDelegate.autoSizeScaleX)];
       
        self.clientNameLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
        [self.clientInfoView addSubview:self.clientNameLabel];
        
        self.clientPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.clientNameLabel.frame) + 66 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.orderNumLabel.frame) + 9 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
        
        self.clientPhoneLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
        [self.clientInfoView addSubview:self.clientPhoneLabel];
        
        self.clientAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.clientNameLabel.frame) + 9 * myDelegate.autoSizeScaleY, 335 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
        
        self.clientAddressLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
        [self.clientInfoView addSubview:self.clientAddressLabel];
    }
    return self;
}

- (void)setStore:(HKXOrderStoreModel *)store{
    
    _store = store;
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号:%@",store.orderId];
    self.clientNameLabel.text = [NSString stringWithFormat:@"姓名:%@",store.addName];
    self.clientPhoneLabel.text = [NSString stringWithFormat:@"电话:%@",store.addTel];
    self.clientAddressLabel.text = [NSString stringWithFormat:@"地址:%@",store.add];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
