//
//  HKXMineServeInfoModel.m
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineServeInfoModel.h"
#import "HKXMineServeInfoData.h"


NSString *const kHKXMineServeInfoModelMessage = @"message";
NSString *const kHKXMineServeInfoModelSuccess = @"success";
NSString *const kHKXMineServeInfoModelData = @"data";


@interface HKXMineServeInfoModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineServeInfoModel

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
            self.message = [self objectOrNilForKey:kHKXMineServeInfoModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineServeInfoModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineServeInfoData modelObjectWithDictionary:[dict objectForKey:kHKXMineServeInfoModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineServeInfoModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineServeInfoModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineServeInfoModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineServeInfoModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineServeInfoModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineServeInfoModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineServeInfoModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineServeInfoModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineServeInfoModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineServeInfoModel *copy = [[HKXMineServeInfoModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
