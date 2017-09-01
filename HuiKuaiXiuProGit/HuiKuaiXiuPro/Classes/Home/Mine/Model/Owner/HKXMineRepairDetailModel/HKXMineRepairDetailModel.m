//
//  HKXMineRepairDetailModel.m
//
//  Created by   on 2017/8/11
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineRepairDetailModel.h"
#import "HKXMineRepairDetailData.h"


NSString *const kHKXMineRepairDetailModelMessage = @"message";
NSString *const kHKXMineRepairDetailModelSuccess = @"success";
NSString *const kHKXMineRepairDetailModelData = @"data";


@interface HKXMineRepairDetailModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineRepairDetailModel

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
            self.message = [self objectOrNilForKey:kHKXMineRepairDetailModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineRepairDetailModelSuccess fromDictionary:dict] boolValue];
            self.data = [HKXMineRepairDetailData modelObjectWithDictionary:[dict objectForKey:kHKXMineRepairDetailModelData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineRepairDetailModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineRepairDetailModelSuccess];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHKXMineRepairDetailModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineRepairDetailModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineRepairDetailModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineRepairDetailModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineRepairDetailModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineRepairDetailModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineRepairDetailModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineRepairDetailModel *copy = [[HKXMineRepairDetailModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
