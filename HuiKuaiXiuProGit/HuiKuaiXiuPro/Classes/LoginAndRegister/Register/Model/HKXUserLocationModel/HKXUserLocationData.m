//
//  HKXUserLocationData.m
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXUserLocationData.h"


NSString *const kHKXUserLocationDataRegion = @"region";
NSString *const kHKXUserLocationDataProvince = @"province";
NSString *const kHKXUserLocationDataCity = @"city";


@interface HKXUserLocationData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXUserLocationData

@synthesize region = _region;
@synthesize province = _province;
@synthesize city = _city;


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
            self.region = [self objectOrNilForKey:kHKXUserLocationDataRegion fromDictionary:dict];
            self.province = [self objectOrNilForKey:kHKXUserLocationDataProvince fromDictionary:dict];
            self.city = [self objectOrNilForKey:kHKXUserLocationDataCity fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.region forKey:kHKXUserLocationDataRegion];
    [mutableDict setValue:self.province forKey:kHKXUserLocationDataProvince];
    [mutableDict setValue:self.city forKey:kHKXUserLocationDataCity];

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

    self.region = [aDecoder decodeObjectForKey:kHKXUserLocationDataRegion];
    self.province = [aDecoder decodeObjectForKey:kHKXUserLocationDataProvince];
    self.city = [aDecoder decodeObjectForKey:kHKXUserLocationDataCity];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_region forKey:kHKXUserLocationDataRegion];
    [aCoder encodeObject:_province forKey:kHKXUserLocationDataProvince];
    [aCoder encodeObject:_city forKey:kHKXUserLocationDataCity];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXUserLocationData *copy = [[HKXUserLocationData alloc] init];
    
    if (copy) {

        copy.region = [self.region copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
    }
    
    return copy;
}


@end
