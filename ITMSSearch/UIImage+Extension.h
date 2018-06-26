/* this comes from http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/ */

//
//  UIImage+Extension.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIColor *)averageColor;
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;

@end
