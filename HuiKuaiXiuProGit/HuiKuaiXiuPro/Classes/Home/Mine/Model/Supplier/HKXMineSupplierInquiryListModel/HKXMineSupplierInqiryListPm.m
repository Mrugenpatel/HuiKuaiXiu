//
//  HKXMineSupplierInqiryListPm.m
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineSupplierInqiryListPm.h"


NSString *const kHKXMineSupplierInqiryListPmModelnum = @"modelnum";
NSString *const kHKXMineSupplierInqiryListPmBrand = @"brand";
NSString *const kHKXMineSupplierInqiryListPmParameter = @"parameter";
NSString *const kHKXMineSupplierInqiryListPmType = @"type";
NSString *const kHKXMineSuppilerInqiryListPmPicture = @"picture";


@interface HKXMineSupplierInqiryListPm ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineSupplierInqiryListPm

@synthesize modelnum = _modelnum;
@synthesize brand = _brand;
@synthesize parameter = _parameter;
@synthesize type = _type;
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
            self.modelnum = [self objectOrNilForKey:kHKXMineSupplierInqiryListPmModelnum fromDictionary:dict];
            self.brand = [self objectOrNilForKey:kHKXMineSupplierInqiryListPmBrand fromDictionary:dict];
            self.parameter = [self objectOrNilForKey:kHKXMineSupplierInqiryListPmParameter fromDictionary:dict];
            self.type = [self objectOrNilForKey:kHKXMineSupplierInqiryListPmType fromDictionary:dict];
        self.picture = [self objectOrNilForKey:kHKXMineSuppilerInqiryListPmPicture fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.modelnum forKey:kHKXMineSupplierInqiryListPmModelnum];
    [mutableDict setValue:self.brand forKey:kHKXMineSupplierInqiryListPmBrand];
    [mutableDict setValue:self.parameter forKey:kHKXMineSupplierInqiryListPmParameter];
    [mutableDict setValue:self.type forKey:kHKXMineSupplierInqiryListPmType];
    [mutableDict setValue:self.picture forKey:kHKXMineSuppilerInqiryListPmPicture];

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

    self.modelnum = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListPmModelnum];
    self.brand = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListPmBrand];
    self.parameter = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListPmParameter];
    self.type = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListPmType];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineSuppilerInqiryListPmPicture];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_modelnum forKey:kHKXMineSupplierInqiryListPmModelnum];
    [aCoder encodeObject:_brand forKey:kHKXMineSupplierInqiryListPmBrand];
    [aCoder encodeObject:_parameter forKey:kHKXMineSupplierInqiryListPmParameter];
    [aCoder encodeObject:_type forKey:kHKXMineSupplierInqiryListPmType];
    [aCoder encodeObject:_picture forKey:kHKXMineSuppilerInqiryListPmPicture];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineSupplierInqiryListPm *copy = [[HKXMineSupplierInqiryListPm alloc] init];
    
    if (copy) {

        copy.modelnum = [self.modelnum copyWithZone:zone];
        copy.brand = [self.brand copyWithZone:zone];
        copy.parameter = [self.parameter copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
    }
    
    return copy;
}


@end
