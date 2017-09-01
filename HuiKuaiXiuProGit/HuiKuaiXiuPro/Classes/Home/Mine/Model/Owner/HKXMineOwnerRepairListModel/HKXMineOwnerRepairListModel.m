//
//  HKXMineOwnerRepairListModel.m
//
//  Created by   on 2017/8/9
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineOwnerRepairListModel.h"
#import "HKXMineOwnerRepairListData.h"


NSString *const kHKXMineOwnerRepairListModelMessage = @"message";
NSString *const kHKXMineOwnerRepairListModelSuccess = @"success";
NSString *const kHKXMineOwnerRepairListModelData = @"data";


@interface HKXMineOwnerRepairListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineOwnerRepairListModel

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
            self.message = [self objectOrNilForKey:kHKXMineOwnerRepairListModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineOwnerRepairListModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXMineOwnerRepairListData = [dict objectForKey:kHKXMineOwnerRepairListModelData];
    NSMutableArray *parsedHKXMineOwnerRepairListData = [NSMutableArray array];
    if ([receivedHKXMineOwnerRepairListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineOwnerRepairListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineOwnerRepairListData addObject:[HKXMineOwnerRepairListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineOwnerRepairListData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineOwnerRepairListData addObject:[HKXMineOwnerRepairListData modelObjectWithDictionary:(NSDictionary *)receivedHKXMineOwnerRepairListData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXMineOwnerRepairListData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineOwnerRepairListModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineOwnerRepairListModelSuccess];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXMineOwnerRepairListModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineOwnerRepairListModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineOwnerRepairListModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineOwnerRepairListModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineOwnerRepairListModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineOwnerRepairListModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineOwnerRepairListModel *copy = [[HKXMineOwnerRepairListModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
