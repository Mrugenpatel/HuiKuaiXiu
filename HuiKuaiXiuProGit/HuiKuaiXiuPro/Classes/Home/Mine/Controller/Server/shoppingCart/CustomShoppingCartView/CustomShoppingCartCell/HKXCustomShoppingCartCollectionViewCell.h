//
//  HKXCustomShoppingCartCollectionViewCell.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/9/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXMineShoppingCartListShopcartList.h"
@class HKXCustomShoppingCartCollectionViewCell;
@protocol HKXMineCustomShoppingCartCollectionViewCellDelegate <NSObject>

@optional
- (void)clickWhichLeftBtn:(HKXCustomShoppingCartCollectionViewCell *)cell;
- (void)changeTheGoodsCount:(HKXCustomShoppingCartCollectionViewCell *)cell Count:(NSInteger)count;
- (void)longPressToDeleteThisGoods:(HKXCustomShoppingCartCollectionViewCell *)cell;

@end

@interface HKXCustomShoppingCartCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong)HKXMineShoppingCartListShopcartList * goodsModel;

@property (nonatomic , strong)UIButton * selectBtn;
@property (nonatomic , strong)UIImageView * goodsImg;
@property (nonatomic , strong)UILabel * goodsTitleLabel;
@property (nonatomic , strong)UILabel * goodsTypeLabel;
@property (nonatomic , strong)UILabel * goodsPriceLabel;
@property (nonatomic , strong)UILabel * goodsNumberLabel;
@property (nonatomic , strong)UIButton * leftBtn;//减号
@property (nonatomic , strong)UIButton * rightBtn;//加号
@property (nonatomic , strong)UILongPressGestureRecognizer * gesture;//手势

@property (nonatomic , weak)id<HKXMineCustomShoppingCartCollectionViewCellDelegate>delegate;

- (void)loadDataWithShopModel:(HKXMineShoppingCartListShopcartList *)shoppingModel;


@end
