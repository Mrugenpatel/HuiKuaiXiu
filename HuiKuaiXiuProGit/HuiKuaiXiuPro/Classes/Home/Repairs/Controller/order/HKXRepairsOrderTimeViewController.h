//
//  HKXRepairsOrderTimeViewController.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/17.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKXRepairsOrderTimeViewController : UIViewController

@property (nonatomic ,copy)NSString * brandModelId;
@property (nonatomic ,copy)NSString * brandModel;
@property (nonatomic ,copy)NSString * address;
@property (nonatomic ,copy)NSString * contact;
@property (nonatomic ,copy)NSString * telephone;
@property (nonatomic ,copy)NSString * workHours;


@property (nonatomic ,copy)NSString * hydraulicPressure;
@property (nonatomic ,copy)NSString * machineryPart;
@property (nonatomic ,copy)NSString * engine;
@property (nonatomic ,copy)NSString * circuit;
@property (nonatomic ,copy)NSString * maintenance;
@property (nonatomic ,copy)NSString * faultType;
@property (nonatomic ,copy)NSString * faultInfo;
@property (nonatomic ,copy)NSString * imageDataString;

@property (nonatomic ,copy)NSString * lon;
@property (nonatomic ,copy)NSString * lat;

@end
