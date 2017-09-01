//
//  HKXSupplierEquipmentManagementData.m
//
//  Created by   on 2017/7/28
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXSupplierEquipmentManagementData.h"


NSString *const kHKXSupplierEquipmentManagementDataState = @"state";
NSString *const kHKXSupplierEquipmentManagementDataCompname = @"compname";
NSString *const kHKXSupplierEquipmentManagementDataPmaId = @"pmaId";
NSString *const kHKXSupplierEquipmentManagementDataCreateBy = @"createBy";
NSString *const kHKXSupplierEquipmentManagementDataUpdateBy = @"updateBy";
NSString *const kHKXSupplierEquipmentManagementDataCreateDate = @"createDate";
NSString *const kHKXSupplierEquipmentManagementDataBrand = @"brand";
NSString *const kHKXSupplierEquipmentManagementDataPicture = @"picture";
NSString *const kHKXSupplierEquipmentManagementDataType = @"type";
NSString *const kHKXSupplierEquipmentManagementDataParameter = @"parameter";
NSString *const kHKXSupplierEquipmentManagementDataBewrite = @"bewrite";
NSString *const kHKXSupplierEquipmentManagementDataUpdateDate = @"updateDate";
NSString *const kHKXSupplierEquipmentManagementDataModelnum = @"modelnum";
NSString *const kHKXSupplierEquipmentManagementDataRemarks = @"remarks";
NSString *const kHKXSupplierEquipmentManagementDataMId = @"mId";


@interface HKXSupplierEquipmentManagementData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXSupplierEquipmentManagementData

