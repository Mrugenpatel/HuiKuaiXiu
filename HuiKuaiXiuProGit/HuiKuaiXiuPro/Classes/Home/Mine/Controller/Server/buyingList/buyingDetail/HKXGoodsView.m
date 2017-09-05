//
//  HKXGoodsView.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXGoodsView.h"

#import "CommonMethod.h"

@implementation HKXGoodsView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.goodsImg = [[UIImageView alloc] init];
        [self addSubview:self.goodsImg];
        self.label1 = [[UILabel alloc] init];
        [self addSubview:self.self.label1];
        self.label2 = [[UILabel alloc] init];
        [self addSubview:self.label2];
        self.label3 = [[UILabel alloc] init];
        [self addSubview:self.label3];
        self.label4 = [[UILabel alloc] init];
        [self addSubview:self.label4];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.goodsImg.frame = CGRectMake(30 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX,95 * myDelegate.autoSizeScaleY);
    self.goodsImg.tag = 50005;
    self.goodsImg.image = [UIImage imageNamed:@"滑动视图示例"];
    [self addSubview:self.goodsImg];
    
    self.label1.frame = CGRectMake(CGRectGetMaxX(self.goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 40 * myDelegate.autoSizeScaleY);
    self.label1.numberOfLines = 2;
    
    self.label1.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    
    self.label2.frame = CGRectMake(CGRectGetMaxX(self.goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.label1.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"哈威V30D140液压泵哈威" WithFont:16 * myDelegate.autoSizeScaleX ], 14 * myDelegate.autoSizeScaleX);
    
    self.label2.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    self.label2.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    
    self.label3.frame = CGRectMake(CGRectGetMaxX(self.goodsImg.frame) + 18 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.label2.frame) + 13 * myDelegate.autoSizeScaleY, 110 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX);
    self.label3.textColor = [UIColor redColor];
    
    self.label3.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    
    
    self.label4.frame = CGRectMake(CGRectGetMaxX(self.goodsImg.frame) + 175 * myDelegate.autoSizeScaleX, CGRectGetMaxY(self.label2.frame) + 13 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"数量：2" WithFont:12 * myDelegate.autoSizeScaleX], 12 * myDelegate.autoSizeScaleX);
    self.label4.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    self.label4.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
}

- (void)setGoods:(HKXOrderGoodsModel *)goods{
    
    _goods = goods;
    self.label1.text = goods.goodName;
    self.label2.text = [NSString stringWithFormat:@"产品型号:%@",goods.goodBrand];
    self.label3.text = [NSString stringWithFormat:@"¥%.2f",[goods.goodPrice floatValue]];
    self.label4.text = [NSString stringWithFormat:@"数量:%@",goods.buyNumber];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
