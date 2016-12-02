//
//  GiftModel.h
//  GiftAnimation
//
//  Created by Pengbo on 2016/12/2.
//  Copyright © 2016年 Pengbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftModel : NSObject

/**
 送礼人头像
 */
@property (nonatomic,strong)UIImage * headImage;
/**
 礼物
 */
@property (nonatomic,strong)UIImage * giftImage;
/**
 送礼物的人
 */
@property (nonatomic,copy)NSString *name;
/**
 礼物名称
 */
@property (nonatomic,copy)NSString *giftName;
/**
 礼物数
 */
@property (nonatomic,assign)NSInteger giftCount;

@end
