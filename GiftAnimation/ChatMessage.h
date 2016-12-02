//
//  ChatMessage.h
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

/**
 发送者昵称
 */
@property (nonatomic,retain) NSString *senderName;

/**
 消息内容
 */
@property (nonatomic,retain) NSString *text;

/**
 发送者id
 */
@property (nonatomic,retain) NSString *senderChatId;
@end
