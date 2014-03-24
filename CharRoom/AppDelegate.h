//
//  AppDelegate.h
//  CharRoom
//
//  Created by 朱 俊健 on 14-3-13.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class PrivateChatViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//for the main page
@property (strong, nonatomic) PrivateChatViewController *viewController;

//for the navigation
@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) UIWindow *window;

@end
