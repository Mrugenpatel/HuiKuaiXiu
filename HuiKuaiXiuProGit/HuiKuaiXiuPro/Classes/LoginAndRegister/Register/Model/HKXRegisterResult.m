//
//  HKXRegisterResult.m
//
//  Created by   on 2017/7/4
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXRegisterResult.h"
#import "HKXRegisterData.h"


NSString *const kHKXRegisterResultMessage = @"message";
NSString *const kHKXRegisterResultSuccess = @"success";
NSString *const kHKXRegisterResultData = @"data";


@interface HKXRegisterResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXRegisterResult

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
            self.message = [self objectOrNilForKey:kHKXRegisterResultMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXRegisterResultSuccess fromDictionary:dict] boolValue];
            self.data = [HKXRegisterData modelObjectWithDictionary:[dict objectForKey:kHKXRegisterResultData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXRegisterResultMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXRegisterResultSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXRegisterResultData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXRegisterResultMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXRegisterResultSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXRegisterResultData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXRegisterResultMessage];
    [aCoder encodeBool:_success forKey:kHKXRegisterResultSuccess];
    [aCoder encodeObject:_data forKey:kHKXRegisterResultData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXRegisterResult *copy = [[HKXRegisterResult alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
