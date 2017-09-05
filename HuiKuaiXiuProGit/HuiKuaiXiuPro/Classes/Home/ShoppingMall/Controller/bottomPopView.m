//
//  bottomPopView.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "bottomPopView.h"

#import "UIImageView+WebCache.h"
#import "addressBookHelper.h"
@interface bottomPopView () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UIView * bg ;
}

@property(nonatomic ,strong)UITableView * companyInfoTableView;//公司信息

@property(nonatomic ,strong)UIButton * addBtn;//加号

@property(nonatomic ,strong)UIButton * deleteBtn;//减号

@end
@implementation bottomPopView


static NSString * const bottomPopViewCellId = @"bottomPopViewCellId";

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.showView = [[UIView alloc] init];
        [self addSubview:self.showView];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    self.bgView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBg)];
    [self.bgView addGestureRecognizer:tap];
    if ([self.mark isEqualToString:@"规格"]) {
        
        self.showView.frame = CGRectMake(0, ScreenHeight / 2 , ScreenWidth, ScreenHeight / 2);
    }else{
        
        self.showView.frame = CGRectMake(0, ScreenHeight / 3 - 20, ScreenWidth, ScreenHeight / 3 * 2);
    }
    
    self.showView.backgroundColor = [UIColor whiteColor];
    if ([self.mark isEqualToString:@"规格"]) {
        
        self.goodsImage = [[UIImageView alloc] init];
        [self addSubview:self.goodsImage];
        self.titleLb = [[UILabel alloc] init];
        [self.showView addSubview:self.titleLb];
        self.goodsName = [[UILabel alloc] init];
        [self.showView addSubview:self.goodsName];
        self.goodsPrice = [[UILabel alloc] init];
        [self.showView addSubview:self.goodsPrice];
        self.goodsStock = [[UILabel alloc] init];
        [self.showView addSubview:self.goodsStock];
        self.goodsNum = [[UILabel alloc] init];
        [self.showView addSubview:self.goodsNum];
        self.chooseGoodsNum = [[UIView alloc] init];
        [self.showView addSubview:self.chooseGoodsNum];
        self.buy = [[UIButton alloc] init];
        [self.showView addSubview:self.buy];
        
    }else{
        
        self.companyInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.showView.frame.size.width, self.showView.frame.size.height) style:UITableViewStylePlain];
        self.companyInfoTableView.delegate = self;
        self.companyInfoTableView.dataSource = self;
        self.companyInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        self.companyInfoTableView.layer.borderWidth = 1;
        //        self.companyInfoTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置列表边框
        [self.companyInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bottomPopViewCellId];
        [self.showView addSubview:self.companyInfoTableView];
    }
    
    
    self.goodsImage.frame =CGRectMake(20, ScreenHeight / 2 - 30, 90, 80);
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.partGoodsModel.picture[0]]] placeholderImage:nil];
    self.titleLb.frame = CGRectMake(ScreenWidth / 2 - (ScreenWidth - self.goodsImage.frame.origin.x - self.goodsImage.frame.size.width) / 2, 0, ScreenWidth - self.goodsImage.frame.origin.x - self.goodsImage.frame.size.width, 30);
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    self.titleLb.text = @"选择规格数量";
    self.titleLb.textColor = [UIColor blackColor];
    self.titleLb.font = [UIFont systemFontOfSize:13];
    self.goodsName.frame = CGRectMake(self.goodsImage.frame.origin.x, 50, ScreenWidth - self.goodsImage.frame.origin.x * 2, 50);
    self.goodsName.text = self.partGoodsModel.basename;
    self.goodsName.numberOfLines = 0;
    self.goodsName.textColor = [UIColor blackColor];
    self.goodsName.font = [UIFont systemFontOfSize:17];
    self.goodsPrice.frame = CGRectMake(self.goodsImage.frame.origin.x, self.goodsName.frame.origin.y + self.goodsName.frame.size.height + 5, ScreenWidth / 2 - self.goodsImage.frame.origin.x * 2, self.goodsName.frame.size.height);
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@",self.partGoodsModel.price];
    self.goodsPrice.textColor = [UIColor redColor];
    self.goodsPrice.font = [UIFont systemFontOfSize:13];
    self.goodsStock.frame = CGRectMake(self.goodsPrice.frame.origin.x + self.goodsPrice.frame.size.width, self.goodsPrice.frame.origin.y, self.goodsPrice.frame.size.width, self.goodsPrice.frame.size.height);
    self.goodsStock.text = [NSString stringWithFormat:@"库存:%@",self.partGoodsModel.stock];
    self.goodsStock.textColor = [UIColor blackColor];
    self.goodsStock.font = [UIFont systemFontOfSize:13];
    self.goodsStock.textAlignment = NSTextAlignmentCenter;
    self.goodsNum.frame = CGRectMake(self.goodsPrice.frame.origin.x, self.goodsPrice.frame.origin.y + self.goodsPrice.frame.size.height, self.goodsPrice.frame.size.width, self.goodsPrice.frame.size.height);
    self.goodsNum.text = @"数量";
    self.goodsNum.textColor = [UIColor blackColor];
    self.goodsNum.font = [UIFont systemFontOfSize:13];
    self.chooseGoodsNum.frame = CGRectMake(self.goodsStock.frame.origin.x,self.goodsStock.frame.origin.y + self.goodsStock.frame.size.height,self.goodsStock.frame.size.width,self.goodsStock.frame.size.height);
    self.buy.frame =CGRectMake(ScreenWidth / 4, self.chooseGoodsNum.frame.origin.y + self.chooseGoodsNum.frame.size.height + 20, ScreenWidth / 2, 44);
    [self.buy setTitle:@"完 成" forState:UIControlStateNormal];
    [self.buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buy setBackgroundColor:[UIColor orangeColor]];
    //self.buy.layer.borderWidth = 1.0f;
    self.buy.layer.borderColor = [[UIColor orangeColor] CGColor];
    self.buy.layer.cornerRadius = 4.0f;
    self.buy.layer.masksToBounds = YES;
    [self.buy addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.mark isEqualToString:@"规格"]) {
        
        [self creatStepView];
        [self creatButton];
    }
    
    
}



