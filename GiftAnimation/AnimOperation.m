//
//  AnimOperation.m
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#import "AnimOperation.h"

@interface AnimOperation ()
@property (nonatomic,getter=isFinished) BOOL finished;
@property (nonatomic,getter=isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);
@end
@implementation AnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+(instancetype)animationOperationWithUserId:(NSString *)userId model:(GiftModel *)model finishedBlock:(void (^)(BOOL, NSInteger))finishedBlock {
    AnimOperation *op = [AnimOperation new];
    op.giftShowView = [GiftShowView new];
    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init {
    if (self = [super init]) {
        _finished = NO;
        _executing = NO;
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _giftShowView.model = _model;
        _giftShowView.originFrame = _giftShowView.frame;
        [self.listView addSubview:_giftShowView];
        
        [self.giftShowView animateWithCompleteBlock:^(BOOL finished, NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];
    }];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}
@end
