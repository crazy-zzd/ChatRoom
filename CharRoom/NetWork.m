//
//  NetWork.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-12.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "NetWork.h"
//#import "AsyncUdpSocket.h"

@implementation NetWork

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self) {
        
        broadCastHost = @"255.255.255.255";
        
        mainPort = 1760;
        
        [self initSocket];
        
    }
    return self;
}

- (void)initSocket
{
    NSError * error = Nil;
    
    mainSocket = [[AsyncUdpSocket alloc] initIPv4];
    [mainSocket setDelegate:self];
    [mainSocket bindToPort:mainPort error:& error];
    [mainSocket enableBroadcast:YES error:& error];
    [mainSocket receiveWithTimeout:-1 tag:0];
    
}

#pragma mark - 对外接口


- (void)sendMessageWith:(NSString *)theMessage
{
    [self broadCast:broadCastHost withSocket:mainSocket withMessage:theMessage withPort:mainPort];
}


#pragma mark - private methods

//- (NSString * )handleMessage:(NSString *)theMessage
//{
//    return [NSString stringWithFormat:@"CHATROOM:%@",theMessage];
//}

#pragma mark - main methods

- (void)broadCast:(NSString *)theHost withSocket:(AsyncUdpSocket *)theSocket withMessage:(NSString *)theMessage withPort:(int)thePort
{
    NSData * data = [theMessage dataUsingEncoding:NSASCIIStringEncoding] ;
    
    BOOL result = NO;
    //开始发送
    result = [theSocket sendData:data
                       toHost:theHost
                         port:thePort
                  withTimeout:1000
                          tag:0];
    
    if (!result) {
//        NSLog(@"send failed");
    }
    else{
//        NSLog(@"send succeed");
    }
}



#pragma mark - AsyncUdpSocket Delegate
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [sock receiveWithTimeout:-1 tag:0];
    NSLog(@"host---->%@",host);
    
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSLog(@"the resource string:%@",info);

//    if ([info isEqualToString:CONNECT_RECEIVED_FIRST]) {
//        broadCastHost = host;
//        receiveMessage = [NSString stringWithFormat:@"%@",info];
//        ;
//    }
//    
//    if ([info isEqualToString:CONNECT_RECEIVED_ALWAYS]) {
//        receiveMessage = [NSString stringWithFormat:@"%@",info];
//    }
    
//    if ((connectState == STATE_CONNECT_SEARCHING_CLIENT)&& (receiveMessage != nil)) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"可以进入手柄了~" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
//        [alert show];
//    }

    
    //已经处理完毕
//    if (!([info isEqualToString:CONNECT_SEND_FIRST]||[info isEqualToString:CONNECT_SEND_SECOND]||[info isEqualToString:CONNECT_SEND_ALWAYS])) {
//        receiveMessage = [NSString stringWithFormat:@"%@",info];
//        if ((connectState == STATE_CONNECT_SEARCHING_CLIENT)&& (receiveMessage != nil)) {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"可以进入手柄了~" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        NSLog(@"recieved message:%@",info);
//    }

    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"send succeed");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
//    NSLog(@"send failed");
    
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    
}
@end
