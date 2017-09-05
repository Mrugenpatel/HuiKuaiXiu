//
//  HKXSupplierOrderGoodsModel.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOrderGoodsModel.h"

@implementation HKXOrderGoodsModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        self.orderGoodId = [self NULLToNil:dict[@"orderGoodId"]];
        self.orderId = [self NULLToNil:dict[@"orderId"]];
        self.mId = [self NULLToNil:dict[@"mId"]];
        self.goodName = [self NULLToNil:dict[@"goodName"]];
        self.goodModel = [self NULLToNil:dict[@"goodModel"]];
        self.goodBrand = [self NULLToNil:dict[@"goodBrand"]];
        self.goodCategory = [self NULLToNil:dict[@"goodCategory"]];
        self.goodPicture = [self NULLToNil:dict[@"goodPicture"]];
        self.goodPrice = [self NULLToNil:dict[@"goodPrice"]];
        self.buyNumber = [self NULLToNil:dict[@"buyNumber"]];
        self.goodTotal = [self NULLToNil:dict[@"goodTotal"]];
        self.isAssess = [self NULLToNil:dict[@"isAssess"]];
        
    }
    return self;
}


+ (instancetype)goodsWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)goodsWithArray:(NSMutableArray *)array {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        
        HKXOrderGoodsModel *goods = [HKXOrderGoodsModel goodsWithDict:dict];
        [arrayM addObject:goods];
    }
    return arrayM;
}
- (NSString *)NULLToNil:(NSString *)str{
    
    if ([str isKindOfClass:[NSNull class]]) {
        
        return nil;
    }else{
        
        return str;
    }
    
}



@end
