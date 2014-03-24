//
//  Message.h
//  kyoume
//
//  Created by apple on 14-3-11.
//  Copyright (c) 2014年 penta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MessageTypeMe = 0,
    MessageTypeOther = 1
    
}MessageType;

@interface ChatMsg : NSObject
//{
//    NSString *profile;
//    NSString *time;
//    NSString *content;
//    MessageType type;
//    
//    NSDictionary *dict;
//}

@property (nonatomic, retain) NSString *profile;
//@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) MessageType type;

@property (nonatomic, retain) NSDictionary *dict;

@end
