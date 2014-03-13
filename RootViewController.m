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

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainNetWork = [[NetWork alloc] init];
        
        UIButton * testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [testBtn setTitle:@"test" forState:UIControlStateNormal];
        [testBtn setFrame:CGRectMake(100, 100, 100, 100)];
        [self.view addSubview:testBtn];
        [testBtn addTarget:self action:@selector(onPressTestBtn:) forControlEvents:UIControlEventTouchUpInside];
        
//        // Custom initialization
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

@end