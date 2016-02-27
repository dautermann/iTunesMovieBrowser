/* this comes from http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/ */

//
//  UIImage+Extension.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AverageColor)

- (UIColor *)averageColor;

@end
