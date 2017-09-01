//
//  HKXMineServerOrderListData.m
//
//  Created by   on 2017/8/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineServerOrderListData.h"


NSString *const kHKXMineServerOrderListDataRepairId = @"repairId";
NSString *const kHKXMineServerOrderListDataRepairName = @"repairName";
NSString *const kHKXMineServerOrderListDataFault = @"fault";
NSString *const kHKXMineServerOrderListDataHourCost = @"hourCost";
NSString *const kHKXMineServerOrderListDataRepairexplain = @"repairexplain";
NSString *const kHKXMineServerOrderListDataContact = @"contact";
NSString *const kHKXMineServerOrderListDataFaultInfo = @"faultInfo";
NSString *const kHKXMineServerOrderListDataRepairStatus = @"repairStatus";
NSString *const kHKXMineServerOrderListDataPicture = @"picture";
NSString *const kHKXMineServerOrderListDataAddress = @"address";
NSString *const kHKXMineServerOrderListDataUpdateDate = @"updateDate";
NSString *const kHKXMineServerOrderListDataRepairPhone = @"repairPhone";
NSString *const kHKXMineServerOrderListDataTelephone = @"telephone";
NSString *const kHKXMineServerOrderListDataBrandModel = @"brandModel";
NSString *const kHKXMineServerOrderListDataPartsCost = @"partsCost";
NSString *const kHKXMineServerOrderListDataCost = @"cost";


@interface HKXMineServerOrderListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineServerOrderListData

