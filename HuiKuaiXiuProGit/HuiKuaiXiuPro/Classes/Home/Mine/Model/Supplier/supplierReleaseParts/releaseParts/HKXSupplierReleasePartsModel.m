//
//  HKXSupplierReleasePartsModel.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSupplierReleasePartsModel.h"

@implementation HKXSupplierReleasePartsModel

+ (instancetype)getUserModel
{
    return [[self alloc] init];
}
//对属性进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_pid forKey:@"pid"];
    [aCoder encodeObject:_mid forKey:@"mid"];
    [aCoder encodeObject:_number forKey:@"number"];
    [aCoder encodeObject:_brand forKey:@"brand"];
    [aCoder encodeObject:_basename forKey:@"basename"];
    [aCoder encodeObject:_model forKey:@"model"];
    [aCoder encodeObject:_tempPrice forKey:@"tempPrice"];
    [aCoder encodeObject:_introduct forKey:@"introduct"];
    [aCoder encodeObject:_picture forKey:@"picture"];
    [aCoder encodeObject:_category forKey:@"category"];
    [aCoder encodeObject:_applyCareModel forKey:@"applyCareModel"];
    [aCoder encodeObject:_stock forKey:@"stock"];
    
}
//解码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        self.mid = [aDecoder decodeObjectForKey:@"mid"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.brand = [aDecoder decodeObjectForKey:@"brand"];
        self.basename = [aDecoder decodeObjectForKey:@"basename"];
        self.model = [aDecoder decodeObjectForKey:@"model"];
        self.tempPrice = [aDecoder decodeObjectForKey:@"tempPrice"];
        self.introduct = [aDecoder decodeObjectForKey:@"introduct"];
        self.picture = [aDecoder decodeObjectForKey:@"picture"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.applyCareModel = [aDecoder decodeObjectForKey:@"applyCareModel"];
        self.stock = [aDecoder decodeObjectForKey:@"stock"];
        
    }
    return self;
}
//描述
- (NSString *)description
{
    return [NSString stringWithFormat:@"pid = %@ mid = %@ , number = %@ , brand = %@ , basename = %@ , model = %@ ,tempPrice = %@ , introduct = %@ , picture = %@ , category = %@ , applyCareModel = %@ , stock = %@",_pid,_mid, _number, _brand , _basename ,_model ,_tempPrice, _introduct, _picture , _category, _applyCareModel , _stock ];
}

@end
