//
//  HKXMineServeInfoData.m
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineServeInfoData.h"


NSString *const kHKXMineServeInfoDataProfile = @"profile";
NSString *const kHKXMineServeInfoDataRealName = @"realName";
NSString *const kHKXMineServeInfoDataRecommendCode = @"recommendCode";
NSString *const kHKXMineServeInfoDataIdCode = @"idCode";
NSString *const kHKXMineServeInfoDataInviteCode = @"inviteCode";
//NSString *const kHKXMineServeInfoDataProvince = @"province";
NSString *const kHKXMineServeInfoDataCredentials = @"credentials";
NSString *const kHKXMineServeInfoDataPerfectInfo = @"perfectInfo";
NSString *const kHKXMineServeInfoDataAddress = @"address";
//NSString *const kHKXMineServeInfoDataCity = @"city";
NSString *const kHKXMineServeInfoDataUsername = @"username";
NSString *const kHKXMineServeInfoDataRole = @"role";
NSString *const kHKXMineServeInfoDataCompanyName = @"companyName";
NSString *const kHKXMineServeInfoDataMajorMachine = @"majorMachine";
NSString *const kHKXMineServeInfoDataPhoto = @"photo";


@interface HKXMineServeInfoData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineServeInfoData

@synthesize profile = _profile;
@synthesize realName = _realName;
@synthesize recommendCode = _recommendCode;
@synthesize idCode = _idCode;
@synthesize inviteCode = _inviteCode;
//@synthesize province = _province;
@synthesize credentials = _credentials;
@synthesize perfectInfo = _perfectInfo;
@synthesize address = _address;
//@synthesize city = _city;
@synthesize username = _username;
@synthesize role = _role;
@synthesize companyName = _companyName;
@synthesize majorMachine = _majorMachine;
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
            self.profile = [self objectOrNilForKey:kHKXMineServeInfoDataProfile fromDictionary:dict];
            self.realName = [self objectOrNilForKey:kHKXMineServeInfoDataRealName fromDictionary:dict];
            self.recommendCode = [self objectOrNilForKey:kHKXMineServeInfoDataRecommendCode fromDictionary:dict];
            self.idCode = [self objectOrNilForKey:kHKXMineServeInfoDataIdCode fromDictionary:dict];
            self.inviteCode = [self objectOrNilForKey:kHKXMineServeInfoDataInviteCode fromDictionary:dict];
//            self.province = [self objectOrNilForKey:kHKXMineServeInfoDataProvince fromDictionary:dict];
            self.credentials = [self objectOrNilForKey:kHKXMineServeInfoDataCredentials fromDictionary:dict];
            self.perfectInfo = [[self objectOrNilForKey:kHKXMineServeInfoDataPerfectInfo fromDictionary:dict] doubleValue];
            self.address = [self objectOrNilForKey:kHKXMineServeInfoDataAddress fromDictionary:dict];
//            self.city = [self objectOrNilForKey:kHKXMineServeInfoDataCity fromDictionary:dict];
            self.username = [self objectOrNilForKey:kHKXMineServeInfoDataUsername fromDictionary:dict];
            self.role = [[self objectOrNilForKey:kHKXMineServeInfoDataRole fromDictionary:dict] doubleValue];
            self.companyName = [self objectOrNilForKey:kHKXMineServeInfoDataCompanyName fromDictionary:dict];
            self.majorMachine = [self objectOrNilForKey:kHKXMineServeInfoDataMajorMachine fromDictionary:dict];
            self.photo = [self objectOrNilForKey:kHKXMineServeInfoDataPhoto fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.profile forKey:kHKXMineServeInfoDataProfile];
    [mutableDict setValue:self.realName forKey:kHKXMineServeInfoDataRealName];
    [mutableDict setValue:self.recommendCode forKey:kHKXMineServeInfoDataRecommendCode];
    [mutableDict setValue:self.idCode forKey:kHKXMineServeInfoDataIdCode];
    [mutableDict setValue:self.inviteCode forKey:kHKXMineServeInfoDataInviteCode];
