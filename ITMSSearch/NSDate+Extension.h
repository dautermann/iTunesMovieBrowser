//
//  NSDate+Extension.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Extension)

+ (NSDate *)dateWithString:(NSString *)dateString;

- (NSString *)yearAsString;

@end
