//
//  HKXLoginData.m
//
//  Created by   on 2017/7/4
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXLoginData.h"


NSString *const kHKXLoginDataId = @"id";
NSString *const kHKXLoginDataRole = @"role";


@interface HKXLoginData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXLoginData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize role = _role;


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
            self.dataIdentifier = [[self objectOrNilForKey:kHKXLoginDataId fromDictionary:dict] doubleValue];
            self.role = [[self objectOrNilForKey:kHKXLoginDataRole fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kHKXLoginDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.role] forKey:kHKXLoginDataRole];

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

    if (self)
    {
        self.dataIdentifier = [aDecoder decodeDoubleForKey:kHKXLoginDataId];
        self.role = [aDecoder decodeDoubleForKey:kHKXLoginDataRole];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kHKXLoginDataId];
    [aCoder encodeDouble:_role forKey:kHKXLoginDataRole];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXLoginData *copy = [[HKXLoginData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.role = self.role;
    }
    
    return copy;
}


@end
