//
//  NetWork.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-12.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MyHeader.h"
#import "AsyncUdpSocket.h"
#import "AsyncSocket.h"
#import "ReceiveMessageDelegate.h"

extern NSString * const NetWorkDefaultHost;
extern int const NetWorkDefaultPort;

//@class AsyncUdpSocket;

@interface NetWork : NSObject<AsyncUdpSocketDelegate,AsyncSocketDelegate>{
    //socket
    AsyncUdpSocket * mainUdpSocket;
    AsyncSocket * mainTcpSocket;
    
    
    
    //发送的Host地址
    NSString * broadCastHost;
    
    //自己的iP地址
    NSString * myIPStr;
    
    //发送的端口
    int mainPort;
    
    //file
    long fileLength;
    NSMutableData * receiveData;
}

@property (nonatomic, weak) id<ReceiveMessageDelegate>delegate;

//对外接口
//发送消息
-(void)sendMessageWith:(NSString *)theMessage;

@end
