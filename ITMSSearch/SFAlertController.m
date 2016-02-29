//
//  SFAlertController.m
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/29/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import "SFAlertController.h"
#import <UIKit/UIKit.h>

// this isn't a real UIAlertController subclass because I'd like to manage
// when a UIAlertController is being displayed, and only display one at a time.
@interface SFAlertController ()

@property (strong) UIAlertController *visibleAlertController;

@end

@implementation SFAlertController

+ (id)sharedInstance
{
    static SFAlertController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL) displayAlertIfPossible: (NSString *)alertString
{
    if (self.visibleAlertController == nil)
    {
        self.visibleAlertController = [[UIAlertController alloc] init];
        if (self.visibleAlertController)
        {
            self.visibleAlertController.title = @"Alert";
            self.visibleAlertController.message = alertString;
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     self.visibleAlertController = nil;
                                 }];
            [self.visibleAlertController addAction:ok]; // add action to uialertcontroller
            
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            if (keyWindow != nil)
            {
                [[keyWindow rootViewController] presentViewController:self.visibleAlertController animated:TRUE completion:nil];
            }
            
            return YES;
        }
    }
    return NO;
}

@end
