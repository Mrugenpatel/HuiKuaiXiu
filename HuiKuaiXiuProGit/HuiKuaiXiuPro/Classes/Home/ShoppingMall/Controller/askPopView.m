//
//  askPopView.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "askPopView.h"
#import "CommonMethod.h"
@interface askPopView (){
    
    UIView * bg ;
}
@end
@implementation askPopView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.showView = [[UIView alloc] init];
        [self addSubview:self.showView];
        self.brandLb = [[UILabel alloc] init];
        self.submitBtn = [[UIButton alloc] init];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.bgView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBg)];
    [self.bgView addGestureRecognizer:tap];
    self.showView.frame = CGRectMake(50 * delegate.autoSizeScaleX, ScreenHeight / 3 - 30 * delegate.autoSizeScaleY, ScreenWidth - 50 * delegate.autoSizeScaleX * 2, 325 * delegate.autoSizeScaleY);
    self.showView.backgroundColor = [UIColor whiteColor];
    
    self.brandLb.frame = CGRectMake(20 * delegate.autoSizeScaleX, 25 * delegate.autoSizeScaleY, CGRectGetWidth(self.showView.frame) - 40 * delegate.autoSizeScaleX, 54 * delegate.autoSizeScaleY);
    self.brandLb.layer.borderWidth = 0.5f;
    self.brandLb.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#666"] CGColor];
    self.brandLb.layer.cornerRadius = 4.0f;
    self.brandLb.font = [UIFont systemFontOfSize:16.0f];
    self.brandLb.numberOfLines = 0;
    [self.showView addSubview:self.brandLb];
    
    UIView * keyBoardLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    UIView * keyBoardLeftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    UIView * keyBoardLeftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    self.nameTf = [[UITextField alloc] initWithFrame:CGRectMake(20 * delegate.autoSizeScaleX, CGRectGetMaxY(self.brandLb.frame) + 6 * delegate.autoSizeScaleY, CGRectGetWidth(self.showView.frame) - 40 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    self.nameTf.placeholder = @"姓名";
    self.nameTf.layer.borderWidth = 0.5f;
    self.nameTf.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#666"] CGColor];
    self.nameTf.layer.cornerRadius = 4.0f;
    self.nameTf.font = [UIFont systemFontOfSize:16.0f];
    self.nameTf.leftView = keyBoardLeftView;
    self.nameTf.leftViewMode = UITextFieldViewModeAlways;
    [self.showView addSubview:self.nameTf];
    
    self.teleTf = [[UITextField alloc] initWithFrame:CGRectMake(20 * delegate.autoSizeScaleX, CGRectGetMaxY(self.nameTf.frame) + 6 * delegate.autoSizeScaleY, CGRectGetWidth(self.showView.frame) - 40 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    self.teleTf.placeholder = @"电话";
    self.teleTf.keyboardType = UIKeyboardTypeNamePhonePad;
    self.teleTf.layer.borderWidth = 0.5f;
    self.teleTf.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#666"] CGColor];
    self.teleTf.layer.cornerRadius = 4.0f;
    self.teleTf.font = [UIFont systemFontOfSize:16.0f];
    self.teleTf.leftView = keyBoardLeftView2;
    self.teleTf.leftViewMode = UITextFieldViewModeAlways;
    [self.showView addSubview:self.teleTf];
    
    self.addressTF = [[UITextField alloc] initWithFrame:CGRectMake(20 * delegate.autoSizeScaleX, CGRectGetMaxY(self.teleTf.frame) + 6 * delegate.autoSizeScaleY, CGRectGetWidth(self.showView.frame) - 40 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY)];
    self.addressTF.placeholder = @"地区";
    self.addressTF.layer.borderWidth = 0.5f;
    self.addressTF.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#666"] CGColor];
    self.addressTF.layer.cornerRadius = 4.0f;
    self.addressTF.font = [UIFont systemFontOfSize:16.0f];
    self.addressTF.leftView = keyBoardLeftView3;
    self.addressTF.leftViewMode = UITextFieldViewModeAlways;
    [self.showView addSubview:self.addressTF];
    
    self.submitBtn.frame = CGRectMake(self.showView.frame.size.width / 2 - 120 * delegate.autoSizeScaleX / 2 , CGRectGetMaxY(self.addressTF.frame) + 31 * delegate.autoSizeScaleY, 120 * delegate.autoSizeScaleX, 44 * delegate.autoSizeScaleY);
    [self.submitBtn setBackgroundColor:[UIColor orangeColor]];
    [self.submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    self.submitBtn.layer.cornerRadius = 4.0f;
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:self.submitBtn];
    
}

- (void)submitClick{
    
    if([self.delegate respondsToSelector:@selector(submitClick)]) {
        
        [self.delegate submitClick];
    }
}

- (void)touchBg{
    
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
