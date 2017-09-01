//
//  HKXMineSupplierInfoData.h
//
//  Created by   on 2017/7/25
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineSupplierInfoData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) int role;
@property (nonatomic, copy  ) NSString *realName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy  ) NSString *inviteCode;
@property (nonatomic, copy  ) NSString *recommendCode;
@property (nonatomic, assign) int       perfectInfo;




+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
