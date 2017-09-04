//
//  HKXCsutomShoppingCartCollectionReusableView.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/9/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXCsutomShoppingCartCollectionReusableView.h"
#import "CommonMethod.h"


@implementation HKXCsutomShoppingCartCollectionReusableView


//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
        [self addSubview:self.leftBtn];
        
        self.shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 14 * myDelegate.autoSizeScaleX)];
//        self.shopTitleLabel.text = self.shopModel.companyname;
        self.shopTitleLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        [self addSubview:self.shopTitleLabel];
        
//        [self setData];
    }
    return self;
}
#pragma mark - lazy Loading
//- (void)setData
//{
//    _leftBtn.selected = self.shopModel.isSelected;
//    self.shopTitleLabel.text = self.shopModel.companyname;
//}
//- (void)setShopModel:(HKXMineShoppingCartListData *)shopModel
//{
//    _shopModel = shopModel;
//    
//}
- (UIButton *)leftBtn
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_leftBtn == nil)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.selected = NO;
        _leftBtn.frame = CGRectMake(10 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX);
        [_leftBtn addTarget:self action:@selector(selectThisStoreAllGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
//        _leftBtn.selected = self.shopModel.isSelected;
        
    }
    return _leftBtn;
}
- (void)selectThisStoreAllGoodsBtnClick:(UIButton *)btn
{
    NSLog(@"店铺按钮被点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedWhichHeaderView:)])
    {
        [self.delegate clickedWhichHeaderView:self.tag];
    }
}
- (void)loadDataWithShopData:(HKXMineShoppingCartListData *)shopModel
{
    _leftBtn.selected = shopModel.isSelected;
    self.shopTitleLabel.text = shopModel.companyname;
    
    self.shopModel = shopModel;
}
@end
