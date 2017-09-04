//
//  HKXCsutomShoppingCartCollectionReusableView.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/9/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKXMineShoppingCartListData.h"

@class HKXCsutomShoppingCartCollectionReusableView;
@protocol HKXCsutomShoppingCartCollectionReusableViewDelegate <NSObject>

- (void)clickedWhichHeaderView:(NSInteger)index;

@end

@interface HKXCsutomShoppingCartCollectionReusableView : UICollectionReusableView
@property (nonatomic , strong) UIButton * leftBtn;
@property (nonatomic , strong) UILabel  * shopTitleLabel;

@property (nonatomic , strong)HKXMineShoppingCartListData * shopModel;
@property (nonatomic , weak)id<HKXCsutomShoppingCartCollectionReusableViewDelegate>delegate;

- (void)loadDataWithShopData:(HKXMineShoppingCartListData *)shopModel;

@end
