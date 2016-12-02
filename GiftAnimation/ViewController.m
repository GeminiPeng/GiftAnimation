//
//  ViewController.m
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import "ViewController.h"
#import "GiftShowView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "ChatMessage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ChatMessage * msg = [ChatMessage new];
    msg.text = @"1个 [鲜花]";
    
    int x =arc4random()%9;
    msg.senderChatId = [NSString stringWithFormat:@"%d",x];
    msg.senderName = msg.senderChatId;
    
    //礼物模型
    GiftModel * model = [GiftModel new];
    model.headImage = [UIImage imageNamed:@"luffy"];
    model.name = msg.senderName;
    model.giftName = msg.text;
    model.giftImage = [UIImage imageNamed:@"flower"];
    model.giftCount = 1;
    
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    manager.parentView = self.view;
    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
    [manager animationWithUserId:msg.senderChatId model:model finishedBlock:^(BOOL result) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
