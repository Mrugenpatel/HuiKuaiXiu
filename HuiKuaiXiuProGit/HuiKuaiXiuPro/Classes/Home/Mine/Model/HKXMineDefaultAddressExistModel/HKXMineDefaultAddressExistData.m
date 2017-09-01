//
//  HKXMineDefaultAddressExistData.m
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineDefaultAddressExistData.h"


NSString *const kHKXMineDefaultAddressExistDataConsigneesTel = @"consigneesTel";
NSString *const kHKXMineDefaultAddressExistDataDefaultSet = @"defaultSet";
NSString *const kHKXMineDefaultAddressExistDataAddId = @"addId";
NSString *const kHKXMineDefaultAddressExistDataConsignees = @"consignees";
NSString *const kHKXMineDefaultAddressExistDataUId = @"uId";
NSString *const kHKXMineDefaultAddressExistDataConsigneesAdd = @"consigneesAdd";


@interface HKXMineDefaultAddressExistData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineDefaultAddressExistData

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
            self.consigneesTel = [self objectOrNilForKey:kHKXMineDefaultAddressExistDataConsigneesTel fromDictionary:dict];
            self.defaultSet = [[self objectOrNilForKey:kHKXMineDefaultAddressExistDataDefaultSet fromDictionary:dict] doubleValue];
            self.addId = [[self objectOrNilForKey:kHKXMineDefaultAddressExistDataAddId fromDictionary:dict] doubleValue];
            self.consignees = [self objectOrNilForKey:kHKXMineDefaultAddressExistDataConsignees fromDictionary:dict];
            self.uId = [[self objectOrNilForKey:kHKXMineDefaultAddressExistDataUId fromDictionary:dict] doubleValue];
            self.consigneesAdd = [self objectOrNilForKey:kHKXMineDefaultAddressExistDataConsigneesAdd fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.consigneesTel forKey:kHKXMineDefaultAddressExistDataConsigneesTel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.defaultSet] forKey:kHKXMineDefaultAddressExistDataDefaultSet];
    [mutableDict setValue:[NSNumber numberWithDouble:self.addId] forKey:kHKXMineDefaultAddressExistDataAddId];
    [mutableDict setValue:self.consignees forKey:kHKXMineDefaultAddressExistDataConsignees];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uId] forKey:kHKXMineDefaultAddressExistDataUId];
    [mutableDict setValue:self.consigneesAdd forKey:kHKXMineDefaultAddressExistDataConsigneesAdd];

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

    self.consigneesTel = [aDecoder decodeObjectForKey:kHKXMineDefaultAddressExistDataConsigneesTel];
    self.defaultSet = [aDecoder decodeDoubleForKey:kHKXMineDefaultAddressExistDataDefaultSet];
    self.addId = [aDecoder decodeDoubleForKey:kHKXMineDefaultAddressExistDataAddId];
    self.consignees = [aDecoder decodeObjectForKey:kHKXMineDefaultAddressExistDataConsignees];
    self.uId = [aDecoder decodeDoubleForKey:kHKXMineDefaultAddressExistDataUId];
    self.consigneesAdd = [aDecoder decodeObjectForKey:kHKXMineDefaultAddressExistDataConsigneesAdd];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_consigneesTel forKey:kHKXMineDefaultAddressExistDataConsigneesTel];
    [aCoder encodeDouble:_defaultSet forKey:kHKXMineDefaultAddressExistDataDefaultSet];
    [aCoder encodeDouble:_addId forKey:kHKXMineDefaultAddressExistDataAddId];
    [aCoder encodeObject:_consignees forKey:kHKXMineDefaultAddressExistDataConsignees];
    [aCoder encodeDouble:_uId forKey:kHKXMineDefaultAddressExistDataUId];
    [aCoder encodeObject:_consigneesAdd forKey:kHKXMineDefaultAddressExistDataConsigneesAdd];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineDefaultAddressExistData *copy = [[HKXMineDefaultAddressExistData alloc] init];
    
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
