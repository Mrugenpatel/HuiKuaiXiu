//
//  PartGoodsModel.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PartGoodsModel.h"

@implementation PartGoodsModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        
        _pId = [self NULLToNil:dict[@"pId"]];
        _number = [self NULLToNil:dict[@"number"]];
        _basename = [self NULLToNil:dict[@"basename"]];
        _brand = [self NULLToNil:dict[@"brand"]];
        _model = [self NULLToNil:dict[@"_model"]];
        _price = [self NULLToNil:dict[@"price"]];
        _introduct = [self NULLToNil:dict[@"introduct"]];
        _picture = dict[@"picture"];
        _category = [self NULLToNil:dict[@"category"]];
        _applyCareModel = [self NULLToNil:dict[@"applyCareModel"]];
        _stock = [self NULLToNil:dict[@"stock"]];
        _address = [self NULLToNil:dict[@"address"]];
        _mId = [self NULLToNil:dict[@"mId"]];
        _companyName =[self NULLToNil: dict[@"companyName"]];
    }
    return self;
}

- (NSString *)NULLToNil:(NSString *)str{
    
    if ([str isKindOfClass:[NSNull class]]) {
        
        return nil;
    }else{
        
        return str;
    }
    
}

- (NSMutableArray *)picture{
    
    if (!_picture) {
        
        _picture = [NSMutableArray array];
    }
    return _picture;
}

@end
