//
//  requireLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "requireLeaseDetailViewController.h"
#import "requireLeaseDetailTableViewCell.h"
#import "alertView.h"
#import "CommonMethod.h"
@interface requireLeaseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray * ar ;//cell表格
    UITableView * requireLeaseTableView;
    
}

@end

@implementation requireLeaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"求租详情";
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    ar = [[NSArray alloc] initWithObjects:@"设备类型",@"品牌", @"型号",@"吨位",@"设备所在地",@"工况情况",@"联系人",@"电话",nil];
    _type = [self nullToNil:_type];
    _brand = [self nullToNil:_brand];
    _model = [self nullToNil:_model];
    _size = [self nullToNil:_size];
    _address = [self nullToNil:_address];
    _workcontext = [self nullToNil:_workcontext];
    _contact = [self nullToNil:_contact];
    _phone = [self nullToNil:_phone];
    _mid = [self nullToNil:_mid];
    [self createUI];
   
    
   
}

- (NSString *)nullToNil:(NSString *)str{
    
    if ([str isKindOfClass:[NSNull class]]) {
        
        str = @"";
    }
    return str;
}
- (void)createUI{
    
     AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    
    requireLeaseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69 , ScreenWidth, ScreenHeight - 64 - 5 - 100) style:UITableViewStylePlain];
    requireLeaseTableView.delegate = self;
    requireLeaseTableView.dataSource = self;
    requireLeaseTableView.scrollEnabled = NO;
    requireLeaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:requireLeaseTableView];
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(20, ScreenHeight - 70, ScreenWidth / 2 -20 * 2, 44 * myDelegate.autoSizeScaleY);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor brownColor]];
    cancleBtn.clipsToBounds=YES;
    cancleBtn.layer.cornerRadius=4;
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    UIButton * connect = [UIButton buttonWithType:UIButtonTypeCustom];
    connect.frame = CGRectMake(ScreenWidth / 2 +  20, ScreenHeight - 70, cancleBtn.frame.size.width, cancleBtn.frame.size.height);
    [connect setTitle:@"立即联系" forState:UIControlStateNormal];
    [connect setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
    connect.clipsToBounds=YES;
    connect.layer.cornerRadius=4;
    [connect addTarget:self action:@selector(immediatelyConnect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connect];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView.frame.size.height / 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [requireLeaseTableView registerClass:[requireLeaseDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    requireLeaseDetailTableViewCell * cell = [requireLeaseTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textField.placeholder = ar[indexPath.row];
    UITextField*  _textField = [[UITextField alloc] initWithFrame:CGRectMake(20,5,cell.frame.size.width - 40,cell.frame.size.height - 10)];
    _textField.borderStyle = UITextBorderStyleLine;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //  costField.layer.cornerRadius=8.0f;
    //  costField.layer.masksToBounds=YES;
    _textField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _textField.layer.borderWidth= 1.0f;
    _textField.layer.cornerRadius = 3;
    _textField.layer.masksToBounds = YES;
    _textField.tag = 10000 + indexPath.row;
    //  type:设备类型；brand：品牌；model：型号；model：吨位/米；address：设备所在地；workcontext：工况
    //  contact：联系人；phone：电话；mid：用户编号
    if (indexPath.row == 0) {
        
        _textField.text = [NSString stringWithFormat:@"设备类型:%@",_type];
    }else if (indexPath.row == 1){
        
        _textField.text = [NSString stringWithFormat:@"品牌:%@",_brand];
    }else if (indexPath.row == 2){
        
        _textField.text = [NSString stringWithFormat:@"型号:%@",_model];
    }else if (indexPath.row == 3){
        
        _textField.text = [NSString stringWithFormat:@"吨位:%@",_size];
    }else if (indexPath.row == 4){
        
        _textField.text = [NSString stringWithFormat:@"设备所在地:%@",_address];
    }else if (indexPath.row == 5){
        
        _textField.text = [NSString stringWithFormat:@"工况情况:%@",_workcontext];
    }else if (indexPath.row == 6){
        
        _textField.text = [NSString stringWithFormat:@"联系人:%@",_contact];
    }else if (indexPath.row == 7){
        
        _textField.text = [NSString stringWithFormat:@"电话:%@",_phone];
    }
    UIView * leView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _textField.frame.size.height)];
    _textField.leftView=leView;
    _textField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.userInteractionEnabled = NO;
    [cell.contentView addSubview:_textField];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (void)cancleClick:(UIButton *)btn{
    
    NSLog(@"取消按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)immediatelyConnect:(UIButton *)btn{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
