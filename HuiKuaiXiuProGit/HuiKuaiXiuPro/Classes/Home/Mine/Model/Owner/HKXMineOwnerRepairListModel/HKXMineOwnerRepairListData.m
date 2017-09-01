//
//  HKXMineOwnerRepairListData.m
//
//  Created by   on 2017/8/9
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineOwnerRepairListData.h"


NSString *const kHKXMineOwnerRepairListDataRepairId = @"repairId";
NSString *const kHKXMineOwnerRepairListDataUId = @"uId";
NSString *const kHKXMineOwnerRepairListDataFault = @"fault";
NSString *const kHKXMineOwnerRepairListDataWorkHours = @"workHours";
NSString *const kHKXMineOwnerRepairListDataRepairexplain = @"repairexplain";
NSString *const kHKXMineOwnerRepairListDataContact = @"contact";
NSString *const kHKXMineOwnerRepairListDataFaultInfo = @"faultInfo";
NSString *const kHKXMineOwnerRepairListDataRepairStatus = @"repairStatus";
NSString *const kHKXMineOwnerRepairListDataLongitude = @"longitude";
NSString *const kHKXMineOwnerRepairListDataPicture = @"picture";
NSString *const kHKXMineOwnerRepairListDataLatitude = @"latitude";
NSString *const kHKXMineOwnerRepairListDataCreateDate = @"createDate";
NSString *const kHKXMineOwnerRepairListDataAppointmentTime = @"appointmentTime";
NSString *const kHKXMineOwnerRepairListDataAddress = @"address";
NSString *const kHKXMineOwnerRepairListDataUpdateDate = @"updateDate";
NSString *const kHKXMineOwnerRepairListDataTelephone = @"telephone";
NSString *const kHKXMineOwnerRepairListDataRemarks = @"remarks";
NSString *const kHKXMineOwnerRepairListDataBrandModel = @"brandModel";
NSString *const kHKXMineOwnerRepairListDataMId = @"mId";
NSString *const kHKXMineOwnerRepairListDataProvince = @"province";


@interface HKXMineOwnerRepairListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineOwnerRepairListData

