//
//  AnimOperation.h
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GiftShowView.h"
#import "GiftModel.h"


@interface AnimOperation : NSOperation
@property (nonatomic,strong) GiftShowView* giftShowView;
@property (nonatomic,strong) UIView *listView;
@property (nonatomic,strong) GiftModel *model;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *userId;//新增用户标示,记录礼物信息

+(instancetype)animationOperationWithUserId:(NSString *)userId model:(GiftModel *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock;
@end
