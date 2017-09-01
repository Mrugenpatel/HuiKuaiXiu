//
//  HKXRegisterBasicInfoModel.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXRegisterBasicInfoModel.h"

@implementation HKXRegisterBasicInfoModel

+ (instancetype)getUserModel
{
    return [[self alloc] init];
}
//对属性进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_realName forKey:@"realName"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_companyName forKey:@"companyName"];
    [aCoder encodeObject:_inviteCode forKey:@"inviteCode"];
    
}
//解码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
    }
    return self;
}
//描述
- (NSString *)description
{
    return [NSString stringWithFormat:@"userId = %@ , realName = %@ , address = %@ , companyName = %@ , inviteCode = %@",_userId, _realName, _address , _companyName ,_inviteCode];
}


@end
