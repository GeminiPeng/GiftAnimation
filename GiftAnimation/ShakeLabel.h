//
//  ShakeLabel.h
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeLabel : UILabel

/**
 动画时间
 */
@property (nonatomic,assign)NSTimeInterval duration;

/**
 描边颜色
 */
@property (nonatomic,strong)UIColor *borderColor;

- (void)startAnimationWithDuration:(NSTimeInterval)duration;
@end
