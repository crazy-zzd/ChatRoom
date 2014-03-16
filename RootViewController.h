//
//  RootViewController.h
//  CharRoom
//
//  Created by 朱 俊健 on 14-3-13.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveMessageDelegate.h"

@class NetWork;

@interface RootViewController : UIViewController<ReceiveMessageDelegate>{
    NetWork * mainNetWork;
}

@end
