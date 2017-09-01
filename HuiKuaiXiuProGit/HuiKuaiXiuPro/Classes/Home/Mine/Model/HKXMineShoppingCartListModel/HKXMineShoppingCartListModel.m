//
//  HKXMineShoppingCartListModel.m
//
//  Created by   on 2017/8/30
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineShoppingCartListModel.h"
#import "HKXMineShoppingCartListData.h"


NSString *const kHKXMineShoppingCartListModelMessage = @"message";
NSString *const kHKXMineShoppingCartListModelSuccess = @"success";
NSString *const kHKXMineShoppingCartListModelData = @"data";


@interface HKXMineShoppingCartListModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineShoppingCartListModel

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
            self.message = [self objectOrNilForKey:kHKXMineShoppingCartListModelMessage fromDictionary:dict];
            self.success = [[self objectOrNilForKey:kHKXMineShoppingCartListModelSuccess fromDictionary:dict] boolValue];
    NSObject *receivedHKXMineShoppingCartListData = [dict objectForKey:kHKXMineShoppingCartListModelData];
    NSMutableArray *parsedHKXMineShoppingCartListData = [NSMutableArray array];
    if ([receivedHKXMineShoppingCartListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHKXMineShoppingCartListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHKXMineShoppingCartListData addObject:[HKXMineShoppingCartListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHKXMineShoppingCartListData isKindOfClass:[NSDictionary class]]) {
       [parsedHKXMineShoppingCartListData addObject:[HKXMineShoppingCartListData modelObjectWithDictionary:(NSDictionary *)receivedHKXMineShoppingCartListData]];
    }

    self.data = [NSArray arrayWithArray:parsedHKXMineShoppingCartListData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kHKXMineShoppingCartListModelMessage];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kHKXMineShoppingCartListModelSuccess];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kHKXMineShoppingCartListModelData];

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

    self.message = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListModelMessage];
    self.success = [aDecoder decodeBoolForKey:kHKXMineShoppingCartListModelSuccess];
    self.data = [aDecoder decodeObjectForKey:kHKXMineShoppingCartListModelData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kHKXMineShoppingCartListModelMessage];
    [aCoder encodeBool:_success forKey:kHKXMineShoppingCartListModelSuccess];
    [aCoder encodeObject:_data forKey:kHKXMineShoppingCartListModelData];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineShoppingCartListModel *copy = [[HKXMineShoppingCartListModel alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.success = self.success;
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
