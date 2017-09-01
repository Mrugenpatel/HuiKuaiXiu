//
//  HKXUserVertificationCodeResultModel.m
//
//  Created by   on 2017/7/21
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXUserVertificationCodeResultModel.h"
#import "HKXUserVertificationCodeData.h"


NSString *const kHKXUserVertificationCodeResultModelMessage = @"message";
NSString *const kHKXUserVertificationCodeResultModelSuccess = @"success";
NSString *const kHKXUserVertificationCodeResultModelData = @"data";


@interface HKXUserVertificationCodeResultModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXUserVertificationCodeResultModel

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
            self.message = [self objectOrNilForKey:kHKXUserVertificationCodeResultModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXUserVertificationCodeResultModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXUserVertificationCodeData modelObjectWithDictionary:[dict objectForKey:kHKXUserVertificationCodeResultModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXUserVertificationCodeResultModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXUserVertificationCodeResultModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXUserVertificationCodeResultModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXUserVertificationCodeResultModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXUserVertificationCodeResultModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXUserVertificationCodeResultModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXUserVertificationCodeResultModelMessage];
    [aCoder encodeBool:_success forKey:kHKXUserVertificationCodeResultModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXUserVertificationCodeResultModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXUserVertificationCodeResultModel *copy = [[HKXUserVertificationCodeResultModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
