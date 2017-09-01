//
//  myview.m
//  
//
//  Created by daemona on 2017/7/19.
//
//

#import "myview.h"

@implementation myview

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        self.yesBtn = [[UIButton alloc] init];
        [self addSubview:self.yesBtn];
        self.noBtn = [[UIButton alloc] init];
        [self addSubview:self.noBtn];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size=[self.label.text sizeWithAttributes:attrs];
    self.label.frame = CGRectMake(0, 0, size.width, 50);
    self.yesBtn.frame = CGRectMake(self.label.bounds.size.width, 2,50,height);
    self.yesBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.noBtn.frame = CGRectMake(self.label.bounds.size.width + self.yesBtn.bounds.size.width, 2, 50, height);
    self.noBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
