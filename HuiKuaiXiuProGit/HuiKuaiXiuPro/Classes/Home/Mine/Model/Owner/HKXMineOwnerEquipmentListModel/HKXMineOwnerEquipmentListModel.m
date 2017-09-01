//
//  HKXMineOwnerEquipmentListModel.m
//
//  Created by   on 2017/8/29
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineOwnerEquipmentListModel.h"
#import "HKXMineOwnerEquipmentListData.h"


NSString *const kHKXMineOwnerEquipmentListModelMessage = @"message";
NSString *const kHKXMineOwnerEquipmentListModelSuccess = @"success";
NSString *const kHKXMineOwnerEquipmentListModelData = @"data";


@interface HKXMineOwnerEquipmentListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineOwnerEquipmentListModel

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
            self.message = [self objectOrNilForKey:kHKXMineOwnerEquipmentListModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineOwnerEquipmentListModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXMineOwnerEquipmentListData = [dict objectForKey:kHKXMineOwnerEquipmentListModelData];
    NSMutableArray *parsedHKXMineOwnerEquipmentListData = [NSMutableArray array];
    if ([receivedHKXMineOwnerEquipmentListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineOwnerEquipmentListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineOwnerEquipmentListData addObject:[HKXMineOwnerEquipmentListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineOwnerEquipmentListData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineOwnerEquipmentListData addObject:[HKXMineOwnerEquipmentListData modelObjectWithDictionary:(NSDictionary *)receivedHKXMineOwnerEquipmentListData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXMineOwnerEquipmentListData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineOwnerEquipmentListModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineOwnerEquipmentListModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXMineOwnerEquipmentListModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineOwnerEquipmentListModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineOwnerEquipmentListModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineOwnerEquipmentListModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineOwnerEquipmentListModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineOwnerEquipmentListModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineOwnerEquipmentListModel *copy = [[HKXMineOwnerEquipmentListModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
