//
//  HKXOwnerRegisterMachineModel.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOwnerRegisterMachineModel.h"

@implementation HKXOwnerRegisterMachineModel
+ (instancetype)getUserModel
{
    return [[self alloc] init];
}
//对属性进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uId forKey:@"uId"];
    [aCoder encodeObject:_nameplateNum forKey:@"nameplateNum"];
    [aCoder encodeObject:_category forKey:@"category"];
    [aCoder encodeObject:_brand forKey:@"brand"];
    [aCoder encodeObject:_model forKey:@"model"];
    [aCoder encodeObject:_buyDate forKey:@"buyDate"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_parameter forKey:@"parameter"];
    [aCoder encodeObject:_remarks forKey:@"remarks"];
    [aCoder encodeObject:_picture forKey:@"picture"];
    
}
//解码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.uId = [aDecoder decodeObjectForKey:@"uId"];
        self.nameplateNum = [aDecoder decodeObjectForKey:@"nameplateNum"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.brand = [aDecoder decodeObjectForKey:@"brand"];
        self.model = [aDecoder decodeObjectForKey:@"model"];
        self.buyDate = [aDecoder decodeObjectForKey:@"buyDate"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.parameter = [aDecoder decodeObjectForKey:@"parameter"];
        self.remarks = [aDecoder decodeObjectForKey:@"remarks"];
        self.picture = [aDecoder decodeObjectForKey:@"picture"];
    }
    return self;
}
//描述
- (NSString *)description
{
    return [NSString stringWithFormat:@"userId = %@ , nameplateNum = %@ , category = %@ , brand = %@ , model = %@ ,buyDate = %@ , address = %@ , parameter = %@ , remarks = %@ , picture = %@",_uId, _nameplateNum, _category , _brand ,_model ,_buyDate, _address, _parameter , _remarks ,_picture];
}

@end
