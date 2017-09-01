//
//  JGDownListMenuCell.m
//  JGDownListMenu
//
//  Created by 郭军 on 2017/3/18.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "JGDownListMenuCell.h"

@implementation JGDownListMenuCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
   
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,80, self.frame.size.height - 1)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.numberOfLines = 0;
    titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLbl = titleLbl;
    [self addSubview:titleLbl];
    
//    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 1, 121, 1)];
//    bottomLine.backgroundColor = [UIColor blueColor];
//    bottomLine.highlightedTextColor = [UIColor redColor];
//    [self addSubview:bottomLine];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
