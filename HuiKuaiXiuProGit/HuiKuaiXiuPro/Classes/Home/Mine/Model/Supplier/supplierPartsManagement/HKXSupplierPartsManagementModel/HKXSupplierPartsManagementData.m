//
//  HKXSupplierPartsManagementData.m
//
//  Created by   on 2017/7/27
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXSupplierPartsManagementData.h"


NSString *const kHKXSupplierPartsManagementDataCategory = @"category";
NSString *const kHKXSupplierPartsManagementDataDelFlag = @"delFlag";
NSString *const kHKXSupplierPartsManagementDataApplyCareModel = @"applyCareModel";
NSString *const kHKXSupplierPartsManagementDataUpdateBy = @"updateBy";
NSString *const kHKXSupplierPartsManagementDataCreateDate = @"createDate";
NSString *const kHKXSupplierPartsManagementDataPicture = @"picture";
NSString *const kHKXSupplierPartsManagementDataBrand = @"brand";
NSString *const kHKXSupplierPartsManagementDataStock = @"stock";
NSString *const kHKXSupplierPartsManagementDataBasename = @"basename";
NSString *const kHKXSupplierPartsManagementDataPrice = @"price";
NSString *const kHKXSupplierPartsManagementDataAddress = @"address";
NSString *const kHKXSupplierPartsManagementDataIntroduct = @"introduct";
NSString *const kHKXSupplierPartsManagementDataNumber = @"number";
NSString *const kHKXSupplierPartsManagementDataUpdateDate = @"updateDate";
NSString *const kHKXSupplierPartsManagementDataPId = @"pId";
NSString *const kHKXSupplierPartsManagementDataModel = @"model";
NSString *const kHKXSupplierPartsManagementDataStatus = @"status";
NSString *const kHKXSupplierPartsManagementDataMId = @"mId";


@interface HKXSupplierPartsManagementData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXSupplierPartsManagementData

@synthesize category = _category;
@synthesize delFlag = _delFlag;
@synthesize applyCareModel = _applyCareModel;
@synthesize updateBy = _updateBy;
@synthesize createDate = _createDate;
@synthesize picture = _picture;
@synthesize brand = _brand;
@synthesize stock = _stock;
@synthesize basename = _basename;
@synthesize price = _price;
@synthesize address = _address;
@synthesize introduct = _introduct;
@synthesize number = _number;
@synthesize updateDate = _updateDate;
@synthesize pId = _pId;
@synthesize model = _model;
@synthesize status = _status;
@synthesize mId = _mId;


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
            self.category = [self objectOrNilForKey:kHKXSupplierPartsManagementDataCategory fromDictionary:dict];
            self.delFlag = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataDelFlag fromDictionary:dict] doubleValue];
            self.applyCareModel = [self objectOrNilForKey:kHKXSupplierPartsManagementDataApplyCareModel fromDictionary:dict];
            self.updateBy = [self objectOrNilForKey:kHKXSupplierPartsManagementDataUpdateBy fromDictionary:dict];
            self.createDate = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataCreateDate fromDictionary:dict] doubleValue];
            self.picture = [self objectOrNilForKey:kHKXSupplierPartsManagementDataPicture fromDictionary:dict];
            self.brand = [self objectOrNilForKey:kHKXSupplierPartsManagementDataBrand fromDictionary:dict];
            self.stock = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataStock fromDictionary:dict] doubleValue];
            self.basename = [self objectOrNilForKey:kHKXSupplierPartsManagementDataBasename fromDictionary:dict];
            self.price = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataPrice fromDictionary:dict] doubleValue];
            self.address = [self objectOrNilForKey:kHKXSupplierPartsManagementDataAddress fromDictionary:dict];
            self.introduct = [self objectOrNilForKey:kHKXSupplierPartsManagementDataIntroduct fromDictionary:dict];
            self.number = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataNumber fromDictionary:dict] doubleValue];
            self.updateDate = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataUpdateDate fromDictionary:dict] doubleValue];
            self.pId = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataPId fromDictionary:dict] doubleValue];
            self.model = [self objectOrNilForKey:kHKXSupplierPartsManagementDataModel fromDictionary:dict];
            self.status = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataStatus fromDictionary:dict] doubleValue];
            self.mId = [[self objectOrNilForKey:kHKXSupplierPartsManagementDataMId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.category forKey:kHKXSupplierPartsManagementDataCategory];
    [mutableDict setValue:[NSNumber numberWithDouble:self.delFlag] forKey:kHKXSupplierPartsManagementDataDelFlag];
    [mutableDict setValue:self.applyCareModel forKey:kHKXSupplierPartsManagementDataApplyCareModel];
    [mutableDict setValue:self.updateBy forKey:kHKXSupplierPartsManagementDataUpdateBy];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createDate] forKey:kHKXSupplierPartsManagementDataCreateDate];
    [mutableDict setValue:self.picture forKey:kHKXSupplierPartsManagementDataPicture];
    [mutableDict setValue:self.brand forKey:kHKXSupplierPartsManagementDataBrand];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stock] forKey:kHKXSupplierPartsManagementDataStock];
    [mutableDict setValue:self.basename forKey:kHKXSupplierPartsManagementDataBasename];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kHKXSupplierPartsManagementDataPrice];
    [mutableDict setValue:self.address forKey:kHKXSupplierPartsManagementDataAddress];
    [mutableDict setValue:self.introduct forKey:kHKXSupplierPartsManagementDataIntroduct];
    [mutableDict setValue:[NSNumber numberWithDouble:self.number] forKey:kHKXSupplierPartsManagementDataNumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateDate] forKey:kHKXSupplierPartsManagementDataUpdateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pId] forKey:kHKXSupplierPartsManagementDataPId];
    [mutableDict setValue:self.model forKey:kHKXSupplierPartsManagementDataModel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kHKXSupplierPartsManagementDataStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mId] forKey:kHKXSupplierPartsManagementDataMId];

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

    self.category = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataCategory];
    self.delFlag = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataDelFlag];
    self.applyCareModel = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataApplyCareModel];
    self.updateBy = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataUpdateBy];
    self.createDate = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataCreateDate];
    self.picture = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataPicture];
    self.brand = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataBrand];
    self.stock = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataStock];
    self.basename = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataBasename];
    self.price = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataPrice];
    self.address = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataAddress];
    self.introduct = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataIntroduct];
    self.number = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataNumber];
    self.updateDate = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataUpdateDate];
    self.pId = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataPId];
    self.model = [aDecoder decodeObjectForKey:kHKXSupplierPartsManagementDataModel];
    self.status = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataStatus];
    self.mId = [aDecoder decodeDoubleForKey:kHKXSupplierPartsManagementDataMId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_category forKey:kHKXSupplierPartsManagementDataCategory];
    [aCoder encodeDouble:_delFlag forKey:kHKXSupplierPartsManagementDataDelFlag];
    [aCoder encodeObject:_applyCareModel forKey:kHKXSupplierPartsManagementDataApplyCareModel];
    [aCoder encodeObject:_updateBy forKey:kHKXSupplierPartsManagementDataUpdateBy];
    [aCoder encodeDouble:_createDate forKey:kHKXSupplierPartsManagementDataCreateDate];
    [aCoder encodeObject:_picture forKey:kHKXSupplierPartsManagementDataPicture];
    [aCoder encodeObject:_brand forKey:kHKXSupplierPartsManagementDataBrand];
    [aCoder encodeDouble:_stock forKey:kHKXSupplierPartsManagementDataStock];
    [aCoder encodeObject:_basename forKey:kHKXSupplierPartsManagementDataBasename];
    [aCoder encodeDouble:_price forKey:kHKXSupplierPartsManagementDataPrice];
    [aCoder encodeObject:_address forKey:kHKXSupplierPartsManagementDataAddress];
    [aCoder encodeObject:_introduct forKey:kHKXSupplierPartsManagementDataIntroduct];
    [aCoder encodeDouble:_number forKey:kHKXSupplierPartsManagementDataNumber];
    [aCoder encodeDouble:_updateDate forKey:kHKXSupplierPartsManagementDataUpdateDate];
    [aCoder encodeDouble:_pId forKey:kHKXSupplierPartsManagementDataPId];
    [aCoder encodeObject:_model forKey:kHKXSupplierPartsManagementDataModel];
    [aCoder encodeDouble:_status forKey:kHKXSupplierPartsManagementDataStatus];
    [aCoder encodeDouble:_mId forKey:kHKXSupplierPartsManagementDataMId];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXSupplierPartsManagementData *copy = [[HKXSupplierPartsManagementData alloc] init];
    
    if (copy) {

        copy.category = [self.category copyWithZone:zone];
        copy.delFlag = self.delFlag;
        copy.applyCareModel = [self.applyCareModel copyWithZone:zone];
        copy.updateBy = [self.updateBy copyWithZone:zone];
        copy.createDate = self.createDate;
        copy.picture = [self.picture copyWithZone:zone];
        copy.brand = [self.brand copyWithZone:zone];
        copy.stock = self.stock;
        copy.basename = [self.basename copyWithZone:zone];
        copy.price = self.price;
        copy.address = [self.address copyWithZone:zone];
        copy.introduct = [self.introduct copyWithZone:zone];
        copy.number = self.number;
        copy.updateDate = self.updateDate;
        copy.pId = self.pId;
        copy.model = [self.model copyWithZone:zone];
        copy.status = self.status;
        copy.mId = self.mId;
    }
    
    return copy;
}


@end
