//
//  RootViewController.m
//  CharRoom
//
//  Created by 朱 俊健 on 14-3-13.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import "RootViewController.h"
#import "NetWork.h"

@interface RootViewController ()

@end

static NSString * const a = @"d";

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainNetWork = [[NetWork alloc] init];

        mainNetWork.delegate = self;
        
        UIButton * testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [testBtn setTitle:@"test" forState:UIControlStateNormal];
        [testBtn setFrame:CGRectMake(100, 100, 100, 100)];
        [self.view addSubview:testBtn];
        [testBtn addTarget:self action:@selector(onPressTestBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
        textField.placeholder = @"aa";
        textField.delegate = self;
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.view addSubview:textField];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (IBAction)onPressTestBtn:(id)sender
{
    [mainNetWork sendMessageWith:@"testMessge"];
}

#pragma mark - textField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [mainNetWork sendMessageWith:textField.text];
    textField.text = @"";
    return YES;
}

#pragma mark - receiveMessage delegate

- (void)receiveMessageWith:(NSString *)theMessage
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"收到信息" message:theMessage delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
