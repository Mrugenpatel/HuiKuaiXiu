//
//  HKXMineOwnerInfoData.m
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineOwnerInfoData.h"


NSString *const kHKXMineOwnerInfoDataAddress = @"address";

NSString *const kHKXMineOwnerInfoDataRealName = @"realName";
NSString *const kHKXMineOwnerInfoDataInviteCode = @"inviteCode";
NSString *const kHKXMineOwnerInfoDataRole = @"role";
NSString *const kHKXMineOwnerInfoDataUsername = @"username";
NSString *const kHKXMineOwnerInfoDataPerfectInfo = @"perfectInfo";
NSString *const kHKXMineOwnerInfoDataCompanyName = @"companyName";
NSString *const kHKXMineOwnerInfoDataPhoto = @"photo";
NSString *const kHKXMineOwnerInfoDataRecommendCode = @"recommendCode";



@interface HKXMineOwnerInfoData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineOwnerInfoData

@synthesize address = _address;

@synthesize realName = _realName;
@synthesize inviteCode = _inviteCode;
@synthesize role = _role;
@synthesize username = _username;
@synthesize perfectInfo = _perfectInfo;
@synthesize companyName = _companyName;
@synthesize photo = _photo;
@synthesize recommendCode = _recommendCode;



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
            self.address = [self objectOrNilForKey:kHKXMineOwnerInfoDataAddress fromDictionary:dict];
//            self.city = [self objectOrNilForKey:kHKXMineOwnerInfoDataCity fromDictionary:dict];
            self.realName = [self objectOrNilForKey:kHKXMineOwnerInfoDataRealName fromDictionary:dict];
            self.inviteCode = [self objectOrNilForKey:kHKXMineOwnerInfoDataInviteCode fromDictionary:dict];
            self.role = [[self objectOrNilForKey:kHKXMineOwnerInfoDataRole fromDictionary:dict] doubleValue];
            self.username = [self objectOrNilForKey:kHKXMineOwnerInfoDataUsername fromDictionary:dict];
            self.perfectInfo = [[self objectOrNilForKey:kHKXMineOwnerInfoDataPerfectInfo fromDictionary:dict] doubleValue];
            self.companyName = [self objectOrNilForKey:kHKXMineOwnerInfoDataCompanyName fromDictionary:dict];
            self.photo = [self objectOrNilForKey:kHKXMineOwnerInfoDataPhoto fromDictionary:dict];
            self.recommendCode = [self objectOrNilForKey:kHKXMineOwnerInfoDataRecommendCode fromDictionary:dict];
//            self.province = [self objectOrNilForKey:kHKXMineOwnerInfoDataProvince fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kHKXMineOwnerInfoDataAddress];
//    [mutableDict setValue:self.city forKey:kHKXMineOwnerInfoDataCity];
    [mutableDict setValue:self.realName forKey:kHKXMineOwnerInfoDataRealName];
    [mutableDict setValue:self.inviteCode forKey:kHKXMineOwnerInfoDataInviteCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.role] forKey:kHKXMineOwnerInfoDataRole];
    [mutableDict setValue:self.username forKey:kHKXMineOwnerInfoDataUsername];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perfectInfo] forKey:kHKXMineOwnerInfoDataPerfectInfo];
    [mutableDict setValue:self.companyName forKey:kHKXMineOwnerInfoDataCompanyName];
    [mutableDict setValue:self.photo forKey:kHKXMineOwnerInfoDataPhoto];
    [mutableDict setValue:self.recommendCode forKey:kHKXMineOwnerInfoDataRecommendCode];
//    [mutableDict setValue:self.province forKey:kHKXMineOwnerInfoDataProvince];

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

    self.address = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataAddress];
//    self.city = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataCity];
    self.realName = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataRealName];
    self.inviteCode = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataInviteCode];
    self.role = [aDecoder decodeDoubleForKey:kHKXMineOwnerInfoDataRole];
    self.username = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataUsername];
    self.perfectInfo = [aDecoder decodeDoubleForKey:kHKXMineOwnerInfoDataPerfectInfo];
    self.companyName = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataCompanyName];
    self.photo = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataPhoto];
    self.recommendCode = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataRecommendCode];
//    self.province = [aDecoder decodeObjectForKey:kHKXMineOwnerInfoDataProvince];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kHKXMineOwnerInfoDataAddress];
//    [aCoder encodeObject:_city forKey:kHKXMineOwnerInfoDataCity];
    [aCoder encodeObject:_realName forKey:kHKXMineOwnerInfoDataRealName];
    [aCoder encodeObject:_inviteCode forKey:kHKXMineOwnerInfoDataInviteCode];
    [aCoder encodeDouble:_role forKey:kHKXMineOwnerInfoDataRole];
    [aCoder encodeObject:_username forKey:kHKXMineOwnerInfoDataUsername];
    [aCoder encodeDouble:_perfectInfo forKey:kHKXMineOwnerInfoDataPerfectInfo];
    [aCoder encodeObject:_companyName forKey:kHKXMineOwnerInfoDataCompanyName];
    [aCoder encodeObject:_photo forKey:kHKXMineOwnerInfoDataPhoto];
    [aCoder encodeObject:_recommendCode forKey:kHKXMineOwnerInfoDataRecommendCode];
//    [aCoder encodeObject:_province forKey:kHKXMineOwnerInfoDataProvince];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineOwnerInfoData *copy = [[HKXMineOwnerInfoData alloc] init];
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
//        copy.city = [self.city copyWithZone:zone];
        copy.realName = [self.realName copyWithZone:zone];
        copy.inviteCode = [self.inviteCode copyWithZone:zone];
        copy.role = self.role;
        copy.username = [self.username copyWithZone:zone];
        copy.perfectInfo = self.perfectInfo;
        copy.companyName = [self.companyName copyWithZone:zone];
        copy.photo = [self.photo copyWithZone:zone];
        copy.recommendCode = [self.recommendCode copyWithZone:zone];
//        copy.province = [self.province copyWithZone:zone];
    }
    
    return copy;
}


@end
