//
//  HKXMineSupplierInfoData.m
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineSupplierInfoData.h"


NSString *const kHKXMineSupplierInfoDataRealName = @"realName";
NSString *const kHKXMineSupplierInfoDataRecommendCode = @"recommendCode";
NSString *const kHKXMineSupplierInfoDataInviteCode = @"inviteCode";
NSString *const kHKXMineSupplierInfoDataProvince = @"province";
NSString *const kHKXMineSupplierInfoDataEstablishmentTime = @"establishmentTime";
NSString *const kHKXMineSupplierInfoDataPerfectInfo = @"perfectInfo";
NSString *const kHKXMineSupplierInfoDataRegisterCapital = @"registerCapital";
NSString *const kHKXMineSupplierInfoDataCompanyAddress = @"companyAddress";
NSString *const kHKXMineSupplierInfoDataAddress = @"address";
NSString *const kHKXMineSupplierInfoDataCompanyMain = @"companyMain";
NSString *const kHKXMineSupplierInfoDataCity = @"city";
NSString *const kHKXMineSupplierInfoDataUsername = @"username";
NSString *const kHKXMineSupplierInfoDataRole = @"role";
NSString *const kHKXMineSupplierInfoDataCompanyName = @"companyName";
NSString *const kHKXMineSupplierInfoDataCompanyIntroduce = @"companyIntroduce";
NSString *const kHKXMineSupplierInfoDataPhoto = @"photo";


@interface HKXMineSupplierInfoData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineSupplierInfoData

@synthesize realName = _realName;
@synthesize recommendCode = _recommendCode;
@synthesize inviteCode = _inviteCode;
//@synthesize province = _province;
//@synthesize establishmentTime = _establishmentTime;
@synthesize perfectInfo = _perfectInfo;
//@synthesize registerCapital = _registerCapital;
//@synthesize companyAddress = _companyAddress;
@synthesize address = _address;
//@synthesize companyMain = _companyMain;
//@synthesize city = _city;
@synthesize username = _username;
@synthesize role = _role;
@synthesize companyName = _companyName;
//@synthesize companyIntroduce = _companyIntroduce;
@synthesize photo = _photo;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.realName = [self objectOrNilForKey:kHKXMineSupplierInfoDataRealName fromDictionary:dict];
            self.recommendCode = [self objectOrNilForKey:kHKXMineSupplierInfoDataRecommendCode fromDictionary:dict];
            self.inviteCode = [self objectOrNilForKey:kHKXMineSupplierInfoDataInviteCode fromDictionary:dict];
//            self.province = [self objectOrNilForKey:kHKXMineSupplierInfoDataProvince fromDictionary:dict];
//            self.establishmentTime = [self objectOrNilForKey:kHKXMineSupplierInfoDataEstablishmentTime fromDictionary:dict];
            self.perfectInfo = [[self objectOrNilForKey:kHKXMineSupplierInfoDataPerfectInfo fromDictionary:dict] doubleValue];
//            self.registerCapital = [self objectOrNilForKey:kHKXMineSupplierInfoDataRegisterCapital fromDictionary:dict];
//            self.companyAddress = [self objectOrNilForKey:kHKXMineSupplierInfoDataCompanyAddress fromDictionary:dict];
            self.address = [self objectOrNilForKey:kHKXMineSupplierInfoDataAddress fromDictionary:dict];
//            self.companyMain = [self objectOrNilForKey:kHKXMineSupplierInfoDataCompanyMain fromDictionary:dict];
//            self.city = [self objectOrNilForKey:kHKXMineSupplierInfoDataCity fromDictionary:dict];
            self.username = [self objectOrNilForKey:kHKXMineSupplierInfoDataUsername fromDictionary:dict];
            self.role = [[self objectOrNilForKey:kHKXMineSupplierInfoDataRole fromDictionary:dict] doubleValue];
            self.companyName = [self objectOrNilForKey:kHKXMineSupplierInfoDataCompanyName fromDictionary:dict];
//            self.companyIntroduce = [self objectOrNilForKey:kHKXMineSupplierInfoDataCompanyIntroduce fromDictionary:dict];
            self.photo = [self objectOrNilForKey:kHKXMineSupplierInfoDataPhoto fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.realName forKey:kHKXMineSupplierInfoDataRealName];
    [mutableDict setValue:self.recommendCode forKey:kHKXMineSupplierInfoDataRecommendCode];
    [mutableDict setValue:self.inviteCode forKey:kHKXMineSupplierInfoDataInviteCode];
