//
//  NSDate+Extension.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (NSDate_Extension)

+ (NSDate *) dateWithString: (NSString *)dateString
{
    // wish I could name this method as `dateFromString`, but there's a
    // deprecated method with the same name and I want better control
    // over what parsed and how it's parsed
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 2013-11-18T23:00:00.324Z
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];

    NSDate *dateToReturn = [dateFormatter dateFromString:dateString];
    
    return dateToReturn;
}

- (NSString *) yearAsString
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    
    return [NSString stringWithFormat:@"%ld", [components year]];
}

@end
