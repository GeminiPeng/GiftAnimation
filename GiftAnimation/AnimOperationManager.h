//
//  AnimOperationManager.h
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GiftModel.h"

@interface AnimOperationManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic,strong)UIView *parentView;
@property (nonatomic,strong)GiftModel *model;
//动画操作 需要用userid和回调
- (void)animationWithUserId:(NSString *)userId model:(GiftModel *)model finishedBlock:(void(^)(BOOL result))finishedBlock;

//取消上一次的动画
- (void)cancelOperationWithLastUserId:(NSString *)userId;
@end