@synthesize repairId = _repairId;
@synthesize uId = _uId;
@synthesize fault = _fault;
@synthesize workHours = _workHours;
@synthesize repairexplain = _repairexplain;
@synthesize contact = _contact;
@synthesize faultInfo = _faultInfo;
@synthesize repairStatus = _repairStatus;
@synthesize longitude = _longitude;
@synthesize picture = _picture;
@synthesize latitude = _latitude;
@synthesize createDate = _createDate;
@synthesize appointmentTime = _appointmentTime;
@synthesize address = _address;
@synthesize updateDate = _updateDate;
@synthesize telephone = _telephone;
@synthesize remarks = _remarks;
@synthesize brandModel = _brandModel;
@synthesize mId = _mId;
@synthesize province = _province;


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
            self.repairId = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataRepairId fromDictionary:dict] doubleValue];
            self.uId = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataUId fromDictionary:dict] doubleValue];
            self.fault = [self objectOrNilForKey:kHKXMineOwnerRepairListDataFault fromDictionary:dict];
            self.workHours = [self objectOrNilForKey:kHKXMineOwnerRepairListDataWorkHours fromDictionary:dict];
            self.repairexplain = [self objectOrNilForKey:kHKXMineOwnerRepairListDataRepairexplain fromDictionary:dict];
            self.contact = [self objectOrNilForKey:kHKXMineOwnerRepairListDataContact fromDictionary:dict];
            self.faultInfo = [self objectOrNilForKey:kHKXMineOwnerRepairListDataFaultInfo fromDictionary:dict];
            self.repairStatus = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataRepairStatus fromDictionary:dict] doubleValue];
            self.longitude = [self objectOrNilForKey:kHKXMineOwnerRepairListDataLongitude fromDictionary:dict];
            self.picture = [self objectOrNilForKey:kHKXMineOwnerRepairListDataPicture fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kHKXMineOwnerRepairListDataLatitude fromDictionary:dict];
            self.createDate = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataCreateDate fromDictionary:dict] doubleValue];
            self.appointmentTime = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataAppointmentTime fromDictionary:dict] doubleValue];
            self.address = [self objectOrNilForKey:kHKXMineOwnerRepairListDataAddress fromDictionary:dict];
            self.updateDate = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataUpdateDate fromDictionary:dict] doubleValue];
            self.telephone = [self objectOrNilForKey:kHKXMineOwnerRepairListDataTelephone fromDictionary:dict];
            self.remarks = [self objectOrNilForKey:kHKXMineOwnerRepairListDataRemarks fromDictionary:dict];
            self.brandModel = [self objectOrNilForKey:kHKXMineOwnerRepairListDataBrandModel fromDictionary:dict];
            self.mId = [[self objectOrNilForKey:kHKXMineOwnerRepairListDataMId fromDictionary:dict] doubleValue];
        self.province = [self objectOrNilForKey:kHKXMineOwnerRepairListDataProvince fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repairId] forKey:kHKXMineOwnerRepairListDataRepairId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uId] forKey:kHKXMineOwnerRepairListDataUId];
    [mutableDict setValue:self.fault forKey:kHKXMineOwnerRepairListDataFault];
    [mutableDict setValue:self.workHours forKey:kHKXMineOwnerRepairListDataWorkHours];
    [mutableDict setValue:self.repairexplain forKey:kHKXMineOwnerRepairListDataRepairexplain];
    [mutableDict setValue:self.contact forKey:kHKXMineOwnerRepairListDataContact];
    [mutableDict setValue:self.faultInfo forKey:kHKXMineOwnerRepairListDataFaultInfo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repairStatus] forKey:kHKXMineOwnerRepairListDataRepairStatus];
    [mutableDict setValue:self.longitude forKey:kHKXMineOwnerRepairListDataLongitude];
    NSMutableArray *tempArrayForPicture = [NSMutableArray array];
    for (NSObject *subArrayObject in self.picture) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPicture addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPicture addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPicture] forKey:kHKXMineOwnerRepairListDataPicture];
    [mutableDict setValue:self.latitude forKey:kHKXMineOwnerRepairListDataLatitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createDate] forKey:kHKXMineOwnerRepairListDataCreateDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.appointmentTime] forKey:kHKXMineOwnerRepairListDataAppointmentTime];
    [mutableDict setValue:self.address forKey:kHKXMineOwnerRepairListDataAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateDate] forKey:kHKXMineOwnerRepairListDataUpdateDate];
    [mutableDict setValue:self.telephone forKey:kHKXMineOwnerRepairListDataTelephone];
    [mutableDict setValue:self.remarks forKey:kHKXMineOwnerRepairListDataRemarks];
    [mutableDict setValue:self.brandModel forKey:kHKXMineOwnerRepairListDataBrandModel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mId] forKey:kHKXMineOwnerRepairListDataMId];
    [mutableDict setValue:self.province forKey:kHKXMineOwnerRepairListDataProvince];

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

    self.repairId = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataRepairId];
    self.uId = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataUId];
    self.fault = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataFault];
    self.workHours = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataWorkHours];
    self.repairexplain = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataRepairexplain];
    self.contact = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataContact];
    self.faultInfo = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataFaultInfo];
    self.repairStatus = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataRepairStatus];
    self.longitude = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataLongitude];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataPicture];
    self.latitude = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataLatitude];
    self.createDate = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataCreateDate];
    self.appointmentTime = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataAppointmentTime];
    self.address = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataAddress];
    self.updateDate = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataUpdateDate];
    self.telephone = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataTelephone];
    self.remarks = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataRemarks];
    self.brandModel = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataBrandModel];
    self.mId = [aDecoder decodeDoubleForKey:kHKXMineOwnerRepairListDataMId];
    self.province = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListDataProvince];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_repairId forKey:kHKXMineOwnerRepairListDataRepairId];
    [aCoder encodeDouble:_uId forKey:kHKXMineOwnerRepairListDataUId];
    [aCoder encodeObject:_fault forKey:kHKXMineOwnerRepairListDataFault];
    [aCoder encodeObject:_workHours forKey:kHKXMineOwnerRepairListDataWorkHours];
    [aCoder encodeObject:_repairexplain forKey:kHKXMineOwnerRepairListDataRepairexplain];
    [aCoder encodeObject:_contact forKey:kHKXMineOwnerRepairListDataContact];
    [aCoder encodeObject:_faultInfo forKey:kHKXMineOwnerRepairListDataFaultInfo];
    [aCoder encodeDouble:_repairStatus forKey:kHKXMineOwnerRepairListDataRepairStatus];
    [aCoder encodeObject:_longitude forKey:kHKXMineOwnerRepairListDataLongitude];
    [aCoder encodeObject:_picture forKey:kHKXMineOwnerRepairListDataPicture];
    [aCoder encodeObject:_latitude forKey:kHKXMineOwnerRepairListDataLatitude];
    [aCoder encodeDouble:_createDate forKey:kHKXMineOwnerRepairListDataCreateDate];
    [aCoder encodeDouble:_appointmentTime forKey:kHKXMineOwnerRepairListDataAppointmentTime];
    [aCoder encodeObject:_address forKey:kHKXMineOwnerRepairListDataAddress];
    [aCoder encodeDouble:_updateDate forKey:kHKXMineOwnerRepairListDataUpdateDate];
    [aCoder encodeObject:_telephone forKey:kHKXMineOwnerRepairListDataTelephone];
    [aCoder encodeObject:_remarks forKey:kHKXMineOwnerRepairListDataRemarks];
    [aCoder encodeObject:_brandModel forKey:kHKXMineOwnerRepairListDataBrandModel];
    [aCoder encodeDouble:_mId forKey:kHKXMineOwnerRepairListDataMId];
    [aCoder encodeObject:_province forKey:kHKXMineOwnerRepairListDataProvince];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineOwnerRepairListData *copy = [[HKXMineOwnerRepairListData alloc] init];
    
    if (copy) {

        copy.repairId = self.repairId;
        copy.uId = self.uId;
        copy.fault = [self.fault copyWithZone:zone];
        copy.workHours = [self.workHours copyWithZone:zone];
        copy.repairexplain = [self.repairexplain copyWithZone:zone];
        copy.contact = [self.contact copyWithZone:zone];
        copy.faultInfo = [self.faultInfo copyWithZone:zone];
        copy.repairStatus = self.repairStatus;
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.picture = [self.picture copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.createDate = self.createDate;
        copy.appointmentTime = self.appointmentTime;
        copy.address = [self.address copyWithZone:zone];
        copy.updateDate = self.updateDate;
        copy.telephone = [self.telephone copyWithZone:zone];
        copy.remarks = [self.remarks copyWithZone:zone];
        copy.brandModel = [self.brandModel copyWithZone:zone];
        copy.mId = self.mId;
        copy.province = [self.province copyWithZone:zone];
    }
    
    return copy;
}


@end
