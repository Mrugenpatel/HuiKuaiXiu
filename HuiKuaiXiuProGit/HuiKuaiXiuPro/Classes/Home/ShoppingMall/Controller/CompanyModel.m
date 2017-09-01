//
//  CompanyModel.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        _companyName = [self NULLToNil:dict[@"companyName"]];
        _address = [self NULLToNil:dict[@"address"]];
        _realName = [self NULLToNil:dict[@"realName"]];
        _username = [self NULLToNil:dict[@"username"]];
        _registerCapital = [self NULLToNil:dict[@"registerCapital"]];
        _establishmentTime = [self NULLToNil:dict[@"establishmentTime"]];
        _companyIntroduce = [self NULLToNil:dict[@"companyIntroduce"]];
        _companyMain = [self NULLToNil:dict[@"companyMain"]];
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
