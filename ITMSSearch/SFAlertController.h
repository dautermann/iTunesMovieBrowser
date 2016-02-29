//
//  SFAlertController.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/29/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAlertController : NSObject

+ (id)sharedInstance;

- (BOOL)displayAlertIfPossible:(NSString *)alertString;

@end
