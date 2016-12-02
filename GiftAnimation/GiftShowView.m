//
//  GiftShowView.m
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//
#define SelfWidth (self.frame.size.width)
#define SelfHeight (self.frame.size.height)
#define SelfX (self.frame.origin.x)
#define SelfY (self.frame.origin.y)
#import "GiftShowView.h"

@interface GiftShowView()
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)NSTimer *timer;
/**
 finishCount用来记录动画结束时累加的数量,3秒内继续累加
 */
@property (nonatomic,copy)void(^completeBlock)(BOOL finished,NSInteger finishCount);

@end

@implementation GiftShowView

- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        
    }
    return self;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SelfHeight, SelfHeight)];
        _headImageView.layer.borderWidth = 1;
        _headImageView.layer.borderColor = [UIColor cyanColor].CGColor;
        _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UIImageView *)giftImageView {
    if (_giftImageView == nil) {
        _giftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SelfWidth-50, SelfHeight-50, 50, 50)];
    }
    return _giftImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SelfHeight+5, 5, SelfHeight*3, 10)];
        _nameLabel.textColor  = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

- (UILabel *)giftLabel {
    if (_giftLabel == nil) {
        _giftLabel = [[UILabel alloc]initWithFrame:CGRectMake(SelfHeight+5, CGRectGetMaxY(_headImageView.frame)-15, SelfHeight*3, 10)];
        _giftLabel.textColor  = [UIColor yellowColor];
        _giftLabel.font = [UIFont systemFontOfSize:13];
    }
    return _giftLabel;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        
        _bgImageView = [UIImageView new];
        _bgImageView.backgroundColor = [UIColor blackColor];
        _bgImageView.frame = self.bounds;
        _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.alpha = 0.3;
    }
    return _bgImageView;
}

- (ShakeLabel *)shakeLabel {
    if (_shakeLabel == nil) {
        _shakeLabel = [[ShakeLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)+5, -20, 50, 50)];
        _shakeLabel.font = [UIFont systemFontOfSize:16];
        _shakeLabel.borderColor = [UIColor yellowColor];
        _shakeLabel.textColor = [UIColor greenColor];
        _shakeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shakeLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = self.frame;
    [self setUI];
}

-(void)setUI {
    _animCount = 0;
    [self addSubview:self.bgImageView];
    [self addSubview:self.headImageView];
    [self addSubview:self.giftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.giftLabel];
    [self addSubview:self.shakeLabel];
    
}

-(void)setModel:(GiftModel *)model {
    _model = model;
    self.headImageView.image = model.headImage;
    self.giftImageView.image = model.giftImage;
    self.nameLabel.text = model.name;
    self.giftLabel.text = [NSString stringWithFormat:@"送了%@",model.giftName];
    self.giftCount = model.giftCount;
}

//滑出
-(void)animateWithCompleteBlock:(completeBlock)completed {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SelfY, SelfWidth, SelfHeight);
    }completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

-(void)shakeNumberLabel {
    _animCount++;
    //取消延迟执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];
    [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:12];
    
    self.shakeLabel.text = [NSString stringWithFormat:@"X %ld",_animCount];
    [self.shakeLabel startAnimationWithDuration:0.3];
    
}

-(void)hidePresendView {
    
    [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, SelfY-20, SelfWidth, SelfHeight);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,_animCount);
        }
        [self reset];
        _finished = finished;
        [self removeFromSuperview];
    }];
}

//重置
- (void)reset {
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.shakeLabel.text = @"";
}

@end