//    [mutableDict setValue:self.province forKey:kHKXMineServeInfoDataProvince];
    [mutableDict setValue:self.credentials forKey:kHKXMineServeInfoDataCredentials];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perfectInfo] forKey:kHKXMineServeInfoDataPerfectInfo];
    [mutableDict setValue:self.address forKey:kHKXMineServeInfoDataAddress];
//    [mutableDict setValue:self.city forKey:kHKXMineServeInfoDataCity];
    [mutableDict setValue:self.username forKey:kHKXMineServeInfoDataUsername];
    [mutableDict setValue:[NSNumber numberWithDouble:self.role] forKey:kHKXMineServeInfoDataRole];
    [mutableDict setValue:self.companyName forKey:kHKXMineServeInfoDataCompanyName];
    [mutableDict setValue:self.majorMachine forKey:kHKXMineServeInfoDataMajorMachine];
    [mutableDict setValue:self.photo forKey:kHKXMineServeInfoDataPhoto];

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

    self.profile = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataProfile];
    self.realName = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataRealName];
    self.recommendCode = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataRecommendCode];
    self.idCode = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataIdCode];
    self.inviteCode = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataInviteCode];
//    self.province = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataProvince];
    self.credentials = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataCredentials];
    self.perfectInfo = [aDecoder decodeDoubleForKey:kHKXMineServeInfoDataPerfectInfo];
    self.address = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataAddress];
//    self.city = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataCity];
    self.username = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataUsername];
    self.role = [aDecoder decodeDoubleForKey:kHKXMineServeInfoDataRole];
    self.companyName = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataCompanyName];
    self.majorMachine = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataMajorMachine];
    self.photo = [aDecoder decodeObjectForKey:kHKXMineServeInfoDataPhoto];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_profile forKey:kHKXMineServeInfoDataProfile];
    [aCoder encodeObject:_realName forKey:kHKXMineServeInfoDataRealName];
    [aCoder encodeObject:_recommendCode forKey:kHKXMineServeInfoDataRecommendCode];
    [aCoder encodeObject:_idCode forKey:kHKXMineServeInfoDataIdCode];
    [aCoder encodeObject:_inviteCode forKey:kHKXMineServeInfoDataInviteCode];
//    [aCoder encodeObject:_province forKey:kHKXMineServeInfoDataProvince];
    [aCoder encodeObject:_credentials forKey:kHKXMineServeInfoDataCredentials];
    [aCoder encodeDouble:_perfectInfo forKey:kHKXMineServeInfoDataPerfectInfo];
    [aCoder encodeObject:_address forKey:kHKXMineServeInfoDataAddress];
//    [aCoder encodeObject:_city forKey:kHKXMineServeInfoDataCity];
    [aCoder encodeObject:_username forKey:kHKXMineServeInfoDataUsername];
    [aCoder encodeDouble:_role forKey:kHKXMineServeInfoDataRole];
    [aCoder encodeObject:_companyName forKey:kHKXMineServeInfoDataCompanyName];
    [aCoder encodeObject:_majorMachine forKey:kHKXMineServeInfoDataMajorMachine];
    [aCoder encodeObject:_photo forKey:kHKXMineServeInfoDataPhoto];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineServeInfoData *copy = [[HKXMineServeInfoData alloc] init];
    
    if (copy) {

        copy.profile = [self.profile copyWithZone:zone];
        copy.realName = [self.realName copyWithZone:zone];
        copy.recommendCode = [self.recommendCode copyWithZone:zone];
        copy.idCode = [self.idCode copyWithZone:zone];
        copy.inviteCode = [self.inviteCode copyWithZone:zone];
//        copy.province = [self.province copyWithZone:zone];
        copy.credentials = [self.credentials copyWithZone:zone];
        copy.perfectInfo = self.perfectInfo;
        copy.address = [self.address copyWithZone:zone];
//        copy.city = [self.city copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
        copy.role = self.role;
        copy.companyName = [self.companyName copyWithZone:zone];
        copy.majorMachine = [self.majorMachine copyWithZone:zone];
        copy.photo = [self.photo copyWithZone:zone];
    }
    
    return copy;
}


@end
