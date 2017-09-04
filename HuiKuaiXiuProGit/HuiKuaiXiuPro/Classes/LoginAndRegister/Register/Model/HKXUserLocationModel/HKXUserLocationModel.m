//
//  HKXUserLocationModel.m
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXUserLocationModel.h"
#import "HKXUserLocationData.h"


NSString *const kHKXUserLocationModelMessage = @"message";
NSString *const kHKXUserLocationModelSuccess = @"success";
NSString *const kHKXUserLocationModelData = @"data";


@interface HKXUserLocationModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXUserLocationModel

@synthesize message = _message;
@synthesize success = _success;
@synthesize data = _data;


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
            self.message = [self objectOrNilForKey:kHKXUserLocationModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXUserLocationModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXUserLocationData modelObjectWithDictionary:[dict objectForKey:kHKXUserLocationModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXUserLocationModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXUserLocationModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXUserLocationModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXUserLocationModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXUserLocationModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXUserLocationModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXUserLocationModelMessage];
    [aCoder encodeBool:_success forKey:kHKXUserLocationModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXUserLocationModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXUserLocationModel *copy = [[HKXUserLocationModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end