@synthesize state = _state;
@synthesize compname = _compname;
@synthesize pmaId = _pmaId;
@synthesize createBy = _createBy;
@synthesize updateBy = _updateBy;
@synthesize createDate = _createDate;
@synthesize brand = _brand;
@synthesize picture = _picture;
@synthesize type = _type;
@synthesize parameter = _parameter;
@synthesize bewrite = _bewrite;
@synthesize updateDate = _updateDate;
@synthesize modelnum = _modelnum;
@synthesize remarks = _remarks;
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
            self.state = [[self objectOrNilForKey:kHKXSupplierEquipmentManagementDataState fromDictionary:dict] doubleValue];
            self.compname = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataCompname fromDictionary:dict];
            self.pmaId = [[self objectOrNilForKey:kHKXSupplierEquipmentManagementDataPmaId fromDictionary:dict] doubleValue];
            self.createBy = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataCreateBy fromDictionary:dict];
            self.updateBy = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataUpdateBy fromDictionary:dict];
            self.createDate = [[self objectOrNilForKey:kHKXSupplierEquipmentManagementDataCreateDate fromDictionary:dict] doubleValue];
            self.brand = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataBrand fromDictionary:dict];
            self.picture = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataPicture fromDictionary:dict];
            self.type = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataType fromDictionary:dict];
            self.parameter = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataParameter fromDictionary:dict];
            self.bewrite = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataBewrite fromDictionary:dict];
            self.updateDate = [[self objectOrNilForKey:kHKXSupplierEquipmentManagementDataUpdateDate fromDictionary:dict] doubleValue];
            self.modelnum = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataModelnum fromDictionary:dict];
            self.remarks = [self objectOrNilForKey:kHKXSupplierEquipmentManagementDataRemarks fromDictionary:dict];
            self.mId = [[self objectOrNilForKey:kHKXSupplierEquipmentManagementDataMId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.state] forKey:kHKXSupplierEquipmentManagementDataState];
    [mutableDict setValue:self.compname forKey:kHKXSupplierEquipmentManagementDataCompname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pmaId] forKey:kHKXSupplierEquipmentManagementDataPmaId];
    [mutableDict setValue:self.createBy forKey:kHKXSupplierEquipmentManagementDataCreateBy];
    [mutableDict setValue:self.updateBy forKey:kHKXSupplierEquipmentManagementDataUpdateBy];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createDate] forKey:kHKXSupplierEquipmentManagementDataCreateDate];
    [mutableDict setValue:self.brand forKey:kHKXSupplierEquipmentManagementDataBrand];
    [mutableDict setValue:self.picture forKey:kHKXSupplierEquipmentManagementDataPicture];
    [mutableDict setValue:self.type forKey:kHKXSupplierEquipmentManagementDataType];
    [mutableDict setValue:self.parameter forKey:kHKXSupplierEquipmentManagementDataParameter];
    [mutableDict setValue:self.bewrite forKey:kHKXSupplierEquipmentManagementDataBewrite];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateDate] forKey:kHKXSupplierEquipmentManagementDataUpdateDate];
    [mutableDict setValue:self.modelnum forKey:kHKXSupplierEquipmentManagementDataModelnum];
    [mutableDict setValue:self.remarks forKey:kHKXSupplierEquipmentManagementDataRemarks];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mId] forKey:kHKXSupplierEquipmentManagementDataMId];

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

    self.state = [aDecoder decodeDoubleForKey:kHKXSupplierEquipmentManagementDataState];
    self.compname = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataCompname];
    self.pmaId = [aDecoder decodeDoubleForKey:kHKXSupplierEquipmentManagementDataPmaId];
    self.createBy = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataCreateBy];
    self.updateBy = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataUpdateBy];
    self.createDate = [aDecoder decodeDoubleForKey:kHKXSupplierEquipmentManagementDataCreateDate];
    self.brand = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataBrand];
    self.picture = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataPicture];
    self.type = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataType];
    self.parameter = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataParameter];
    self.bewrite = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataBewrite];
    self.updateDate = [aDecoder decodeDoubleForKey:kHKXSupplierEquipmentManagementDataUpdateDate];
    self.modelnum = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataModelnum];
    self.remarks = [aDecoder decodeObjectForKey:kHKXSupplierEquipmentManagementDataRemarks];
    self.mId = [aDecoder decodeDoubleForKey:kHKXSupplierEquipmentManagementDataMId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_state forKey:kHKXSupplierEquipmentManagementDataState];
    [aCoder encodeObject:_compname forKey:kHKXSupplierEquipmentManagementDataCompname];
    [aCoder encodeDouble:_pmaId forKey:kHKXSupplierEquipmentManagementDataPmaId];
    [aCoder encodeObject:_createBy forKey:kHKXSupplierEquipmentManagementDataCreateBy];
    [aCoder encodeObject:_updateBy forKey:kHKXSupplierEquipmentManagementDataUpdateBy];
    [aCoder encodeDouble:_createDate forKey:kHKXSupplierEquipmentManagementDataCreateDate];
    [aCoder encodeObject:_brand forKey:kHKXSupplierEquipmentManagementDataBrand];
    [aCoder encodeObject:_picture forKey:kHKXSupplierEquipmentManagementDataPicture];
    [aCoder encodeObject:_type forKey:kHKXSupplierEquipmentManagementDataType];
    [aCoder encodeObject:_parameter forKey:kHKXSupplierEquipmentManagementDataParameter];
    [aCoder encodeObject:_bewrite forKey:kHKXSupplierEquipmentManagementDataBewrite];
    [aCoder encodeDouble:_updateDate forKey:kHKXSupplierEquipmentManagementDataUpdateDate];
    [aCoder encodeObject:_modelnum forKey:kHKXSupplierEquipmentManagementDataModelnum];
    [aCoder encodeObject:_remarks forKey:kHKXSupplierEquipmentManagementDataRemarks];
    [aCoder encodeDouble:_mId forKey:kHKXSupplierEquipmentManagementDataMId];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXSupplierEquipmentManagementData *copy = [[HKXSupplierEquipmentManagementData alloc] init];
    
    if (copy) {

        copy.state = self.state;
        copy.compname = [self.compname copyWithZone:zone];
        copy.pmaId = self.pmaId;
        copy.createBy = [self.createBy copyWithZone:zone];
        copy.updateBy = [self.updateBy copyWithZone:zone];
        copy.createDate = self.createDate;
        copy.brand = [self.brand copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.parameter = [self.parameter copyWithZone:zone];
        copy.bewrite = [self.bewrite copyWithZone:zone];
        copy.updateDate = self.updateDate;
        copy.modelnum = [self.modelnum copyWithZone:zone];
        copy.remarks = [self.remarks copyWithZone:zone];
        copy.mId = self.mId;
    }
    
    return copy;
}


@end
