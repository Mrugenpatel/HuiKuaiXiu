//
//  HKXLoginResult.m
//
//  Created by   on 2017/7/4
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXLoginResult.h"
#import "HKXLoginData.h"


NSString *const kHKXLoginResultMessage = @"message";
NSString *const kHKXLoginResultSuccess = @"success";
NSString *const kHKXLoginResultData = @"data";


@interface HKXLoginResult ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXLoginResult

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
            self.message = [self objectOrNilForKey:kHKXLoginResultMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXLoginResultSuccess fromDictionary:dict] boolValue];
            self.data = [HKXLoginData modelObjectWithDictionary:[dict objectForKey:kHKXLoginResultData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXLoginResultMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXLoginResultSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXLoginResultData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXLoginResultMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXLoginResultSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXLoginResultData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXLoginResultMessage];
    [aCoder encodeBool:_success forKey:kHKXLoginResultSuccess];
    [aCoder encodeObject:_data forKey:kHKXLoginResultData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXLoginResult *copy = [[HKXLoginResult alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
