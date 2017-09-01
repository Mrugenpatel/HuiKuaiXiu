//
//  bottomPopView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CompanyModel.h"

#import "PartGoodsModel.h"

@protocol bottomPopViewDelegate <NSObject>

- (void)immedateBuyClick:(NSString *)count;

@end

@interface bottomPopView : UIView

@property(nonatomic ,copy)NSString * mark;//做一个标记看看是哪个出现

@property(nonatomic ,strong)UIView * bgView;//遮罩层

@property(nonatomic ,strong)UIView * showView;//展示层

@property(nonatomic ,strong)UIImageView * goodsImage;//产品图

@property(nonatomic ,strong)UILabel * titleLb;

@property(nonatomic ,strong)UILabel * goodsName;//产品名称

@property(nonatomic ,strong)UILabel * goodsPrice;//产品价格

@property(nonatomic ,strong)UILabel * goodsStock;//产品库存

@property(nonatomic ,strong)UILabel * goodsNum;//产品数量

@property(nonatomic ,strong)UIView * chooseGoodsNum;//选择产品数量

@property(nonatomic ,strong)UIButton * buy;//立即购买

@property(nonatomic ,strong)UITextField * myfield;

@property(nonatomic ,strong)CompanyModel * companyModel;

@property(nonatomic ,strong)PartGoodsModel * partGoodsModel;

@property(nonatomic ,weak)id<bottomPopViewDelegate>delegate;

@end
