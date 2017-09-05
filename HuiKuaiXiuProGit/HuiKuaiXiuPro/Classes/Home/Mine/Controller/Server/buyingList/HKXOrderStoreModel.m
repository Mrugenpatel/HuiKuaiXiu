//
//  HKXSupplierOrderStoreModel.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOrderStoreModel.h"

@implementation HKXOrderStoreModel


- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        self.orderId = [self NULLToNil:dict[@"orderId"]];
        self.sellerId = [self NULLToNil:dict[@"sellerId"]];
        self.uId = [self NULLToNil:dict[@"uId"]];
        self.cost = [self NULLToNil:dict[@"cost"]];
        self.companyName = [self NULLToNil:dict[@"companyName"]];
        self.addName = [self NULLToNil:dict[@"addName"]];
        self.addTel = [self NULLToNil:dict[@"addTel"]];
        self.add = [self NULLToNil:dict[@"add"]];
        self.orderStatus = [self NULLToNil:dict[@"orderStatus"]];
        self.orderMessage = [self NULLToNil:dict[@"orderMessage"]];
        self.orderDate = [self NULLToNil:dict[@"orderDate"]];
        self.orderUpdateDate = [self NULLToNil:dict[@"orderUpdateDate"]];
        self.goodsArr = [HKXOrderGoodsModel goodsWithArray:dict[@"orderGood"]];
       
    }
    return self;
}

+ (instancetype)shopWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}


+ (NSMutableArray *)modelWithArray:(NSArray *)array {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        HKXOrderStoreModel *shop = [HKXOrderStoreModel shopWithDict:dict];
        [arrayM addObject:shop];
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