//    [mutableDict setValue:self.province forKey:kHKXMineSupplierInfoDataProvince];
//    [mutableDict setValue:self.establishmentTime forKey:kHKXMineSupplierInfoDataEstablishmentTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perfectInfo] forKey:kHKXMineSupplierInfoDataPerfectInfo];
//    [mutableDict setValue:self.registerCapital forKey:kHKXMineSupplierInfoDataRegisterCapital];
//    [mutableDict setValue:self.companyAddress forKey:kHKXMineSupplierInfoDataCompanyAddress];
    [mutableDict setValue:self.address forKey:kHKXMineSupplierInfoDataAddress];
//    [mutableDict setValue:self.companyMain forKey:kHKXMineSupplierInfoDataCompanyMain];
//    [mutableDict setValue:self.city forKey:kHKXMineSupplierInfoDataCity];
    [mutableDict setValue:self.username forKey:kHKXMineSupplierInfoDataUsername];
    [mutableDict setValue:[NSNumber numberWithDouble:self.role] forKey:kHKXMineSupplierInfoDataRole];
    [mutableDict setValue:self.companyName forKey:kHKXMineSupplierInfoDataCompanyName];
//    [mutableDict setValue:self.companyIntroduce forKey:kHKXMineSupplierInfoDataCompanyIntroduce];
    [mutableDict setValue:self.photo forKey:kHKXMineSupplierInfoDataPhoto];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.realName = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataRealName];
    self.recommendCode = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataRecommendCode];
    self.inviteCode = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataInviteCode];
//    self.province = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataProvince];
//    self.establishmentTime = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataEstablishmentTime];
    self.perfectInfo = [aDecoder decodeDoubleForKey:kHKXMineSupplierInfoDataPerfectInfo];
//    self.registerCapital = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataRegisterCapital];
//    self.companyAddress = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataCompanyAddress];
    self.address = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataAddress];
//    self.companyMain = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataCompanyMain];
//    self.city = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataCity];
    self.username = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataUsername];
    self.role = [aDecoder decodeDoubleForKey:kHKXMineSupplierInfoDataRole];
    self.companyName = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataCompanyName];
//    self.companyIntroduce = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataCompanyIntroduce];
    self.photo = [aDecoder decodeObjectForKey:kHKXMineSupplierInfoDataPhoto];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_realName forKey:kHKXMineSupplierInfoDataRealName];
    [aCoder encodeObject:_recommendCode forKey:kHKXMineSupplierInfoDataRecommendCode];
    [aCoder encodeObject:_inviteCode forKey:kHKXMineSupplierInfoDataInviteCode];
//    [aCoder encodeObject:_province forKey:kHKXMineSupplierInfoDataProvince];
//    [aCoder encodeObject:_establishmentTime forKey:kHKXMineSupplierInfoDataEstablishmentTime];
    [aCoder encodeDouble:_perfectInfo forKey:kHKXMineSupplierInfoDataPerfectInfo];
//    [aCoder encodeObject:_registerCapital forKey:kHKXMineSupplierInfoDataRegisterCapital];
//    [aCoder encodeObject:_companyAddress forKey:kHKXMineSupplierInfoDataCompanyAddress];
    [aCoder encodeObject:_address forKey:kHKXMineSupplierInfoDataAddress];
//    [aCoder encodeObject:_companyMain forKey:kHKXMineSupplierInfoDataCompanyMain];
//    [aCoder encodeObject:_city forKey:kHKXMineSupplierInfoDataCity];
    [aCoder encodeObject:_username forKey:kHKXMineSupplierInfoDataUsername];
    [aCoder encodeDouble:_role forKey:kHKXMineSupplierInfoDataRole];
    [aCoder encodeObject:_companyName forKey:kHKXMineSupplierInfoDataCompanyName];
//    [aCoder encodeObject:_companyIntroduce forKey:kHKXMineSupplierInfoDataCompanyIntroduce];
    [aCoder encodeObject:_photo forKey:kHKXMineSupplierInfoDataPhoto];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineSupplierInfoData *copy = [[HKXMineSupplierInfoData alloc] init];
    
    if (copy) {

        copy.realName = [self.realName copyWithZone:zone];
        copy.recommendCode = [self.recommendCode copyWithZone:zone];
        copy.inviteCode = [self.inviteCode copyWithZone:zone];
//        copy.province = [self.province copyWithZone:zone];
//        copy.establishmentTime = [self.establishmentTime copyWithZone:zone];
        copy.perfectInfo = self.perfectInfo;
//        copy.registerCapital = [self.registerCapital copyWithZone:zone];
//        copy.companyAddress = [self.companyAddress copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
//        copy.companyMain = [self.companyMain copyWithZone:zone];
//        copy.city = [self.city copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
        copy.role = self.role;
        copy.companyName = [self.companyName copyWithZone:zone];
//        copy.companyIntroduce = [self.companyIntroduce copyWithZone:zone];
        copy.photo = [self.photo copyWithZone:zone];
    }
    
    return copy;
}


@end
