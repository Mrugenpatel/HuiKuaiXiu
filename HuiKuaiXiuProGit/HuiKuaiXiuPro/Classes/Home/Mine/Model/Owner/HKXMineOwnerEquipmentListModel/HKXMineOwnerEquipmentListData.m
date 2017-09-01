//
//  HKXMineOwnerEquipmentListData.m
//
//  Created by   on 2017/8/29
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineOwnerEquipmentListData.h"


NSString *const kHKXMineOwnerEquipmentListDataId = @"id";
NSString *const kHKXMineOwnerEquipmentListDataBrand = @"brand";
NSString *const kHKXMineOwnerEquipmentListDataModel = @"model";
NSString *const kHKXMineOwnerEquipmentListDataNameplateNum = @"nameplateNum";
NSString *const kHKXMineOwnerEquipmentListDataCategory = @"category";
NSString *const kHKXMineOwnerEquipmentListDataPicture = @"picture";


@interface HKXMineOwnerEquipmentListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineOwnerEquipmentListData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize brand = _brand;
@synthesize model = _model;
@synthesize nameplateNum = _nameplateNum;
@synthesize category = _category;
@synthesize picture = _picture;


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
            self.dataIdentifier = [[self objectOrNilForKey:kHKXMineOwnerEquipmentListDataId fromDictionary:dict] doubleValue];
            self.brand = [self objectOrNilForKey:kHKXMineOwnerEquipmentListDataBrand fromDictionary:dict];
            self.model = [self objectOrNilForKey:kHKXMineOwnerEquipmentListDataModel fromDictionary:dict];
            self.nameplateNum = [self objectOrNilForKey:kHKXMineOwnerEquipmentListDataNameplateNum fromDictionary:dict];
            self.category = [self objectOrNilForKey:kHKXMineOwnerEquipmentListDataCategory fromDictionary:dict];
            self.picture = [self objectOrNilForKey:kHKXMineOwnerEquipmentListDataPicture fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kHKXMineOwnerEquipmentListDataId];
    [mutableDict setValue:self.brand forKey:kHKXMineOwnerEquipmentListDataBrand];
    [mutableDict setValue:self.model forKey:kHKXMineOwnerEquipmentListDataModel];
    [mutableDict setValue:self.nameplateNum forKey:kHKXMineOwnerEquipmentListDataNameplateNum];
    [mutableDict setValue:self.category forKey:kHKXMineOwnerEquipmentListDataCategory];
    [mutableDict setValue:self.picture forKey:kHKXMineOwnerEquipmentListDataPicture];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kHKXMineOwnerEquipmentListDataId];
    self.brand = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListDataBrand];
    self.model = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListDataModel];
    self.nameplateNum = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListDataNameplateNum];
    self.category = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListDataCategory];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListDataPicture];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kHKXMineOwnerEquipmentListDataId];
    [aCoder encodeObject:_brand forKey:kHKXMineOwnerEquipmentListDataBrand];
    [aCoder encodeObject:_model forKey:kHKXMineOwnerEquipmentListDataModel];
    [aCoder encodeObject:_nameplateNum forKey:kHKXMineOwnerEquipmentListDataNameplateNum];
    [aCoder encodeObject:_category forKey:kHKXMineOwnerEquipmentListDataCategory];
    [aCoder encodeObject:_picture forKey:kHKXMineOwnerEquipmentListDataPicture];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineOwnerEquipmentListData *copy = [[HKXMineOwnerEquipmentListData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.brand = [self.brand copyWithZone:zone];
        copy.model = [self.model copyWithZone:zone];
        copy.nameplateNum = [self.nameplateNum copyWithZone:zone];
        copy.category = [self.category copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
    }
    
    return copy;
}


@end
