//
//  AddDeviceController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "AddDeviceController.h"

@interface AddDeviceController () <UITextFieldDelegate>
@property AppDelegate *appDelegate;
@property UITextField *deviceNameField;
@property UITextField *deviceTokenField;
@end

@implementation AddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    self.view.backgroundColor = RGBA_COLOR(239, 239, 239, 1);
    self.navigationItem.title = NSLocalizedString(@"deviceAddNavigationItemTitle", nil);
    
//    UIBarButtonItem *deviceAddButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickDeviceAddButtonButton)];
//    self.navigationItem.rightBarButtonItem = deviceAddButton;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *deviceView = [[UIView alloc] initWithFrame:CGRectMake(GAP_WIDTH*2, MARGIN_TOP+GAP_HEIGHT*2, VIEW_WIDTH-4*GAP_WIDTH, VIEW_HEIGHT)];
    
    self.deviceNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(deviceView), 44)];
    self.deviceNameField.delegate = self;
    self.deviceNameField.backgroundColor = [UIColor whiteColor];
    [self setTextFieldLeftPadding:self.deviceNameField forWidth:10];
    self.deviceNameField.layer.cornerRadius = 5;
    self.deviceNameField.layer.masksToBounds = YES;
    self.deviceNameField.layer.borderColor = BORDER_WHITE_COLOR;
    self.deviceNameField.layer.borderWidth = BORDER_WIDTH;
    self.deviceNameField.placeholder = NSLocalizedString(@"deviceAddDeviceName", nil);
    self.deviceNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [deviceView addSubview:self.deviceNameField];
    
    self.deviceTokenField = [[UITextField alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(self.deviceNameField)+GET_LAYOUT_HEIGHT(self.deviceNameField)+10, GET_LAYOUT_WIDTH(deviceView), 44)];
    self.deviceTokenField.delegate = self;
    self.deviceTokenField.backgroundColor = [UIColor whiteColor];
    [self setTextFieldLeftPadding:self.deviceTokenField forWidth:10];
    self.deviceTokenField.layer.cornerRadius = 5;
    self.deviceTokenField.layer.masksToBounds = YES;
    self.deviceTokenField.layer.borderColor = BORDER_WHITE_COLOR;
    self.deviceTokenField.layer.borderWidth = BORDER_WIDTH;
    self.deviceTokenField.placeholder = NSLocalizedString(@"deviceAddDeviceNumber", nil);
    self.deviceTokenField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [deviceView addSubview:self.deviceTokenField];
    
    UIButton *deviceAddButton = [[UIButton alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(self.deviceTokenField)+GET_LAYOUT_HEIGHT(self.deviceTokenField)+10, GET_LAYOUT_WIDTH(deviceView), 44)];
    deviceAddButton.backgroundColor = RGBA_COLOR(27, 163, 232, 1);
    deviceAddButton.layer.cornerRadius = 5;
    deviceAddButton.layer.masksToBounds = YES;
    [deviceAddButton setTitle:NSLocalizedString(@"deviceAddRightBarButtonItemTitle", nil) forState:UIControlStateNormal];
    [deviceAddButton addTarget:self action:@selector(clickDeviceAddButton) forControlEvents:UIControlEventTouchUpInside];
    [deviceView addSubview:deviceAddButton];
    
    [self.view addSubview:deviceView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth {
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (void)clickDeviceAddButton {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    NSDictionary *parameters=@{@"user_id":@"45",@"device_token":self.deviceTokenField.text,@"device_name":self.deviceNameField.text};
    [manager POST:BASE_URL(@"device/bind") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功.%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);
        
        int status = [[dic objectForKey:@"status"] intValue];
        
        if( status == 200 ){
            NSDictionary *data = [dic objectForKey:@"data"];
            NSString *device_id = [data objectForKey:@"device_id"];
            
            NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
            [device setObject:device_id forKey:@"device_id"];
            [device setObject:self.deviceTokenField.text forKey:@"device_token"];
            [device setObject:self.deviceNameField.text forKey:@"device_name"];
            [self.appDelegate.deviceList addObject:device];
            
            NSLog(@"%@", self.appDelegate.deviceList);
            [self.appDelegate saveDeviceList:device];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败.%@",error);
        NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
}

#pragma mark - UITextFieldDelegate
// 获取第一响应者时调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.cornerRadius = 8.0f;
    // textField.layer.masksToBounds=YES;
    textField.layer.borderColor = BORDER_FOCUS_COLOR;
    textField.layer.borderWidth = BORDER_WIDTH;
    return YES;
}

// 失去第一响应者时调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = BORDER_WHITE_COLOR;
    return YES;
}

// 按enter时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
