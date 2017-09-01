//
//  HKXMineSupplierInqiryListData.m
//
//  Created by   on 2017/8/31
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "HKXMineSupplierInqiryListData.h"
#import "HKXMineSupplierInqiryListPm.h"


NSString *const kHKXMineSupplierInqiryListDataInquiryTel = @"inquiryTel";
NSString *const kHKXMineSupplierInqiryListDataInquiryId = @"inquiryId";
NSString *const kHKXMineSupplierInqiryListDataInquiryAdd = @"inquiryAdd";
NSString *const kHKXMineSupplierInqiryListDataPm = @"pm";
NSString *const kHKXMineSupplierInqiryListDataInquiryName = @"inquiryName";
NSString *const kHKXMineSupplierInqiryListDataMId = @"mId";
NSString *const kHKXMineSupplierInqiryListDataInquiryDate = @"inquiryDate";


@interface HKXMineSupplierInqiryListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HKXMineSupplierInqiryListData

@synthesize inquiryTel = _inquiryTel;
@synthesize inquiryId = _inquiryId;
@synthesize inquiryAdd = _inquiryAdd;
@synthesize pm = _pm;
@synthesize inquiryName = _inquiryName;
@synthesize mId = _mId;
@synthesize inquiryDate = _inquiryDate;


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
            self.inquiryTel = [self objectOrNilForKey:kHKXMineSupplierInqiryListDataInquiryTel fromDictionary:dict];
            self.inquiryId = [[self objectOrNilForKey:kHKXMineSupplierInqiryListDataInquiryId fromDictionary:dict] doubleValue];
            self.inquiryAdd = [self objectOrNilForKey:kHKXMineSupplierInqiryListDataInquiryAdd fromDictionary:dict];
            self.pm = [HKXMineSupplierInqiryListPm modelObjectWithDictionary:[dict objectForKey:kHKXMineSupplierInqiryListDataPm]];
            self.inquiryName = [self objectOrNilForKey:kHKXMineSupplierInqiryListDataInquiryName fromDictionary:dict];
            self.mId = [[self objectOrNilForKey:kHKXMineSupplierInqiryListDataMId fromDictionary:dict] doubleValue];
            self.inquiryDate = [[self objectOrNilForKey:kHKXMineSupplierInqiryListDataInquiryDate fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.inquiryTel forKey:kHKXMineSupplierInqiryListDataInquiryTel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.inquiryId] forKey:kHKXMineSupplierInqiryListDataInquiryId];
    [mutableDict setValue:self.inquiryAdd forKey:kHKXMineSupplierInqiryListDataInquiryAdd];
    [mutableDict setValue:[self.pm dictionaryRepresentation] forKey:kHKXMineSupplierInqiryListDataPm];
    [mutableDict setValue:self.inquiryName forKey:kHKXMineSupplierInqiryListDataInquiryName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mId] forKey:kHKXMineSupplierInqiryListDataMId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.inquiryDate] forKey:kHKXMineSupplierInqiryListDataInquiryDate];

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

    self.inquiryTel = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListDataInquiryTel];
    self.inquiryId = [aDecoder decodeDoubleForKey:kHKXMineSupplierInqiryListDataInquiryId];
    self.inquiryAdd = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListDataInquiryAdd];
    self.pm = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListDataPm];
    self.inquiryName = [aDecoder decodeObjectForKey:kHKXMineSupplierInqiryListDataInquiryName];
    self.mId = [aDecoder decodeDoubleForKey:kHKXMineSupplierInqiryListDataMId];
    self.inquiryDate = [aDecoder decodeDoubleForKey:kHKXMineSupplierInqiryListDataInquiryDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_inquiryTel forKey:kHKXMineSupplierInqiryListDataInquiryTel];
    [aCoder encodeDouble:_inquiryId forKey:kHKXMineSupplierInqiryListDataInquiryId];
    [aCoder encodeObject:_inquiryAdd forKey:kHKXMineSupplierInqiryListDataInquiryAdd];
    [aCoder encodeObject:_pm forKey:kHKXMineSupplierInqiryListDataPm];
    [aCoder encodeObject:_inquiryName forKey:kHKXMineSupplierInqiryListDataInquiryName];
    [aCoder encodeDouble:_mId forKey:kHKXMineSupplierInqiryListDataMId];
    [aCoder encodeDouble:_inquiryDate forKey:kHKXMineSupplierInqiryListDataInquiryDate];
}

- (id)copyWithZone:(NSZone *)zone
{
    HKXMineSupplierInqiryListData *copy = [[HKXMineSupplierInqiryListData alloc] init];
    
    if (copy) {

        copy.inquiryTel = [self.inquiryTel copyWithZone:zone];
        copy.inquiryId = self.inquiryId;
        copy.inquiryAdd = [self.inquiryAdd copyWithZone:zone];
        copy.pm = [self.pm copyWithZone:zone];
        copy.inquiryName = [self.inquiryName copyWithZone:zone];
        copy.mId = self.mId;
        copy.inquiryDate = self.inquiryDate;
    }
    
    return copy;
}


@end
