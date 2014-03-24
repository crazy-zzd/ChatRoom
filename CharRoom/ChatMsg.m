//
//  Message.m
//  kyoume
//
//  Created by apple on 14-3-11.
//  Copyright (c) 2014年 penta. All rights reserved.
//

#import "ChatMsg.h"

@implementation ChatMsg

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.profile = dict[@"profile"];
//    self.time = dict[@"time"];
    self.content = dict [@"content"];
    self.type = [dict[@"type"] intValue];
    
}

@end
