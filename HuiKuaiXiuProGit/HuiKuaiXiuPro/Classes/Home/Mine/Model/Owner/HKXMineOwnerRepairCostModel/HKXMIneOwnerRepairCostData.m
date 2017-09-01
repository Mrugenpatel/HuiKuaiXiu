//
//  HKXMIneOwnerRepairCostData.m
//
//  Created by   on 2017/8/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMIneOwnerRepairCostData.h"


NSString *const kHKXMIneOwnerRepairCostDataPartsCost = @"partsCost";
NSString *const kHKXMIneOwnerRepairCostDataHourCost = @"hourCost";
NSString *const kHKXMIneOwnerRepairCostDataCost = @"cost";


@interface HKXMIneOwnerRepairCostData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMIneOwnerRepairCostData

@synthesize partsCost = _partsCost;
@synthesize hourCost = _hourCost;
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
            self.partsCost = [[self objectOrNilForKey:kHKXMIneOwnerRepairCostDataPartsCost fromDictionary:dict] doubleValue];
            self.hourCost = [[self objectOrNilForKey:kHKXMIneOwnerRepairCostDataHourCost fromDictionary:dict] doubleValue];
            self.cost = [[self objectOrNilForKey:kHKXMIneOwnerRepairCostDataCost fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.partsCost] forKey:kHKXMIneOwnerRepairCostDataPartsCost];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hourCost] forKey:kHKXMIneOwnerRepairCostDataHourCost];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cost] forKey:kHKXMIneOwnerRepairCostDataCost];

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

    self.partsCost = [aDecoder decodeDoubleForKey:kHKXMIneOwnerRepairCostDataPartsCost];
    self.hourCost = [aDecoder decodeDoubleForKey:kHKXMIneOwnerRepairCostDataHourCost];
    self.cost = [aDecoder decodeDoubleForKey:kHKXMIneOwnerRepairCostDataCost];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_partsCost forKey:kHKXMIneOwnerRepairCostDataPartsCost];
    [aCoder encodeDouble:_hourCost forKey:kHKXMIneOwnerRepairCostDataHourCost];
    [aCoder encodeDouble:_cost forKey:kHKXMIneOwnerRepairCostDataCost];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMIneOwnerRepairCostData *copy = [[HKXMIneOwnerRepairCostData alloc] init];
    
    if (copy) {

        copy.partsCost = self.partsCost;
        copy.hourCost = self.hourCost;
        copy.cost = self.cost;
    }
    
    return copy;
}


@end
