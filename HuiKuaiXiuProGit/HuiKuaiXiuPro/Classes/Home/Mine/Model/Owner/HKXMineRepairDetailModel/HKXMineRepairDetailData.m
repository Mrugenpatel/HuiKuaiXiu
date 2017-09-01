//
//  HKXMineRepairDetailData.m
//
//  Created by   on 2017/8/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineRepairDetailData.h"


NSString *const kHKXMineRepairDetailDataRepairId = @"repairId";
NSString *const kHKXMineRepairDetailDataRepairName = @"repairName";
NSString *const kHKXMineRepairDetailDataFault = @"fault";
NSString *const kHKXMineRepairDetailDataHourCost = @"hourCost";
NSString *const kHKXMineRepairDetailDataRepairexplain = @"repairexplain";
NSString *const kHKXMineRepairDetailDataContact = @"contact";
NSString *const kHKXMineRepairDetailDataFaultInfo = @"faultInfo";
NSString *const kHKXMineRepairDetailDataRepairStatus = @"repairStatus";
NSString *const kHKXMineRepairDetailDataPicture = @"picture";
NSString *const kHKXMineRepairDetailDataAddress = @"address";
NSString *const kHKXMineRepairDetailDataUpdateDate = @"updateDate";
NSString *const kHKXMineRepairDetailDataRepairPhone = @"repairPhone";
NSString *const kHKXMineRepairDetailDataTelephone = @"telephone";
NSString *const kHKXMineRepairDetailDataBrandModel = @"brandModel";
NSString *const kHKXMineRepairDetailDataPartsCost = @"partsCost";
NSString *const kHKXMineRepairDetailDataCost = @"cost";


