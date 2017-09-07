//
//  issueLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/19.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "issueLeaseViewController.h"
#import "myview.h"
#import "alertView.h"
#import "JGDownListMenu.h"
#import "CommonMethod.h"
@interface issueLeaseViewController ()<DownListMenuDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    UITextField * brandTf;//输入关键字
    UIButton * brandButton;//选择设备品牌
    UITextField * siteTextfield;//选择设备所在地
    myview * myView1;//油
    myview * myView2;//司机
    UITextField * costField;//台班费
    UITextField * phoneNumField;//机主电话
    UIButton * pictureBtn;//选择照片按钮
    alertView * vw;//确认发布弹出框
    
    //照片下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
    
    //选择的图片
    UIImage * equipmentImg;
}
@property (nonatomic, strong) NSMutableArray *brandArr;//品牌数据源
@property (nonatomic, strong) JGDownListMenu *list;
@property (nonatomic, copy) NSString  *modleid;
@end

@implementation issueLeaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"发布出租";
    self.navigationController.navigationBar.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    self.brandArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1", nil];
    [self createUI];
}

- (void)createUI{
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5 * myDelegate.autoSizeScaleY)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    
    brandTf = [[UITextField alloc] init];
    brandTf.frame = CGRectMake(20 * myDelegate.autoSizeScaleX, view.frame.origin.y + view.frame.size.height + 10 * myDelegate.autoSizeScaleY, ScreenWidth - 40, 44 * myDelegate.autoSizeScaleY);
    [brandTf.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [brandTf.layer setBorderWidth:1];
    brandTf.clipsToBounds=YES;
    brandTf.layer.cornerRadius=4;
    UIView * lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, siteTextfield.frame.size.height)];
    brandTf.leftView = lefView;
    brandTf.leftViewMode=UITextFieldViewModeAlways;
    brandTf.placeholder = @"设备品牌/型号";
    brandTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设备品牌/型号" attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#999999"]}];
    //[siteButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    brandTf.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:brandTf];
    brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brandButton.frame = CGRectMake(brandTf.frame.size.width + brandTf.frame.origin.x - 32, brandTf.frame.origin.y + 10, 30, 30);
    [brandButton addTarget:self action:@selector(chooseBrand:) forControlEvents:UIControlEventTouchUpInside];
    //[brandButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    brandButton.backgroundColor = [UIColor whiteColor];
    [brandButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
//    [brandButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - brandButton.imageView.frame.size.width + 10, 0 ,0)];
//    [brandButton setImageEdgeInsets:UIEdgeInsetsMake(0,brandButton.frame.size.width - brandButton.imageView.frame.size.width - 10 , 0, 0)];
    
    
    [self.view addSubview:brandButton];
    
    
    siteTextfield = [[UITextField alloc] init];
    siteTextfield.frame = CGRectMake(brandTf.frame.origin.x, brandTf.frame.origin.y + brandTf.frame.size.height + 10 * myDelegate.autoSizeScaleY, brandTf.frame.size.width, 44 * myDelegate.autoSizeScaleY);
    [siteTextfield.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [siteTextfield.layer setBorderWidth:1];
    siteTextfield.clipsToBounds=YES;
    siteTextfield.layer.cornerRadius=4;
    UIView * lefView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, siteTextfield.frame.size.height)];
    siteTextfield.leftView = lefView1;
    siteTextfield.leftViewMode=UITextFieldViewModeAlways;
    siteTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设备所在地" attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#999999"]}];
    //[siteButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    siteTextfield.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:siteTextfield];
    
    
    myView1 = [[myview alloc] initWithFrame:CGRectMake(brandTf.frame.origin.x, siteTextfield.frame.origin.y + siteTextfield.frame.size.height, brandTf.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    myView1.label.text = @"是否含油";
    myView1.label.backgroundColor = [UIColor whiteColor];
    myView1.yesBtn.selected = NO;
    myView1.noBtn.selected = NO;
    [myView1.yesBtn setTitle:@"是" forState:UIControlStateNormal];
    [myView1.noBtn setTitle:@"否" forState:UIControlStateNormal];
    [myView1.yesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView1.yesBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [myView1.noBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView1.noBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [myView1.yesBtn addTarget:self action:@selector(chooseYes1:) forControlEvents:UIControlEventTouchUpInside];
    [myView1.noBtn addTarget:self action:@selector(chooseNo1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myView1];
    
    myView2 = [[myview alloc] initWithFrame:CGRectMake(brandTf.frame.origin.x, myView1.frame.origin.y + myView1.frame.size.height, brandTf.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    myView2.label.text = @"是否带司机";
    myView2.label.backgroundColor = [UIColor whiteColor];
    myView2.yesBtn.selected = NO;
    myView2.noBtn.selected = NO;
    [myView2.yesBtn setTitle:@"是" forState:UIControlStateNormal];
    [myView2.noBtn setTitle:@"否" forState:UIControlStateNormal];
    [myView2.yesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView2.yesBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [myView2.noBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [myView2.noBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [myView2.yesBtn addTarget:self action:@selector(chooseYes2:) forControlEvents:UIControlEventTouchUpInside];
    [myView2.noBtn addTarget:self action:@selector(chooseNo2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myView2];
    
    costField = [[UITextField alloc] initWithFrame:CGRectMake(brandTf.frame.origin.x, myView2.frame.origin.y + myView2.frame.size.height + 10, brandTf.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    costField.borderStyle = UITextBorderStyleLine;
    costField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //  costField.layer.cornerRadius=8.0f;
    //  costField.layer.masksToBounds=YES;
    costField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    costField.layer.borderWidth= 1.0f;
    costField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"台班费" attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#999999"]}];
    costField.keyboardType = UIKeyboardTypeNumberPad;
    costField.layer.cornerRadius = 5;
    costField.layer.masksToBounds = YES;
    UIView * leView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, costField.frame.size.height)];
    costField.leftView=leView;
    costField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    costField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:costField];
    
    phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(brandTf.frame.origin.x, costField.frame.origin.y + costField.frame.size.height + 10, brandTf.frame.size.width, 44 * myDelegate.autoSizeScaleY)];
    phoneNumField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"机主电话" attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#999999"]}];
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    phoneNumField.layer.borderWidth= 1.0f;
    phoneNumField.layer.cornerRadius = 5;
    phoneNumField.layer.masksToBounds = YES;
    UIView * leView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, phoneNumField.frame.size.height)];
    phoneNumField.leftView=leView1;
    phoneNumField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    phoneNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:phoneNumField];
    
    UILabel * pictureLb = [[UILabel alloc] initWithFrame:CGRectMake(brandTf.frame.origin.x, phoneNumField.frame.origin.y + phoneNumField.frame.size.height + 10 * myDelegate.autoSizeScaleY, 50, 44 * myDelegate.autoSizeScaleY)];
    pictureLb.font = [UIFont systemFontOfSize:15];
    pictureLb.text = @"照片";
    [self.view addSubview:pictureLb];
    
    pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pictureBtn.frame = CGRectMake(pictureLb.frame.origin.x + pictureLb.frame.size.width, pictureLb.frame.origin.y + 20* myDelegate.autoSizeScaleY, 80, 50 * myDelegate.autoSizeScaleY);
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:pictureBtn.bounds].CGPath;
    border.frame = pictureBtn.bounds;
    border.lineWidth = 0.5;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [pictureBtn.layer addSublayer:border];
    [pictureBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [pictureBtn addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pictureBtn];
    
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(brandTf.frame.origin.x, ScreenHeight - 70, ScreenWidth / 2 - brandTf.frame.origin.x * 2, 44 * myDelegate.autoSizeScaleY);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor brownColor]];
    cancleBtn.clipsToBounds=YES;
    cancleBtn.layer.cornerRadius=4;
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    UIButton * issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    issueBtn.frame = CGRectMake(ScreenWidth / 2 +  brandTf.frame.origin.x, ScreenHeight - 70, cancleBtn.frame.size.width, cancleBtn.frame.size.height);
    [issueBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [issueBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
    issueBtn.clipsToBounds=YES;
    issueBtn.layer.cornerRadius=4;
    [issueBtn addTarget:self action:@selector(issueClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:issueBtn];

}


-(void)dropDownListParame:(NSString *)aStr
{
    brandButton.selected = NO;
    NSInteger i = [aStr integerValue];
    brandTf.text = self.brandArr[i][@"brandType"];
    _modleid =self.brandArr[i][@"modelId"];
    siteTextfield.text =self.brandArr[i][@"address"];
    phoneNumField.text =self.brandArr[i][@"telphone"];
    
    NSLog(@"选中设备");
    
}

//点击设备品牌/型号
- (void)chooseBrand:(UIButton *)btn{

    [self.view endEditing:YES];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"id",brandTf.text,@"search",nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"machine/brandModel.do"] params:dict success:^(id responseObject) {
        [self.view hideActivity];
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"请求成功%@",dicts);
        if (self.brandArr.count != 0) {
            
            [self.brandArr removeAllObjects];
        }
            
            if (_list) {
                
                [_list removeFromSuperview];
                
            }
        if ([dicts[@"data"] isKindOfClass:[NSNull class]]) {
            
            
        }else{
            
            self.brandArr = dicts[@"data"];
            
            if (self.brandArr.count * 40 > ScreenHeight -  brandTf.frame.origin.y - brandTf.frame.size.height) {
                
                CGRect rect = CGRectMake(ScreenWidth - 100, brandTf.frame.origin.y + brandTf.frame.size.height, 80,ScreenHeight -  brandTf.frame.origin.y - brandTf.frame.size.height);
                _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:self.brandArr rowHeight:40 view:brandButton];
            }else{
                
                CGRect rect = CGRectMake(ScreenWidth - 100, brandTf.frame.origin.y + brandTf.frame.size.height, 80,self.brandArr.count * 40);
                _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:self.brandArr rowHeight:40 view:brandButton];
            }
            _list.delegate = self;
            [self.view addSubview:self.list];
            NSLog(@"设备型号");
            btn.selected = !btn.selected;
            if (btn.selected == YES)
            {
                [_list showList];
                //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, M_PI);
            }else
            {
                [_list hiddenList];
                btn.selected = NO;
                //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, -M_PI);
            }
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    
    
    
}

- (void)chooseYes1:(UIButton *)btn{
    
    NSLog(@"含油");
    if (!myView1.yesBtn.selected) {
        
        myView1.yesBtn.selected = YES;
        myView1.noBtn.selected = NO;
        
//        myView1.yesBtn.backgroundColor = [UIColor redColor];
//        myView1.noBtn.backgroundColor = [UIColor blackColor];
    }else{
        
        myView1.yesBtn.selected = NO;
      //  myView1.yesBtn.backgroundColor = [UIColor blackColor];
    }
    
}

- (void)chooseNo1:(UIButton *)btn{
    
     NSLog(@"不含油");
    if (!myView1.noBtn.selected) {
        myView1.noBtn.selected = YES;
        myView1.yesBtn.selected = NO;
//        myView1.yesBtn.backgroundColor = [UIColor blackColor];
//        myView1.noBtn.backgroundColor = [UIColor redColor];
    }else{
        
        myView1.noBtn.selected = NO;
        // myView1.noBtn.backgroundColor = [UIColor blackColor];
    }
    
}

- (void)chooseYes2:(UIButton *)btn{
    
     NSLog(@"带司机");
    if (!myView2.yesBtn.selected) {
        
        myView2.yesBtn.selected = YES;
        myView2.noBtn.selected = NO;
//      myView2.yesBtn.backgroundColor = [UIColor redColor];
//      myView2.noBtn.backgroundColor = [UIColor blackColor];
    }else{
        
        myView2.yesBtn.selected = NO;
//      myView2.yesBtn.backgroundColor = [UIColor blackColor];
    }
    
}

- (void)chooseNo2:(UIButton *)btn{
    
     NSLog(@"不带司机");
    if (!myView2.noBtn.selected) {
        myView2.noBtn.selected = YES;
        myView2.yesBtn.selected = NO;
//        myView2.yesBtn.backgroundColor = [UIColor blackColor];
//        myView2.noBtn.backgroundColor = [UIColor redColor];
    }else{
        
        myView2.noBtn.selected = NO;
//        myView2.noBtn.backgroundColor = [UIColor blackColor];
    }
}
- (void)choosePicture:(UIButton *)btn{
    
    NSLog(@"选择照片");
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"从手机相册获取",@"拍照",nil];
    
    [myActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self LocalPhoto];
            break;
            
        case 1:  //打开本地相册
            [self takePhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //  [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        [self sendInfo];
        //关闭相册界面
        //[picker dismissModalViewControllerAnimated:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        //        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
        //                                    CGRectMake(50, 120, 40, 40)];
        //
        //        smallimage.image = image;
        [pictureBtn setBackgroundImage:equipmentImg forState:UIControlStateNormal];
        //[btn setTitle:@"" forState:UIControlStateNormal];
        //        //加在视图中
        //        [self.view addSubview:smallimage];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
    equipmentImg = [[UIImage alloc] initWithContentsOfFile:filePath];
    
}


//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}
- (void)cancleClick:(UIButton *)btn{
    
    NSLog(@"取消按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)issueClick:(UIButton *)btn{

    NSString * brandmodelId = _modleid;
    NSString * address = siteTextfield.text;
    NSString * oil;
    NSString * driver;
    if ([_modleid isKindOfClass:[NSNumber class]]) {
        
        _modleid = [NSString stringWithFormat:@"%@",_modleid];
    }
    
    if (_modleid.length == 0) {
        
        [self showHint:@"请选择设备品牌/型号"];
        return;
    }
    if (address.length == 0) {
        
        [self showHint:@"请填入设备所在地"];
        return;
    }
    if (!myView1.yesBtn.selected && !myView1.noBtn.selected) {
        
        [self showHint:@"请选择是否含油"];
        return;
    }
    if (!myView2.yesBtn.selected && !myView2.noBtn.selected) {
        
        [self showHint:@"请选择是否带司机"];
        return;
    }
    if (myView1.yesBtn.selected) {
        
         oil = @"1";
        
    }else{
        
         oil = @"0";
    }
    if (myView2.yesBtn.selected) {
        
         driver = @"1";
    }else{
        
         driver = @"0";
    }
    NSString *cost = costField.text;
    NSString * machinephone =phoneNumField.text;
    if (cost.length == 0) {
        
        [self showHint:@"请填入台班费"];
        return;
    }if (![[self valiMobile:machinephone] isEqualToString:@"ok"]) {
        
        [self showHint:@"请正确输入联系人电话"];
        return;
    }
    //  brandmodel:品牌型号；modelid：设备ID；address：设备所在地；picture：图片；oil：是否含油；driver：是否带司机
    //  cost：台班费；machinephone：联系电话；mId：用户编号
    NSData *data = UIImageJPEGRepresentation(equipmentImg, 0.3);
//    if (data == nil) {
//        
//        [self showHint:@"请选择照片!"];
//        [CustomAlertView hideHUDForView:self];
//        return;
//    }
    // NSData *data = UIImagePNGRepresentation(icon);
    NSString *picture = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString * imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",[self contentTypeForImageData:data],picture];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[brandmodelId integerValue]],@"modelid",address,@"address",imageDataString,@"picture",oil,@"oil",driver,@"driver",cost,@"tempPrice",machinephone,@"machinephone",[NSNumber numberWithDouble:uId],@"mId", nil];
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/addMachineLease.do"] params:dict success:^(id responseObject) {
        [self.view hideActivity];
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dicts[@"success"] boolValue] == YES) {
            
            vw = [[alertView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
            vw.msgLb.text = @"恭喜您出租已成功发布";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
