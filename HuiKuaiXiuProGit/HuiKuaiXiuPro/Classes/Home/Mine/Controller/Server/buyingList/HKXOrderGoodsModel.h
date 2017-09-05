//
//  HKXSupplierOrderGoodsModel.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKXOrderGoodsModel : NSObject

//主键
@property(nonatomic ,copy)NSString *orderGoodId;

//订单id
@property(nonatomic ,copy)NSString *orderId;

//设备id
@property(nonatomic ,copy)NSString *mId;

//商品名
@property(nonatomic ,copy)NSString *goodName;

//商品型号
@property(nonatomic ,copy)NSString *goodModel;

//商品品牌
@property(nonatomic ,copy)NSString *goodBrand;

//商品分类
@property(nonatomic ,copy)NSString *goodCategory;

//商品图片
@property(nonatomic ,copy)NSString *goodPicture;

//商品单价
@property(nonatomic ,copy)NSString *goodPrice;

//购买数量
@property(nonatomic ,copy)NSString *buyNumber;

//单个商品总价
@property(nonatomic ,copy)NSString *goodTotal;

//是否评价 0 未评价 1 评价
@property(nonatomic ,copy)NSString *isAssess;
- (instancetype)initWithDict:(NSDictionary *)dcit;
+ (instancetype)goodsWithDict:(NSDictionary *)dict;
+ (NSMutableArray *)goodsWithArray:(NSMutableArray *)array;

@end
