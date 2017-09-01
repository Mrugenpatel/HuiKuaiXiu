//
//  CustomDropDownBtn.h
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomDropDownBtn;

@protocol CustomDropDownDelegate <NSObject>


- (void)didSelectedOptionInCustomDropDownBtn:(CustomDropDownBtn *)dropDownBtn;

@end

@interface CustomDropDownBtn : UIView

@property (nonatomic , strong) NSMutableArray * array;//需要显示的选项数组
@property (nonatomic , assign , readonly) NSInteger selectedRow;//选择的行数
@property (nonatomic , copy , readonly) NSString * selectedTitle;//选择的标题
@property (nonatomic , weak) id<CustomDropDownDelegate>delegate;
@property (nonatomic, assign) BOOL showPlaceholder; //default is YES.

@end
