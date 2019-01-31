//
//  LPActivityIndicator.h
//  Test
//
//  Created by Jack on 2019/1/31.
//  Copyright © 2019 Jack Template. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LPActivityType) {
    
    LPActivityTypeDot,
    LPActivityTypeSlash
};

@interface LPActivityIndicator : UIView

+ (instancetype)activityIndicatorWithType:(LPActivityType)type;/// 大小不可变，改变位置可调用setCenter:方法

@end

