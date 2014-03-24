//
//  ChatMsgCell.m
//  kyoume
//
//  Created by apple on 14-3-11.
//  Copyright (c) 2014年 penta. All rights reserved.
//

#import "ChatMsgCell.h"
#import "ChatMsgFrame.h"
#import "ChatMsg.h"

@interface ChatMsgCell ()
{
    UIButton     *_timeBtn;
//    UIImageView *_iconView;
    UILabel * _iconView;
    UIButton    *_contentBtn;
}

@end

@implementation ChatMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#warning 必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 创建头像
        _iconView = [[UILabel alloc] init];
        [self.contentView addSubview:_iconView];
        
        // 创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
    }
    return self;
}

- (void)setMessageFrame:(ChatMsgFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    ChatMsg *message = _messageFrame.chatMsg;
    

    
    // 设置头像
    _iconView.text = message.profile;
    _iconView.frame = _messageFrame.profileF;
    
    // 设置内容
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    //设置内容背景
    UIImage *normal;
    if (message.type == MessageTypeMe) {
        
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];     
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    
}
@end