//点击立即购买
- (void)buyClick{
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(immedateBuyClick:)]) {
        
        [self.delegate immedateBuyClick:_myfield.text];
    }
}

- (void)touchBg{
    
    [self removeFromSuperview];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bottomPopViewCellId forIndexPath:indexPath];
    
    UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, cell.frame.size.height)];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.textColor = [UIColor darkGrayColor];
    lb.numberOfLines = 0;
    [cell.contentView addSubview:lb];
    
    if (indexPath.row == 0) {
        
        lb.text = [NSString stringWithFormat:@"公司名称:%@",self.companyModel.companyName];
    }else if (indexPath.row == 1){
        
        lb.text =  [NSString stringWithFormat:@"所在地区:%@",self.companyModel.address];
    }else if (indexPath.row == 2){
        
        lb.text =  [NSString stringWithFormat:@"联系人:%@",self.companyModel.realName];
    }else if (indexPath.row == 3){
        
        lb.text =  [NSString stringWithFormat:@"联系电话:%@",self.companyModel.username];
    }else if (indexPath.row == 4){
        
        lb.text = [NSString stringWithFormat:@"注册资本:%@",self.companyModel.registerCapital];
    }else if (indexPath.row == 5){
        
        lb.text =[NSString stringWithFormat:@"成立时间:%@",self.companyModel.establishmentTime];
    }else if (indexPath.row == 6){
        
        lb.text = [NSString stringWithFormat:@"公司主营:%@",self.companyModel.companyMain];
    }else if (indexPath.row == 7){
        
        lb.text = [NSString stringWithFormat:@"%@",self.companyModel.companyIntroduce];
    }else if (indexPath.row == 8){
        
        lb.text = @"www.jiadeshi.com.cn";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.showView.frame.size.height / 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        
        
        bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        bg.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [bg addGestureRecognizer:tap];
        [self addSubview:bg];
        
        UIView * teleView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/6, ScreenHeight / 2 - 50 , ScreenWidth / 3 * 2, 80)];
        teleView.backgroundColor = [UIColor whiteColor];
        [bg addSubview:teleView];
        
        UIButton * callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        callButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, teleView.frame.size.width, teleView.frame.size.height / 2)];
        [callButton setTitle:@"呼叫" forState:UIControlStateNormal];
        [callButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //callButton.layer.cornerRadius = 4.0f;
        callButton.layer.borderWidth = 1.0f;
        callButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [callButton addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
        [teleView addSubview:callButton];
        
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(0,teleView.frame.size.height / 2 - 1, teleView.frame.size.width, teleView.frame.size.height / 2)];
        [addButton setTitle:@"添加到通讯录" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //addButton.layer.cornerRadius = 4.0f;
        addButton.layer.borderWidth = 1.0f;
        addButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [teleView addSubview:addButton];
        
    }else{
        
        [self removeFromSuperview];
        
    }
    
    
}

