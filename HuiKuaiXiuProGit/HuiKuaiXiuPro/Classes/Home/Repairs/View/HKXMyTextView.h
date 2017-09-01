//
//  HKXMyTextView.h
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKXMyTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
//行间距
@property (nonatomic, assign) CGFloat verticalSpacing;
/**设置最大高度*/
@property (nonatomic, assign) CGFloat maxHeight;
/**设置最小高度*/
@property (nonatomic, assign) CGFloat minHeight;
/**是不是自适应高度，默认为YES*/
@property (nonatomic, assign) BOOL isAutoHeight;

@property (nonatomic, copy) void(^textDidChangedBlock)(NSString * text);
@property (nonatomic, copy) void (^textViewAutoHeight)(CGFloat textHeight);

@end