@interface HKXMineRepairDetailData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineRepairDetailData

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
            self.repairId = [[self objectOrNilForKey:kHKXMineRepairDetailDataRepairId fromDictionary:dict] doubleValue];
            self.repairName = [self objectOrNilForKey:kHKXMineRepairDetailDataRepairName fromDictionary:dict];
            self.fault = [self objectOrNilForKey:kHKXMineRepairDetailDataFault fromDictionary:dict];
            self.hourCost = [[self objectOrNilForKey:kHKXMineRepairDetailDataHourCost fromDictionary:dict] doubleValue];
            self.repairexplain = [self objectOrNilForKey:kHKXMineRepairDetailDataRepairexplain fromDictionary:dict];
            self.contact = [self objectOrNilForKey:kHKXMineRepairDetailDataContact fromDictionary:dict];
            self.faultInfo = [self objectOrNilForKey:kHKXMineRepairDetailDataFaultInfo fromDictionary:dict];
            self.repairStatus = [[self objectOrNilForKey:kHKXMineRepairDetailDataRepairStatus fromDictionary:dict] doubleValue];
            self.picture = [self objectOrNilForKey:kHKXMineRepairDetailDataPicture fromDictionary:dict];
            self.address = [self objectOrNilForKey:kHKXMineRepairDetailDataAddress fromDictionary:dict];
            self.updateDate = [[self objectOrNilForKey:kHKXMineRepairDetailDataUpdateDate fromDictionary:dict] doubleValue];
            self.repairPhone = [self objectOrNilForKey:kHKXMineRepairDetailDataRepairPhone fromDictionary:dict];
            self.telephone = [self objectOrNilForKey:kHKXMineRepairDetailDataTelephone fromDictionary:dict];
            self.brandModel = [self objectOrNilForKey:kHKXMineRepairDetailDataBrandModel fromDictionary:dict];
            self.partsCost = [[self objectOrNilForKey:kHKXMineRepairDetailDataPartsCost fromDictionary:dict] doubleValue];
            self.cost = [[self objectOrNilForKey:kHKXMineRepairDetailDataCost fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repairId] forKey:kHKXMineRepairDetailDataRepairId];
    [mutableDict setValue:self.repairName forKey:kHKXMineRepairDetailDataRepairName];
    [mutableDict setValue:self.fault forKey:kHKXMineRepairDetailDataFault];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hourCost] forKey:kHKXMineRepairDetailDataHourCost];
    [mutableDict setValue:self.repairexplain forKey:kHKXMineRepairDetailDataRepairexplain];
    [mutableDict setValue:self.contact forKey:kHKXMineRepairDetailDataContact];
    [mutableDict setValue:self.faultInfo forKey:kHKXMineRepairDetailDataFaultInfo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.repairStatus] forKey:kHKXMineRepairDetailDataRepairStatus];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPicture] forKey:kHKXMineRepairDetailDataPicture];
    [mutableDict setValue:self.address forKey:kHKXMineRepairDetailDataAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateDate] forKey:kHKXMineRepairDetailDataUpdateDate];
    [mutableDict setValue:self.repairPhone forKey:kHKXMineRepairDetailDataRepairPhone];
    [mutableDict setValue:self.telephone forKey:kHKXMineRepairDetailDataTelephone];
    [mutableDict setValue:self.brandModel forKey:kHKXMineRepairDetailDataBrandModel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.partsCost] forKey:kHKXMineRepairDetailDataPartsCost];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cost] forKey:kHKXMineRepairDetailDataCost];

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

    self.repairId = [aDecoder decodeDoubleForKey:kHKXMineRepairDetailDataRepairId];
    self.repairName = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataRepairName];
    self.fault = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataFault];
    self.hourCost = [aDecoder decodeDoubleForKey:kHKXMineRepairDetailDataHourCost];
    self.repairexplain = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataRepairexplain];
    self.contact = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataContact];
    self.faultInfo = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataFaultInfo];
    self.repairStatus = [aDecoder decodeDoubleForKey:kHKXMineRepairDetailDataRepairStatus];
    self.picture = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataPicture];
    self.address = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataAddress];
    self.updateDate = [aDecoder decodeDoubleForKey:kHKXMineRepairDetailDataUpdateDate];
    self.repairPhone = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataRepairPhone];
    self.telephone = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataTelephone];
    self.brandModel = [aDecoder decodeObjectForKey:kHKXMineRepairDetailDataBrandModel];
    self.partsCost = [aDecoder decodeDoubleForKey:kHKXMineRepairDetailDataPartsCost];
    self.cost = [aDecoder decodeDoubleForKey:kHKXMineRepairDetailDataCost];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_repairId forKey:kHKXMineRepairDetailDataRepairId];
    [aCoder encodeObject:_repairName forKey:kHKXMineRepairDetailDataRepairName];
    [aCoder encodeObject:_fault forKey:kHKXMineRepairDetailDataFault];
    [aCoder encodeDouble:_hourCost forKey:kHKXMineRepairDetailDataHourCost];
    [aCoder encodeObject:_repairexplain forKey:kHKXMineRepairDetailDataRepairexplain];
    [aCoder encodeObject:_contact forKey:kHKXMineRepairDetailDataContact];
    [aCoder encodeObject:_faultInfo forKey:kHKXMineRepairDetailDataFaultInfo];
    [aCoder encodeDouble:_repairStatus forKey:kHKXMineRepairDetailDataRepairStatus];
    [aCoder encodeObject:_picture forKey:kHKXMineRepairDetailDataPicture];
    [aCoder encodeObject:_address forKey:kHKXMineRepairDetailDataAddress];
    [aCoder encodeDouble:_updateDate forKey:kHKXMineRepairDetailDataUpdateDate];
    [aCoder encodeObject:_repairPhone forKey:kHKXMineRepairDetailDataRepairPhone];
    [aCoder encodeObject:_telephone forKey:kHKXMineRepairDetailDataTelephone];
    [aCoder encodeObject:_brandModel forKey:kHKXMineRepairDetailDataBrandModel];
    [aCoder encodeDouble:_partsCost forKey:kHKXMineRepairDetailDataPartsCost];
    [aCoder encodeDouble:_cost forKey:kHKXMineRepairDetailDataCost];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineRepairDetailData *copy = [[HKXMineRepairDetailData alloc] init];
    
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
