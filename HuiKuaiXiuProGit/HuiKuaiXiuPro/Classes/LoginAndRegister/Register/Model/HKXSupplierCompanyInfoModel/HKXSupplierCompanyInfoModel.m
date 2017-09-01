//
//  HKXSupplierCompanyInfoModel.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSupplierCompanyInfoModel.h"

@implementation HKXSupplierCompanyInfoModel

+ (instancetype)getUserModel
{
    return [[self alloc] init];
}
//对属性进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uId forKey:@"uId"];
    [aCoder encodeObject:_role forKey:@"role"];
    [aCoder encodeObject:_realName forKey:@"realName"];
    [aCoder encodeObject:_companyName forKey:@"companyName"];
    [aCoder encodeObject:_companyAddress forKey:@"companyAddress"];
    [aCoder encodeObject:_registerCapital forKey:@"registerCapital"];
    [aCoder encodeObject:_establishmentTime forKey:@"establishmentTime"];
    [aCoder encodeObject:_companyIntroduce forKey:@"companyIntroduce"];
    [aCoder encodeObject:_companyMain forKey:@"companyMain"];
    
    
}
//解码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.uId = [aDecoder decodeObjectForKey:@"uId"];
        self.role = [aDecoder decodeObjectForKey:@"role"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.companyAddress = [aDecoder decodeObjectForKey:@"companyAddress"];
        self.registerCapital = [aDecoder decodeObjectForKey:@"registerCapital"];
        self.establishmentTime = [aDecoder decodeObjectForKey:@"establishmentTime"];
        self.companyIntroduce = [aDecoder decodeObjectForKey:@"companyIntroduce"];
        self.companyMain = [aDecoder decodeObjectForKey:@"companyMain"];
        
    }
    return self;
}
//描述
- (NSString *)description
{
    return [NSString stringWithFormat:@"userId = %@ , role = %@ , realName = %@ , companyName = %@ , registerCapital = %@ ,establishmentTime = %@ , companyIntroduce = %@ , companyMain = %@ , companyAddress = %@ ",_uId, _role, _realName , _companyName ,_registerCapital ,_establishmentTime, _companyIntroduce, _companyMain , _companyAddress ];
}

@end
