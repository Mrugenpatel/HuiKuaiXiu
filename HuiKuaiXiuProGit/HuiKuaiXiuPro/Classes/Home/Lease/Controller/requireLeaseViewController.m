//
//  requireLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "requireLeaseViewController.h"
#import "requireLeaseTableViewCell.h"
#import "alertView.h"
#import "CommonMethod.h"
@interface requireLeaseViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray * ar ;//cell表格
    UITableView * requireLeaseTableView;
    alertView *vw;
    
//  type:设备类型；brand：品牌；model：型号；size：吨位/米；address：设备所在地；workcontext：工况
//  contact：联系人；phone：电话；mid：用户编号
     NSString *type;
     NSString *brand;
     NSString *model;
     NSString *size;
     NSString *address;
     NSString *workcontext;
     NSString *contact;
     NSString *phone;
     NSString *mid;
    NSMutableArray * tfArr;//存放tf的数组
}

@end

@implementation requireLeaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"发布求租";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    [self createUI];
    
}


- (void)createUI{
    
    tfArr = [[NSMutableArray alloc] init];
    ar = [[NSArray alloc] initWithObjects:@"设备类型",@"品牌", @"型号",@"吨位",@"设备所在地",@"工况情况",@"联系人",@"电话",nil];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    
    requireLeaseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, ScreenWidth, ScreenHeight - 64 - 5 - 100) style:UITableViewStylePlain];
    requireLeaseTableView.delegate = self;
    requireLeaseTableView.dataSource = self;
    requireLeaseTableView.scrollEnabled = NO;
    requireLeaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:requireLeaseTableView];
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(20, ScreenHeight - 70, ScreenWidth / 2 -20 * 2, 50);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor brownColor]];
    cancleBtn.clipsToBounds=YES;
    cancleBtn.layer.cornerRadius=4;
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    UIButton * issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    issueBtn.frame = CGRectMake(ScreenWidth / 2 +  20, ScreenHeight - 70, cancleBtn.frame.size.width, cancleBtn.frame.size.height);
    [issueBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [issueBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
    issueBtn.clipsToBounds=YES;
    issueBtn.layer.cornerRadius=4;
    [issueBtn addTarget:self action:@selector(issueClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:issueBtn];
    
    
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
    [requireLeaseTableView registerClass:[requireLeaseTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,indexPath.row]];
    requireLeaseTableViewCell * cell = [requireLeaseTableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,indexPath.row] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textField.placeholder = ar[indexPath.row];
    
//    for (UITextField * tf in cell.contentView.subviews) {
//        
//        [tf removeFromSuperview];
//    }
  
        
        UITextField*  _textField = [[UITextField alloc] initWithFrame:CGRectMake(20,5,cell.frame.size.width - 40,cell.frame.size.height - 10)];
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = ar[indexPath.row];
        //costField.layer.cornerRadius=8.0f;
        //costField.layer.masksToBounds=YES;
        _textField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _textField.layer.borderWidth= 1.0f;
        _textField.layer.cornerRadius = 3;
        _textField.layer.masksToBounds = YES;
        _textField.tag = 10000 + indexPath.row;
        UIView * leView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _textField.frame.size.height)];
        _textField.leftView=leView;
        _textField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    if (indexPath.row == 3) {
        
        _textField.keyboardType =UIKeyboardTypeDecimalPad;
        
    }
       [cell.contentView addSubview:_textField];
//    if (tfArr.count == 0 || tfArr.count < 8) {
//        
//        [tfArr addObject:_textField];
//        [cell.contentView addSubview:_textField];
//    }else{
//        
//        for (UITextField * tf in tfArr ) {
//            
//            if (tf.tag == _textField.tag) {
//                
//                NSLog(@"已存在tf");
//                
//            }else{
//                
//                NSLog(@"没存在");
//                [cell.contentView addSubview:_textField];
//                
//            }
//        }
//    }
    
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (void)cancleClick:(UIButton *)btn{
    
    NSLog(@"取消按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)issueClick:(UIButton *)btn{
    
//  type:设备类型；brand：品牌；model：型号；size：吨位/米；address：设备所在地；workcontext：工况
//  contact：联系人；phone：电话；mid：用户编号

    UITextField * tf0 = (UITextField *)[self.view viewWithTag:10000 + 0];
    type = tf0.text;
    UITextField * tf1 = (UITextField *)[self.view viewWithTag:10000 + 1];
    brand = tf1.text;
    UITextField * tf2 = (UITextField *)[self.view viewWithTag:10000 + 2];
    model = tf2.text;
    UITextField * tf3 = (UITextField *)[self.view viewWithTag:10000 + 3];
    size = tf3.text;
    UITextField * tf4 = (UITextField *)[self.view viewWithTag:10000 + 4];
    address = tf4.text;
    UITextField * tf5 = (UITextField *)[self.view viewWithTag:10000 + 5];
    workcontext = tf5.text;
    UITextField * tf6 = (UITextField *)[self.view viewWithTag:10000 + 6];
    contact = tf6.text;
    UITextField * tf7 = (UITextField *)[self.view viewWithTag:10000 + 7];
    phone = tf7.text;
    
    if (type.length == 0){
        
        [self showHint:@"请填写设备类型"];
        return;
    }
    if (brand.length == 0){
        
        [self showHint:@"请填写设备品牌"];
        return;
    }
    if (model.length == 0){
        
        [self showHint:@"请填写设备型号"];
        return;
    }
    if (size.length == 0){
        
        [self showHint:@"请填写设备吨位"];
        return;
    }
    if (address.length == 0){
        
        [self showHint:@"请填写设备所在地"];
        return;
    }
    if (workcontext.length == 0){
        
        [self showHint:@"请填写设备工况情况"];
        return;
    }
    if (contact.length == 0){
        
        [self showHint:@"请填写设备联系人"];
        return;
    }if (phone.length == 0){
        
        [self showHint:@"请填写设备联系人电话"];
        return;
    }if (![[self valiMobile:phone] isEqualToString:@"ok"]) {
        
        [self showHint:@"请正确输入联系人电话"];
        return;
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",brand,@"brand",model,@"model",size,@"size",address,@"address",workcontext,@"workcontext",contact,@"contact",phone,@"phone",[NSNumber numberWithDouble:uId],@"mId", nil];
   // NSLog(@"%@",[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/addBylease.do"]);
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/addBylease.do"] params:dict success:^(id responseObject) {
        [self.view hideActivity];
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        if ([dicts[@"success"] boolValue] == YES) {
            
            vw = [[alertView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
            vw.msgLb.text = @"恭喜您求租已成功发布";
            [vw.certainBtn addTarget:self action:@selector(certainClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationController.view addSubview:vw];
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    
    
    
}
- (void)certainClick:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [vw removeFromSuperview];
}
- (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return @"ok";
        }else{
            return @"请输入正确格式的电话号码";
        }
    }
    return @"ok";
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
