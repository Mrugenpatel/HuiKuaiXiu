//
//  AppDelegate.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

