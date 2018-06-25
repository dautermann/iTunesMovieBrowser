//
//  SFAlertController.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/29/16.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAlertController : NSObject

+ (SFAlertController *)sharedInstance;

- (BOOL)displayAlertIfPossible:(NSString *)alertString;

@end
