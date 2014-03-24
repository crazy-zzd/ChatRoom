//
//  ChatMsgFrame.m
//  kyoume
//
//  Created by apple on 14-3-11.
//  Copyright (c) 2014年 penta. All rights reserved.
//

#import "ChatMsgFrame.h"
#import "ChatMsg.h"

@implementation ChatMsgFrame

-(void)setChatMsg:(ChatMsg *)chatMsg
{
    _chatMsg = chatMsg;
    
    // 获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;

    // 计算头像位置
    CGFloat iconX = kMargin;
    // 如果是自己发得，头像在右边
    if (chatMsg.type == MessageTypeMe) {
        iconX = screenW - kMargin - kProfileWH;
    }
    CGFloat iconY = kMargin;
    _profileF = CGRectMake(iconX, iconY, kProfileWeith, kProfileHeight);
    
    // 计算内容位置
    CGFloat contentX = CGRectGetMaxX(_profileF) + kMargin;
    CGFloat contentY = iconY;
    CGSize contentSize = [chatMsg.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(kContentW, CGFLOAT_MAX)];
    
    if (chatMsg.type == MessageTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
    }
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);
    
    // 计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_profileF))  + kMargin;

}

@end
