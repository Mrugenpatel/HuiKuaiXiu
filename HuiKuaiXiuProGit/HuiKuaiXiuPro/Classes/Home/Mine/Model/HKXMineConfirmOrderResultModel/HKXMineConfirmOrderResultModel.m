//
//  HKXMineConfirmOrderResultModel.m
//
//  Created by   on 2017/9/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineConfirmOrderResultModel.h"


NSString *const kHKXMineConfirmOrderResultModelMessage = @"message";
NSString *const kHKXMineConfirmOrderResultModelSuccess = @"success";
NSString *const kHKXMineConfirmOrderResultModelData = @"data";


@interface HKXMineConfirmOrderResultModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineConfirmOrderResultModel

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
            self.message = [self objectOrNilForKey:kHKXMineConfirmOrderResultModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineConfirmOrderResultModelSuccess fromDictionary:dict] boolValue];
            self.data = [[self objectOrNilForKey:kHKXMineConfirmOrderResultModelData fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineConfirmOrderResultModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineConfirmOrderResultModelSuccess];
    [mutableDict setValue:[NSNumber numberWithDouble:self.data] forKey:kHKXMineConfirmOrderResultModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineConfirmOrderResultModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineConfirmOrderResultModelSuccess];
    self.data = [aDecoder decodeDoubleForKey:kHKXMineConfirmOrderResultModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineConfirmOrderResultModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineConfirmOrderResultModelSuccess];
    [aCoder encodeDouble:_data forKey:kHKXMineConfirmOrderResultModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineConfirmOrderResultModel *copy = [[HKXMineConfirmOrderResultModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = self.data;
    }
    
    return copy;
}


@end
