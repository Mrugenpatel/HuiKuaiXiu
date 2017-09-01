//
//  HKXMineDefaultAddressExistModel.m
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineDefaultAddressExistModel.h"
#import "HKXMineDefaultAddressExistData.h"


NSString *const kHKXMineDefaultAddressExistModelMessage = @"message";
NSString *const kHKXMineDefaultAddressExistModelSuccess = @"success";
NSString *const kHKXMineDefaultAddressExistModelData = @"data";


@interface HKXMineDefaultAddressExistModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineDefaultAddressExistModel

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
            self.message = [self objectOrNilForKey:kHKXMineDefaultAddressExistModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineDefaultAddressExistModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineDefaultAddressExistData modelObjectWithDictionary:[dict objectForKey:kHKXMineDefaultAddressExistModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineDefaultAddressExistModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineDefaultAddressExistModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineDefaultAddressExistModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineDefaultAddressExistModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineDefaultAddressExistModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineDefaultAddressExistModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineDefaultAddressExistModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineDefaultAddressExistModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineDefaultAddressExistModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineDefaultAddressExistModel *copy = [[HKXMineDefaultAddressExistModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
