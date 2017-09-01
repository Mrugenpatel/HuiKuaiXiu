//
//  PartGoodsModel.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartGoodsModel : NSObject

//配件主键ID
@property(nonatomic ,copy)NSString *pId;

//配件编号
@property(nonatomic ,copy)NSString *number;

//配件名称
@property(nonatomic ,copy)NSString *basename;

//配件品牌
@property(nonatomic ,copy)NSString *brand;

//配件型号
@property(nonatomic ,copy)NSString *model;

//配件价格
@property(nonatomic ,copy)NSString *price;

//产品描述
@property(nonatomic ,copy)NSString *introduct;

//配件类别
@property(nonatomic ,copy)NSString *category;

//配件图片
@property(nonatomic ,strong)NSMutableArray *picture;

//适用车型
@property(nonatomic ,copy)NSString *applyCareModel;

//配件库存
@property(nonatomic ,copy)NSString *stock;

//配件地址
@property(nonatomic ,copy)NSString *address;

//机主ID
@property(nonatomic ,copy)NSString *mId;

//公司名称
@property(nonatomic ,copy)NSString *companyName;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
