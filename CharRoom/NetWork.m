//
//  NetWork.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-12.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "NetWork.h"
//#import "AsyncUdpSocket.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NetWork

@synthesize delegate;

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self) {
        
        broadCastHost = @"255.255.255.255";
        
        mainPort = 1760;
        
        [self initSocket];

        myIPStr = [self getIPAddress];
        NSLog(@"%@",myIPStr);
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

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


#pragma mark - main methods

- (void)broadCast:(NSString *)theHost withSocket:(AsyncUdpSocket *)theSocket withMessage:(NSString *)theMessage withPort:(int)thePort
{
//    NSData * data = [theMessage dataUsingEncoding:NSASCIIStringEncoding] ;
    NSData * data = [theMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    BOOL result = NO;
    //开始发送
    result = [theSocket sendData:data
                       toHost:theHost
                         port:thePort
                  withTimeout:1000
                          tag:0];
    
    if (!result) {
        NSLog(@"send failed");
    }
    else{
        NSLog(@"send succeed");
    }
}


#pragma mark - AsyncUdpSocket Delegate
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [sock receiveWithTimeout:-1 tag:0];
    NSLog(@"host---->%@",host);
    
    if ([host isEqualToString:myIPStr]) {
        return YES;
    }
    
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSLog(@"the resource string:%@",info);

    [self.delegate receiveMessageWith:info];

    
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
