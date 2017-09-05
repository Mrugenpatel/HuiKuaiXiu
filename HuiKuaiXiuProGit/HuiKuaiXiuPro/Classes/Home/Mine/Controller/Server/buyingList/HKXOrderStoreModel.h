//
//  HKXSupplierOrderStoreModel.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKXOrderGoodsModel.h"
@interface HKXOrderStoreModel : NSObject

//主键
@property(nonatomic ,copy)NSString *orderId;

//卖家id
@property(nonatomic ,copy)NSString *sellerId;

//买家id
@property(nonatomic ,copy)NSString *uId;

//订单总价
@property(nonatomic ,copy)NSString *cost;

//店铺名
@property(nonatomic ,copy)NSString *companyName;

//收货人姓名
@property(nonatomic ,copy)NSString *addName;

//收货人电话
@property(nonatomic ,copy)NSString *addTel;

//收货人地址
@property(nonatomic ,copy)NSString *add;

//订单状态
@property(nonatomic ,copy)NSString *orderStatus;

//订单说明
@property(nonatomic ,copy)NSString *orderMessage;

//下单时间
@property(nonatomic ,copy)NSString *orderDate;

//订单更新时间
@property(nonatomic ,copy)NSString *orderUpdateDate;

//商品模型
@property(nonatomic ,copy)NSMutableArray  *goodsArr;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shopWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)modelWithArray:(NSArray *)array;

@end
