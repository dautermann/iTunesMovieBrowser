//
//  NSDate+Extension.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Extension)

+ (NSDate *)dateWithString:(NSString *)dateString;

- (NSString *)yearAsString;

@end
