//
//  HKXGoodsView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKXOrderGoodsModel.h"

@interface HKXGoodsView : UIView

@property(nonatomic ,strong)UIImageView * goodsImg;

@property(nonatomic ,strong)UILabel * label1;

@property(nonatomic ,strong)UILabel * label2;

@property(nonatomic ,strong)UILabel * label3;

@property(nonatomic ,strong)UILabel * label4;

@property(nonatomic ,strong)HKXOrderGoodsModel * goods;

@end
