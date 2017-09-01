//
//  EquipmentGoodsModel.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EquipmentGoodsModel.h"

@implementation EquipmentGoodsModel


- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        
        _pmaId = [self NULLToNil:dict[@"pmaId"]];
        _mId = [self NULLToNil:dict[@"mId"]];
        _picture = [self NULLToNil:dict[@"picture"]];
        _type = [self NULLToNil:dict[@"type"]];
        _brand = [self NULLToNil:dict[@"brand"]];
        _modelnum = [self NULLToNil:dict[@"modelnum"]];
        _parameter = [self NULLToNil:dict[@"parameter"]];
        _compname = dict[@"compname"];
        _bewrite = [self NULLToNil:dict[@"bewrite"]];
        
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




@end
