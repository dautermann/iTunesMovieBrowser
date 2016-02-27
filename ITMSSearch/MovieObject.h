//
//  MovieObject.h
//  ITMSSearch
//
//  Created by Michael Dautermann on 2/27/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieObject : NSObject

// these should just be readonly properties since
// the init method does all the setting
@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *director;
@property (strong, readonly) NSDate *releaseDate;
@property (strong, readonly) NSURL *posterSmallURL;
@property (strong, readonly) NSURL *posterMediumURL;
@property (strong, readonly) NSURL *posterBigURL;

- (instancetype) initWithDictionary: (NSDictionary *) movieDict;

@end
