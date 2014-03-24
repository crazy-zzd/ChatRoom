//
//  ReceiveMessageDelegate.h
//  CharRoom
//
//  Created by 朱 俊健 on 14-3-16.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReceiveMessageDelegate <NSObject>

@required
- (void)receiveMessageWith:(NSString *)theMessage;

- (void)setState:(NSString *)theStateStr;

@end
