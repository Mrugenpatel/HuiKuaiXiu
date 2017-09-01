//
//  HKXMineAddressListData.m
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineAddressListData.h"


NSString *const kHKXMineAddressListDataConsigneesTel = @"consigneesTel";
NSString *const kHKXMineAddressListDataDefaultSet = @"defaultSet";
NSString *const kHKXMineAddressListDataAddId = @"addId";
NSString *const kHKXMineAddressListDataConsignees = @"consignees";
NSString *const kHKXMineAddressListDataUId = @"uId";
NSString *const kHKXMineAddressListDataConsigneesAdd = @"consigneesAdd";


@interface HKXMineAddressListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineAddressListData

@synthesize consigneesTel = _consigneesTel;
@synthesize defaultSet = _defaultSet;
@synthesize addId = _addId;
@synthesize consignees = _consignees;
@synthesize uId = _uId;
@synthesize consigneesAdd = _consigneesAdd;


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
            self.consigneesTel = [self objectOrNilForKey:kHKXMineAddressListDataConsigneesTel fromDictionary:dict];
            self.defaultSet = [[self objectOrNilForKey:kHKXMineAddressListDataDefaultSet fromDictionary:dict] doubleValue];
            self.addId = [[self objectOrNilForKey:kHKXMineAddressListDataAddId fromDictionary:dict] doubleValue];
            self.consignees = [self objectOrNilForKey:kHKXMineAddressListDataConsignees fromDictionary:dict];
            self.uId = [[self objectOrNilForKey:kHKXMineAddressListDataUId fromDictionary:dict] doubleValue];
            self.consigneesAdd = [self objectOrNilForKey:kHKXMineAddressListDataConsigneesAdd fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.consigneesTel forKey:kHKXMineAddressListDataConsigneesTel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.defaultSet] forKey:kHKXMineAddressListDataDefaultSet];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addId] forKey:kHKXMineAddressListDataAddId];
    [mutableDict setValue:self.consignees forKey:kHKXMineAddressListDataConsignees];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uId] forKey:kHKXMineAddressListDataUId];
    [mutableDict setValue:self.consigneesAdd forKey:kHKXMineAddressListDataConsigneesAdd];

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

    self.consigneesTel = [aDecoder decodeObjectForKey:kHKXMineAddressListDataConsigneesTel];
    self.defaultSet = [aDecoder decodeDoubleForKey:kHKXMineAddressListDataDefaultSet];
    self.addId = [aDecoder decodeDoubleForKey:kHKXMineAddressListDataAddId];
    self.consignees = [aDecoder decodeObjectForKey:kHKXMineAddressListDataConsignees];
    self.uId = [aDecoder decodeDoubleForKey:kHKXMineAddressListDataUId];
    self.consigneesAdd = [aDecoder decodeObjectForKey:kHKXMineAddressListDataConsigneesAdd];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_consigneesTel forKey:kHKXMineAddressListDataConsigneesTel];
    [aCoder encodeDouble:_defaultSet forKey:kHKXMineAddressListDataDefaultSet];
    [aCoder encodeDouble:_addId forKey:kHKXMineAddressListDataAddId];
    [aCoder encodeObject:_consignees forKey:kHKXMineAddressListDataConsignees];
    [aCoder encodeDouble:_uId forKey:kHKXMineAddressListDataUId];
    [aCoder encodeObject:_consigneesAdd forKey:kHKXMineAddressListDataConsigneesAdd];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineAddressListData *copy = [[HKXMineAddressListData alloc] init];
    
    if (copy) {

        copy.consigneesTel = [self.consigneesTel copyWithZone:zone];
        copy.defaultSet = self.defaultSet;
        copy.addId = self.addId;
        copy.consignees = [self.consignees copyWithZone:zone];
        copy.uId = self.uId;
        copy.consigneesAdd = [self.consigneesAdd copyWithZone:zone];
    }
    
    return copy;
}


@end
