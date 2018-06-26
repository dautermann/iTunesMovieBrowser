//
//  UIView+Extension.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Animation)

- (void)pushTransition:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition new];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:kCATransitionPush];
}

@end
