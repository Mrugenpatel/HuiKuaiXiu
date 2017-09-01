//
//  HKXUserVertificationCodeData.m
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXUserVertificationCodeData.h"


NSString *const kHKXUserVertificationCodeDataNumber = @"number";
NSString *const kHKXUserVertificationCodeDataStartTime = @"startTime";
NSString *const kHKXUserVertificationCodeDataOutTime = @"outTime";


@interface HKXUserVertificationCodeData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXUserVertificationCodeData

@synthesize number = _number;
@synthesize startTime = _startTime;
@synthesize outTime = _outTime;


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
            self.number = [self objectOrNilForKey:kHKXUserVertificationCodeDataNumber fromDictionary:dict];
            self.startTime = [[self objectOrNilForKey:kHKXUserVertificationCodeDataStartTime fromDictionary:dict] doubleValue];
            self.outTime = [[self objectOrNilForKey:kHKXUserVertificationCodeDataOutTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.number forKey:kHKXUserVertificationCodeDataNumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.startTime] forKey:kHKXUserVertificationCodeDataStartTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.outTime] forKey:kHKXUserVertificationCodeDataOutTime];

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

    self.number = [aDecoder decodeObjectForKey:kHKXUserVertificationCodeDataNumber];
    self.startTime = [aDecoder decodeDoubleForKey:kHKXUserVertificationCodeDataStartTime];
    self.outTime = [aDecoder decodeDoubleForKey:kHKXUserVertificationCodeDataOutTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_number forKey:kHKXUserVertificationCodeDataNumber];
    [aCoder encodeDouble:_startTime forKey:kHKXUserVertificationCodeDataStartTime];
    [aCoder encodeDouble:_outTime forKey:kHKXUserVertificationCodeDataOutTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXUserVertificationCodeData *copy = [[HKXUserVertificationCodeData alloc] init];
    
    if (copy) {

        copy.number = [self.number copyWithZone:zone];
        copy.startTime = self.startTime;
        copy.outTime = self.outTime;
    }
    
    return copy;
}


@end
