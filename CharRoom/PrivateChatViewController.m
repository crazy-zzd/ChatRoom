//
//  PrivateChatViewController.m
//  kyoume
//
//  Created by apple on 14-3-11.
//  Copyright (c) 2014年 penta. All rights reserved.
//

#import "PrivateChatViewController.h"
#import "ChatMsg.h"
#import "ChatMsgFrame.h"
#import "ChatMsgCell.h"
#import "NetWork.h"
#import "ReceiveMessageDelegate.h"


@interface PrivateChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ReceiveMessageDelegate, UIAlertViewDelegate>
{
    NSMutableArray  *_allMessagesFrame;
    UIImageView *bottomToolBar;
    NetWork * mainNetWork;
    NSString * userName;
    
    UIAlertView * theHostAlertView;
    UIAlertView * thePortAlertView;
}

@end

@implementation PrivateChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mainNetWork = [[NetWork alloc] init];
        
        mainNetWork.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"未连接";
    [self.navigationItem setHidesBackButton:YES];
    
    userName = @"zjj";
    
    // init widget
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 360, 568 - 44) style:UITableViewStylePlain];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.allowsSelection = NO;
    
    bottomToolBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 568 - 44, 320, 44)];
    bottomToolBar.userInteractionEnabled = YES;
    
    //设置textField输入起始位置
    _messageField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 300, 33)];
    _messageField.borderStyle = UITextBorderStyleRoundedRect;
    _messageField.placeholder = @"请输入";
    _messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 0)];
    _messageField.leftViewMode = UITextFieldViewModeAlways;
    _messageField.delegate = self;
    
    //初始化信息框架
    _allMessagesFrame = [NSMutableArray array];

    
    // Keyboard show/hide response
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    // add widget to view
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:bottomToolBar];
    [bottomToolBar addSubview:_messageField];
//    [bottomToolBar addSubview:extraBtn];
    
    [self initAlertViews];

}

- (void)initAlertViews
{
    NSString * thePortStr = [NSString stringWithFormat:@"Port是服务器端的端口号\n默认为%d", NetWorkDefaultPort];
    thePortAlertView = [[UIAlertView alloc] initWithTitle:@"输入Port！" message:thePortStr delegate:nil cancelButtonTitle:@"保持默认" otherButtonTitles:@"修改",nil];
    [thePortAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    thePortAlertView.delegate = self;
    [thePortAlertView show];
    
    UITextField * textField = [thePortAlertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    NSString * theHostStr = [NSString stringWithFormat:@"Host是服务器端的iP地址\n默认地址为%@",NetWorkDefaultHost];
    theHostAlertView = [[UIAlertView alloc] initWithTitle:@"输入HOST！" message:theHostStr delegate:nil cancelButtonTitle:@"保持默认" otherButtonTitles:@"修改",nil];
    [theHostAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    theHostAlertView.delegate = self;
    [theHostAlertView show];
    textField = [theHostAlertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}


#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        bottomToolBar.frame = CGRectMake(0, 568 - 44 + ty, 320, 44);
        self.chatTableView.frame = CGRectMake(0, 0, 360, 568 - 44 + ty);
    }];
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{

    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        bottomToolBar.frame = CGRectMake(0, 568 - 44, 320, 44);
        self.chatTableView.frame = CGRectMake(0, 0, 360, 568 - 44);
    }];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"return");
    [mainNetWork sendMessageWith:textField.text];
    // 4、清空文本框内容
    if ([self.title isEqualToString:@"未连接"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未连接上服务器\n请查看端口和Host" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    _messageField.text = nil;
    return YES;
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content with:(NSString *)theUserName{
    
    ChatMsgFrame *mf = [[ChatMsgFrame alloc] init];
    ChatMsg *msg = [[ChatMsg alloc] init];
    if ([userName isEqualToString:theUserName]) {
        msg.type = MessageTypeMe;
    }else{
        msg.type = MessageTypeOther;
    }
    

    msg.content = content;
    msg.profile = theUserName;
    mf.chatMsg = msg;
    
    [_allMessagesFrame addObject:mf];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ChatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - receiveMessage delegate
- (void)receiveMessageWith:(NSString *)theMessage
{
    // 1、增加数据源
    NSString *content = theMessage;
    NSArray * contents = [content componentsSeparatedByString:@" : "];
    if ([contents count] < 2) {
        [self addMessageWithContent:content with:@"admin"];
        self.title = @"321群聊";
    }
    else{
        [self addMessageWithContent:contents[1] with:contents[0]];
    }
    // 2、刷新表格
    [self.chatTableView reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setState:(NSString *)theStateStr
{
    self.title = theStateStr;
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView == thePortAlertView) {
        [mainNetWork initSocket];
    }
    if (buttonIndex == 0) {
        return;
    }
    UITextField * theAlertViewTextField=[alertView textFieldAtIndex:0];
    if (alertView == theHostAlertView) {
        [mainNetWork setBroadCastHost:theAlertViewTextField.text];
    }
    else{
        [mainNetWork setMainPort:[theAlertViewTextField.text intValue]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
