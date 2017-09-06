//
//  HKXMineMyWalletData.h
//
//  Created by   on 2017/9/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineMyWalletData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString *belongBank;
@property (nonatomic, assign) double userBankId;
@property (nonatomic, copy  ) NSString *userName;
@property (nonatomic, copy  ) NSString *userOpenBank;
@property (nonatomic, assign) double uId;
@property (nonatomic, copy  ) NSString *userIdCard;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
