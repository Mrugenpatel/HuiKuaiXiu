//
//  HKXMineAddressListModel.h
//
//  Created by   on 2017/9/1
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HKXMineAddressListModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy  ) NSString * message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSArray *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
