//
//  AnimOperationManager.m
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import "AnimOperationManager.h"
#import "AnimOperation.h"

@interface AnimOperationManager()
//列队1
@property (nonatomic,strong)NSOperationQueue *queue1;
//列队2
@property (nonatomic,strong)NSOperationQueue *queue2;

//操作缓存池
@property (nonatomic,strong)NSCache *operationCache;
//维护用户礼品信息
@property (nonatomic,strong)NSCache *userGiftInfos;
@end

@implementation AnimOperationManager

+(instancetype)sharedManager {
    static AnimOperationManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [AnimOperationManager new];
    });
    return manager;
}

-(NSOperationQueue *)queue1 {
    if (_queue1 == nil) {
        _queue1 = [NSOperationQueue new];
        _queue1.maxConcurrentOperationCount = 1;
    }
    return _queue1;
}

- (NSOperationQueue *)queue2 {
    if (_queue2 == nil) {
        _queue2 = [NSOperationQueue new];
        _queue2.maxConcurrentOperationCount = 1;
    }
    return _queue2;
}

- (NSCache *)operationCache {
    if (_operationCache == nil) {
        _operationCache = [NSCache new];
    }
    return _operationCache;
}

- (NSCache *)userGiftInfos {
    if (_userGiftInfos == nil) {
        _userGiftInfos = [NSCache new];
    }
    return _userGiftInfos;
}


- (void)animationWithUserId:(NSString *)userId model:(GiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlock {
    //有用户礼品信息时
    if ([self.userGiftInfos objectForKey:userId]) {
        //如果有操作缓存,直接累加
        if ([self.operationCache objectForKey:userId]!=nil) {
            AnimOperation *op = [self.operationCache objectForKey:userId];
            op.giftShowView.giftCount = model.giftCount;
            [op.giftShowView shakeNumberLabel];
            return;
        }
        
        //没有操作缓存 创建op
        AnimOperation *op = [AnimOperation animationOperationWithUserId:userId model:model finishedBlock:^(BOOL result, NSInteger finishCount) {
            if (finishedBlock) {
                finishedBlock(result);
            }
            //将礼物信息数量缓存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userId];
            //动画完成后,移除动画对应的操作
            [self.operationCache removeObjectForKey:userId];
            //延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userId];
            });
        }];
        
        // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
        op.giftShowView.animCount = [[self.userGiftInfos objectForKey:userId] integerValue];
        op.model.giftCount = op.giftShowView.animCount + 1;
        
        op.listView = self.parentView;
        op.index = [userId integerValue] % 2;
        
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userId];
        
        // 根据用户ID 控制显示的位置
        if ([userId integerValue] % 2) {
            
            if (op.model.giftCount != 0) {
                op.giftShowView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 300, self.parentView.frame.size.width / 2, 40);
                op.giftShowView.originFrame = op.giftShowView.frame;
                [self.queue1 addOperation:op];
            }
        }else {
            
            if (op.model.giftCount != 0) {
                op.giftShowView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 240, self.parentView.frame.size.width / 2, 40);
                op.giftShowView.originFrame = op.giftShowView.frame;
                [self.queue2 addOperation:op];
            }
        }
    }
    // 在没有用户礼物信息时
    else
    {   // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userId]!=nil) {
            AnimOperation *op = [self.operationCache objectForKey:userId];
            op.giftShowView.giftCount = model.giftCount;
            [op.giftShowView shakeNumberLabel];
            return;
        }
        
        AnimOperation *op = [AnimOperation animationOperationWithUserId:userId model:model finishedBlock:^(BOOL result, NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userId];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userId];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userId];
            });
            
        }];
        op.listView = self.parentView;
        op.index = [userId integerValue] % 2;
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userId];
        
        if ([userId integerValue] % 2) {
            
            if (op.model.giftCount != 0) {
                op.giftShowView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 300, self.parentView.frame.size.width / 2, 40);
                op.giftShowView.originFrame = op.giftShowView.frame;
                [self.queue1 addOperation:op];
            }
        }else {
            
            if (op.model.giftCount != 0) {
                op.giftShowView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 240, self.parentView.frame.size.width / 2, 40);
                op.giftShowView.originFrame = op.giftShowView.frame;
                [self.queue2 addOperation:op];
            }
        }
        
    }
}

/// 取消上一次的动画操作 暂时没用到
- (void)cancelOperationWithLastUserID:(NSString *)userID {
    // 当上次为空时就不执行取消操作 (第一次进入执行时才会为空)
    if (userID!=nil) {
        [[self.operationCache objectForKey:userID] cancel];
    }
}

@end
