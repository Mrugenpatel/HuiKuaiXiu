//
//  HKXCustomShoppingCartCollectionViewCell.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/9/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXCustomShoppingCartCollectionViewCell.h"
#import "CommonMethod.h"
#import "UIImageView+WebCache.h"



@implementation HKXCustomShoppingCartCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.goodsImg];
        [self.contentView addSubview:self.goodsTitleLabel];
        [self.contentView addSubview:self.goodsTypeLabel];
        [self.contentView addSubview:self.goodsPriceLabel];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.goodsNumberLabel];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addGestureRecognizer:self.gesture];
        
    }
    return self;
}

//lazy loading

//- (void)setGoodsModel:(HKXMineShoppingCartListShopcartList *)goodsModel
//{
//    _goodsModel = goodsModel;
//}
- (UIButton *)selectBtn
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_selectBtn == nil)
    {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(10 * myDelegate.autoSizeScaleX, 57 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX);
        [_selectBtn addTarget:self action:@selector(selectThisStoreAllGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
        _selectBtn.selected = NO;
//        _leftBtn.selected = self.goodsModel.isSelected;
        
    }
    return _selectBtn;
}
- (UIImageView *)goodsImg
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_goodsImg == nil)
    {
        _goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(30 *myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
        //    goodsImg.image = [UIImage imageNamed:@"滑动视图示例"];
//        [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.goodsModel.picture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    }
    return _goodsImg;
}
- (UILabel * )goodsTitleLabel
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_goodsTitleLabel == nil)
    {
        _goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 40 * myDelegate.autoSizeScaleY)];
        
        _goodsTitleLabel.numberOfLines = 2;
//        _goodsTitleLabel.text = self.goodsModel.goodsname;
        _goodsTitleLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    }
    return _goodsTitleLabel;
}
- (UILabel *)goodsTypeLabel
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_goodsTypeLabel == nil)
    {
        _goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * myDelegate.autoSizeScaleX, CGRectGetMaxY(_goodsTitleLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 14 * myDelegate.autoSizeScaleX)];
//        _goodsTypeLabel.text = self.goodsModel.model;
        _goodsTypeLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
        _goodsTypeLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    }
    return _goodsTypeLabel;
}
- (UILabel *)goodsPriceLabel
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_goodsPriceLabel == nil)
    {
        _goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * myDelegate.autoSizeScaleX, CGRectGetMaxY(_goodsTypeLabel.frame) + 13 * myDelegate.autoSizeScaleY, 110 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
        _goodsPriceLabel.textColor = [UIColor redColor];
//        _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.goodsModel.totalprice];
        _goodsPriceLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    }
    return _goodsPriceLabel;
}
- (UIButton *)leftBtn
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_leftBtn == nil)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(271 * myDelegate.autoSizeScaleX, 86 *myDelegate.autoSizeScaleY, 23 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleY);
        [_leftBtn setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.layer.borderWidth = 1.f;
        _leftBtn.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa302"].CGColor;
    }
    return _leftBtn;
}
- (UILabel *)goodsNumberLabel
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_goodsNumberLabel == nil)
    {
        _goodsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(294 * myDelegate.autoSizeScaleX, 86 * myDelegate.autoSizeScaleY, 38 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleY)];
//        _goodsNumberLabel.text = [NSString stringWithFormat:@"%d",self.goodsModel.buynumber];
        _goodsNumberLabel.font = [UIFont systemFontOfSize:10 * myDelegate.autoSizeScaleX];
        _goodsNumberLabel.textAlignment = NSTextAlignmentCenter;
        _goodsNumberLabel.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa302"].CGColor;
        _goodsNumberLabel.layer.borderWidth = 1.f;
    }
    return _goodsNumberLabel;
}
- (UIButton *)rightBtn
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_rightBtn == nil)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(332 * myDelegate.autoSizeScaleX, 86 *myDelegate.autoSizeScaleY, 23 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleY);
        [_rightBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.layer.borderWidth = 1.f;
        _rightBtn.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa302"].CGColor;
    }
    return _rightBtn;
}
- (UILongPressGestureRecognizer *)gesture
{
    if (_gesture == nil)
    {
        _gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDeleteThisGoodsClick:)];
        _gesture.minimumPressDuration = 1;
        
    }
    return _gesture;
}
//click
- (void)selectThisStoreAllGoodsBtnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickWhichLeftBtn:)])
    {
        [self.delegate clickWhichLeftBtn:self];
    };
}
- (void)leftBtnClick:(UIButton *)btn
{
    NSInteger count = [self.goodsNumberLabel.text integerValue] - 1;
    if (count <= 0 )
    {
        return;
    }
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"%ld",count];
    [self getGoodsCountFromBtnClick:count];
}
- (void)rightBtnClick:(UIButton *)btn
{
    NSInteger count = [self.goodsNumberLabel.text integerValue] + 1;
    if (count > 5)
    {
        return;
    }
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"%ld",count];
    [self getGoodsCountFromBtnClick:count];
}
- (void)longPressToDeleteThisGoodsClick:(UILongPressGestureRecognizer *)ges
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressToDeleteThisGoods:)])
    {
        [self.delegate longPressToDeleteThisGoods:self];
    }
}

- (void)getGoodsCountFromBtnClick:(NSInteger)count
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(changeTheGoodsCount:Count:)])
    {
        [self.delegate changeTheGoodsCount:self Count:count];
    }
}
- (void)loadDataWithShopModel:(HKXMineShoppingCartListShopcartList *)shoppingModel
{
    _selectBtn.selected = shoppingModel.isSelected;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,shoppingModel.picture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    _goodsTitleLabel.text = shoppingModel.goodsname;
    _goodsTypeLabel.text = shoppingModel.model;
    
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",shoppingModel.totalprice];
    
    _goodsNumberLabel.text = [NSString stringWithFormat:@"%d",shoppingModel.buynumber];
    
    self.goodsModel = shoppingModel;
}
@end