@synthesize repairId = _repairId;
@synthesize repairName = _repairName;
@synthesize fault = _fault;
@synthesize hourCost = _hourCost;
@synthesize repairexplain = _repairexplain;
@synthesize contact = _contact;
@synthesize faultInfo = _faultInfo;
@synthesize repairStatus = _repairStatus;
@synthesize picture = _picture;
@synthesize address = _address;
@synthesize updateDate = _updateDate;
@synthesize repairPhone = _repairPhone;
@synthesize telephone = _telephone;
@synthesize brandModel = _brandModel;
@synthesize partsCost = _partsCost;
@synthesize cost = _cost;


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
            self.repairId = [[self objectOrNilForKey:kHKXMineServerOrderListDataRepairId fromDictionary:dict] doubleValue];
            self.repairName = [self objectOrNilForKey:kHKXMineServerOrderListDataRepairName fromDictionary:dict];
            self.fault = [self objectOrNilForKey:kHKXMineServerOrderListDataFault fromDictionary:dict];
            self.hourCost = [[self objectOrNilForKey:kHKXMineServerOrderListDataHourCost fromDictionary:dict] doubleValue];
            self.repairexplain = [self objectOrNilForKey:kHKXMineServerOrderListDataRepairexplain fromDictionary:dict];
            self.contact = [self objectOrNilForKey:kHKXMineServerOrderListDataContact fromDictionary:dict];
            self.faultInfo = [self objectOrNilForKey:kHKXMineServerOrderListDataFaultInfo fromDictionary:dict];
            self.repairStatus = [[self objectOrNilForKey:kHKXMineServerOrderListDataRepairStatus fromDictionary:dict] doubleValue];
            self.picture = [self objectOrNilForKey:kHKXMineServerOrderListDataPicture fromDictionary:dict];
            self.address = [self objectOrNilForKey:kHKXMineServerOrderListDataAddress fromDictionary:dict];
            self.updateDate = [[self objectOrNilForKey:kHKXMineServerOrderListDataUpdateDate fromDictionary:dict] doubleValue];
            self.repairPhone = [self objectOrNilForKey:kHKXMineServerOrderListDataRepairPhone fromDictionary:dict];
            self.telephone = [self objectOrNilForKey:kHKXMineServerOrderListDataTelephone fromDictionary:dict];
            self.brandModel = [self objectOrNilForKey:kHKXMineServerOrderListDataBrandModel fromDictionary:dict];
            self.partsCost = [[self objectOrNilForKey:kHKXMineServerOrderListDataPartsCost fromDictionary:dict] doubleValue];
            self.cost = [[self objectOrNilForKey:kHKXMineServerOrderListDataCost fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repairId] forKey:kHKXMineServerOrderListDataRepairId];
    [mutableDict setValue:self.repairName forKey:kHKXMineServerOrderListDataRepairName];
    [mutableDict setValue:self.fault forKey:kHKXMineServerOrderListDataFault];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hourCost] forKey:kHKXMineServerOrderListDataHourCost];
    [mutableDict setValue:self.repairexplain forKey:kHKXMineServerOrderListDataRepairexplain];
    [mutableDict setValue:self.contact forKey:kHKXMineServerOrderListDataContact];
    [mutableDict setValue:self.faultInfo forKey:kHKXMineServerOrderListDataFaultInfo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repairStatus] forKey:kHKXMineServerOrderListDataRepairStatus];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPicture] forKey:kHKXMineServerOrderListDataPicture];
    [mutableDict setValue:self.address forKey:kHKXMineServerOrderListDataAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateDate] forKey:kHKXMineServerOrderListDataUpdateDate];
    [mutableDict setValue:self.repairPhone forKey:kHKXMineServerOrderListDataRepairPhone];
    [mutableDict setValue:self.telephone forKey:kHKXMineServerOrderListDataTelephone];
    [mutableDict setValue:self.brandModel forKey:kHKXMineServerOrderListDataBrandModel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.partsCost] forKey:kHKXMineServerOrderListDataPartsCost];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cost] forKey:kHKXMineServerOrderListDataCost];

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

    self.repairId = [aDecoder decodeDoubleForKey:kHKXMineServerOrderListDataRepairId];
    self.repairName = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataRepairName];
    self.fault = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataFault];
    self.hourCost = [aDecoder decodeDoubleForKey:kHKXMineServerOrderListDataHourCost];
    self.repairexplain = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataRepairexplain];
    self.contact = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataContact];
    self.faultInfo = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataFaultInfo];
    self.repairStatus = [aDecoder decodeDoubleForKey:kHKXMineServerOrderListDataRepairStatus];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataPicture];
    self.address = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataAddress];
    self.updateDate = [aDecoder decodeDoubleForKey:kHKXMineServerOrderListDataUpdateDate];
    self.repairPhone = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataRepairPhone];
    self.telephone = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataTelephone];
    self.brandModel = [aDecoder decodeObjectForKey:kHKXMineServerOrderListDataBrandModel];
    self.partsCost = [aDecoder decodeDoubleForKey:kHKXMineServerOrderListDataPartsCost];
    self.cost = [aDecoder decodeDoubleForKey:kHKXMineServerOrderListDataCost];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_repairId forKey:kHKXMineServerOrderListDataRepairId];
    [aCoder encodeObject:_repairName forKey:kHKXMineServerOrderListDataRepairName];
    [aCoder encodeObject:_fault forKey:kHKXMineServerOrderListDataFault];
    [aCoder encodeDouble:_hourCost forKey:kHKXMineServerOrderListDataHourCost];
    [aCoder encodeObject:_repairexplain forKey:kHKXMineServerOrderListDataRepairexplain];
    [aCoder encodeObject:_contact forKey:kHKXMineServerOrderListDataContact];
    [aCoder encodeObject:_faultInfo forKey:kHKXMineServerOrderListDataFaultInfo];
    [aCoder encodeDouble:_repairStatus forKey:kHKXMineServerOrderListDataRepairStatus];
    [aCoder encodeObject:_picture forKey:kHKXMineServerOrderListDataPicture];
    [aCoder encodeObject:_address forKey:kHKXMineServerOrderListDataAddress];
    [aCoder encodeDouble:_updateDate forKey:kHKXMineServerOrderListDataUpdateDate];
    [aCoder encodeObject:_repairPhone forKey:kHKXMineServerOrderListDataRepairPhone];
    [aCoder encodeObject:_telephone forKey:kHKXMineServerOrderListDataTelephone];
    [aCoder encodeObject:_brandModel forKey:kHKXMineServerOrderListDataBrandModel];
    [aCoder encodeDouble:_partsCost forKey:kHKXMineServerOrderListDataPartsCost];
    [aCoder encodeDouble:_cost forKey:kHKXMineServerOrderListDataCost];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineServerOrderListData *copy = [[HKXMineServerOrderListData alloc] init];
    
    if (copy) {

        copy.repairId = self.repairId;
        copy.repairName = [self.repairName copyWithZone:zone];
        copy.fault = [self.fault copyWithZone:zone];
        copy.hourCost = self.hourCost;
        copy.repairexplain = [self.repairexplain copyWithZone:zone];
        copy.contact = [self.contact copyWithZone:zone];
        copy.faultInfo = [self.faultInfo copyWithZone:zone];
        copy.repairStatus = self.repairStatus;
        copy.picture = [self.picture copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.updateDate = self.updateDate;
        copy.repairPhone = [self.repairPhone copyWithZone:zone];
        copy.telephone = [self.telephone copyWithZone:zone];
        copy.brandModel = [self.brandModel copyWithZone:zone];
        copy.partsCost = self.partsCost;
        copy.cost = self.cost;
    }
    
    return copy;
}


@end
