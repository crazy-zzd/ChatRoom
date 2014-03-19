//
//  NetWork.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-12.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "NetWork.h"

NSString * const NetWorkDefaultHost = @"192.168.1.106";
int const NetWorkDefaultPort = 2502;

@implementation NetWork

@synthesize delegate;

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self) {
        broadCastHost = NetWorkDefaultHost;
//        broadCastHost = @"192.168.1.106";
//        broadCastHost = @"222.20.59.198";
        
        mainPort = NetWorkDefaultPort;
        
        [self initSocket];
        
        fileLength = 0;
        receiveData = [[NSMutableData alloc] initWithLength:0];
    }
    return self;
}

- (void)initSocket
{
    NSError * error = Nil;
    
    mainTcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
    if (![mainTcpSocket connectToHost:broadCastHost onPort:mainPort error:&error]) {
        NSLog(@"连接消息发送失败,error:%@",error);
    }
    else{
        NSLog(@"连接消息发送成功");
    }
    [mainTcpSocket readDataWithTimeout:-1 tag:1];
}

#pragma mark - 对外接口


- (void)sendMessageWith:(NSString *)theMessage
{
    NSString * sendMessage = [NSString stringWithFormat:@"zjj : %@",theMessage];
    NSData * sendData = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
    [mainTcpSocket writeData:sendData withTimeout:-1 tag:1];
}

#pragma mark - private methods



#pragma mark - main methods


#pragma mark - AsyncSocket Delegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSString * sendMessage = @"zjj";
    NSData * sendData = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
    [mainTcpSocket writeData:sendData withTimeout:-1 tag:1];
    NSLog(@"连接成功");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [mainTcpSocket readDataWithTimeout:-1 tag:1];

    NSString * receiveMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.delegate receiveMessageWith:receiveMessage];
    NSLog(@"%@",receiveMessage);
    
}

@end
