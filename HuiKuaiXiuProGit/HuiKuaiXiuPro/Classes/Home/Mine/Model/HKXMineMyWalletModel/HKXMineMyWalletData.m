//
//  HKXMineMyWalletData.m
//
//  Created by   on 2017/9/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineMyWalletData.h"


NSString *const kHKXMineMyWalletDataBelongBank = @"belongBank";
NSString *const kHKXMineMyWalletDataUserBankId = @"userBankId";
NSString *const kHKXMineMyWalletDataUserName = @"userName";
NSString *const kHKXMineMyWalletDataUserOpenBank = @"userOpenBank";
NSString *const kHKXMineMyWalletDataUId = @"uId";
NSString *const kHKXMineMyWalletDataUserIdCard = @"userIdCard";


@interface HKXMineMyWalletData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineMyWalletData

@synthesize belongBank = _belongBank;
@synthesize userBankId = _userBankId;
@synthesize userName = _userName;
@synthesize userOpenBank = _userOpenBank;
@synthesize uId = _uId;
@synthesize userIdCard = _userIdCard;


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
            self.belongBank = [self objectOrNilForKey:kHKXMineMyWalletDataBelongBank fromDictionary:dict];
            self.userBankId = [[self objectOrNilForKey:kHKXMineMyWalletDataUserBankId fromDictionary:dict] doubleValue];
            self.userName = [self objectOrNilForKey:kHKXMineMyWalletDataUserName fromDictionary:dict];
            self.userOpenBank = [self objectOrNilForKey:kHKXMineMyWalletDataUserOpenBank fromDictionary:dict];
            self.uId = [[self objectOrNilForKey:kHKXMineMyWalletDataUId fromDictionary:dict] doubleValue];
            self.userIdCard = [self objectOrNilForKey:kHKXMineMyWalletDataUserIdCard fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.belongBank forKey:kHKXMineMyWalletDataBelongBank];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userBankId] forKey:kHKXMineMyWalletDataUserBankId];
    [mutableDict setValue:self.userName forKey:kHKXMineMyWalletDataUserName];
    [mutableDict setValue:self.userOpenBank forKey:kHKXMineMyWalletDataUserOpenBank];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uId] forKey:kHKXMineMyWalletDataUId];
    [mutableDict setValue:self.userIdCard forKey:kHKXMineMyWalletDataUserIdCard];

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

    self.belongBank = [aDecoder decodeObjectForKey:kHKXMineMyWalletDataBelongBank];
    self.userBankId = [aDecoder decodeDoubleForKey:kHKXMineMyWalletDataUserBankId];
    self.userName = [aDecoder decodeObjectForKey:kHKXMineMyWalletDataUserName];
    self.userOpenBank = [aDecoder decodeObjectForKey:kHKXMineMyWalletDataUserOpenBank];
    self.uId = [aDecoder decodeDoubleForKey:kHKXMineMyWalletDataUId];
    self.userIdCard = [aDecoder decodeObjectForKey:kHKXMineMyWalletDataUserIdCard];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_belongBank forKey:kHKXMineMyWalletDataBelongBank];
    [aCoder encodeDouble:_userBankId forKey:kHKXMineMyWalletDataUserBankId];
    [aCoder encodeObject:_userName forKey:kHKXMineMyWalletDataUserName];
    [aCoder encodeObject:_userOpenBank forKey:kHKXMineMyWalletDataUserOpenBank];
    [aCoder encodeDouble:_uId forKey:kHKXMineMyWalletDataUId];
    [aCoder encodeObject:_userIdCard forKey:kHKXMineMyWalletDataUserIdCard];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineMyWalletData *copy = [[HKXMineMyWalletData alloc] init];
    
    if (copy) {

        copy.belongBank = [self.belongBank copyWithZone:zone];
        copy.userBankId = self.userBankId;
        copy.userName = [self.userName copyWithZone:zone];
        copy.userOpenBank = [self.userOpenBank copyWithZone:zone];
        copy.uId = self.uId;
        copy.userIdCard = [self.userIdCard copyWithZone:zone];
    }
    
    return copy;
}


@end
