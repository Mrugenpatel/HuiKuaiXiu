//
//  HKXMineServerOrderListModel.m
//
//  Created by   on 2017/8/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineServerOrderListModel.h"
#import "HKXMineServerOrderListData.h"


NSString *const kHKXMineServerOrderListModelMessage = @"message";
NSString *const kHKXMineServerOrderListModelSuccess = @"success";
NSString *const kHKXMineServerOrderListModelData = @"data";


@interface HKXMineServerOrderListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineServerOrderListModel

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
            self.message = [self objectOrNilForKey:kHKXMineServerOrderListModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineServerOrderListModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXMineServerOrderListData = [dict objectForKey:kHKXMineServerOrderListModelData];
    NSMutableArray *parsedHKXMineServerOrderListData = [NSMutableArray array];
    if ([receivedHKXMineServerOrderListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineServerOrderListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineServerOrderListData addObject:[HKXMineServerOrderListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineServerOrderListData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineServerOrderListData addObject:[HKXMineServerOrderListData modelObjectWithDictionary:(NSDictionary *)receivedHKXMineServerOrderListData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXMineServerOrderListData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineServerOrderListModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineServerOrderListModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXMineServerOrderListModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineServerOrderListModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineServerOrderListModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineServerOrderListModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineServerOrderListModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineServerOrderListModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineServerOrderListModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineServerOrderListModel *copy = [[HKXMineServerOrderListModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