- (void)remove{
    
    [bg removeFromSuperview];
}
//呼叫
- (void)callClick:(UIButton *)btn{
    
    [bg removeFromSuperview];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.companyModel.username];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//添加到通讯录
- (void)addClick:(UIButton *)btn{
    
    [bg removeFromSuperview];
    [self saveTeleToAddBook];
}

#pragma mark - 创建计数器
-(void)creatStepView{
    _myfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.chooseGoodsNum.frame.size.width, self.chooseGoodsNum.frame.size.height)];
    _myfield.text=@"1";
    //_myfield.backgroundColor=[UIColor blueColor];
    _myfield.delegate=self;
    _myfield.textAlignment=NSTextAlignmentCenter;
    _myfield.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _myfield.layer.borderWidth=0.5f;
    _myfield.layer.cornerRadius=4.0f;
    _myfield.keyboardType=UIKeyboardTypeNumberPad;
    _myfield.borderStyle = UITextBorderStyleRoundedRect;
    [self.chooseGoodsNum addSubview:_myfield];
    
}
-(void)creatButton{
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(0, 0, 30, _myfield.frame.size.height);
    [_addBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_addBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, 0, 30, _myfield.frame.size.height);
    [_deleteBtn setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
    [_deleteBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    _myfield.leftView=_deleteBtn;
    _myfield.rightView=_addBtn;
    _myfield.leftViewMode=UITextFieldViewModeAlways;
    _myfield.rightViewMode=UITextFieldViewModeAlways;
    
}
-(void)addAction:(UIButton *)sender{
    NSString * changeStr = _myfield.text;
    NSInteger minimumNum = 1;
    NSInteger maxNum = 5;
    if ([changeStr integerValue] > 0 || [changeStr integerValue] < maxNum) {
        _myfield.text = [NSString stringWithFormat:@"%ld",[changeStr integerValue]+1];
        
        if ([_myfield.text integerValue] == maxNum) {
            _addBtn.enabled = NO;
        }
        if ([_myfield.text integerValue] > minimumNum) {
            _deleteBtn.enabled = YES;
        }
    }
    
}
-(void)deleteAction:(UIButton *)sender{
    NSString * changeStr = _myfield.text;
    NSInteger minimumNum = 1;
    NSInteger maxNum = 5;
    if ([changeStr integerValue] > 0 || [changeStr integerValue] < maxNum) {
        
        _myfield.text = [NSString stringWithFormat:@"%ld",[changeStr integerValue]-1];
        
        if ([_myfield.text integerValue] == minimumNum) {
            _deleteBtn.enabled = NO;
        }
        if ([_myfield.text integerValue] < maxNum) {
            _addBtn.enabled = YES;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    if ([textField.text integerValue] >= 5) {
        _addBtn.enabled = NO;
    }else{
        _addBtn.enabled = YES;
    }
    if ([textField.text integerValue]<= 1) {
        _deleteBtn.enabled = NO;
    }else{
        _deleteBtn.enabled = YES;
    }if ([textField.text integerValue] > 5) {
        _myfield.text = @"10";
    }
}
//对键盘输入的操作
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_myfield == textField) //
    {
        if ([toBeString integerValue] > 5) { //如果输入框内容大于10则弹出警告
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入的数值不能超过5" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [[self viewController] presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
        
    }
    return YES;
}


//拨打电话
- (void)callTelephpne
{
    //NSString * mobileStr =[NSString stringWithFormat:@"tel:%@",self.dic[@"mobile"]];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobileStr]];
}
//将电话保存到通讯录
- (void)saveTeleToAddBook
{
    NSString *phone = self.companyModel.username;
    
    if ([addressBookHelper existPhone:phone] == ABHelperExistSpecificContact)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:[NSString stringWithFormat:@"手机号码：%@已存在通讯录",phone] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if ([addressBookHelper addContactName:self.companyModel.realName phoneNum:phone withLabel:@"电话"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"添加到通讯录成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        };
    }
    
}
//点击复制按钮
- (void)copyTelephone
{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    //[pasteboard setString:self.dic[@"mobile"]];
}

- (UIViewController*)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
