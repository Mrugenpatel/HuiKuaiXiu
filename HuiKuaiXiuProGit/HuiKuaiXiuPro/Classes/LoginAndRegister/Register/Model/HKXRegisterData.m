//
//  HKXRegisterData.m
//
//  Created by   on 2017/7/4
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXRegisterData.h"


NSString *const kHKXRegisterDataId = @"id";
NSString *const kHKXRegisterDataUsername = @"username";
NSString *const kHKXRegisterDataRole = @"role";
NSString *const kHKXRegisterDataRecommendCode = @"recommendCode";


@interface HKXRegisterData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXRegisterData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize username = _username;
@synthesize role = _role;
@synthesize recommendCode = _recommendCode;


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
            self.dataIdentifier = [[self objectOrNilForKey:kHKXRegisterDataId fromDictionary:dict] doubleValue];
            self.username = [self objectOrNilForKey:kHKXRegisterDataUsername fromDictionary:dict];
            self.role = [[self objectOrNilForKey:kHKXRegisterDataRole fromDictionary:dict] doubleValue];
        self.recommendCode = [self objectOrNilForKey:kHKXRegisterDataRecommendCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kHKXRegisterDataId];
    [mutableDict setValue:self.username forKey:kHKXRegisterDataUsername];
    [mutableDict setValue:[NSNumber numberWithDouble:self.role] forKey:kHKXRegisterDataRole];
    [mutableDict setValue:self.recommendCode forKey:kHKXRegisterDataRecommendCode];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kHKXRegisterDataId];
    self.username = [aDecoder decodeObjectForKey:kHKXRegisterDataUsername];
    self.role = [aDecoder decodeDoubleForKey:kHKXRegisterDataRole];
    self.recommendCode = [aDecoder decodeObjectForKey:kHKXRegisterDataRecommendCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kHKXRegisterDataId];
    [aCoder encodeObject:_username forKey:kHKXRegisterDataUsername];
    [aCoder encodeDouble:_role forKey:kHKXRegisterDataRole];
    [aCoder encodeObject:_recommendCode forKey:kHKXRegisterDataRecommendCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXRegisterData *copy = [[HKXRegisterData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.username = [self.username copyWithZone:zone];
        copy.role = self.role;
        copy.recommendCode = [self.username copyWithZone:zone];
    }
    
    return copy;
}


@end
