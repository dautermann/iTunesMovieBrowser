//
//  ITMSSearchTests.m
//  ITMSSearchTests
//
//  Created by Michael Dautermann on 6/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MovieObject.h"
#import "NSDate+Extension.h"

@interface ITMSSearchTests : XCTestCase

@end

@implementation ITMSSearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCreateMovieObject {
    NSDictionary *testMovieDictionary = @{ @"trackId" : @978943481, @"trackName" : @"Hardware Wars", @"releaseDate" : @"1977-05-25T07:00:00Z"};
    MovieObject *movieObject = [[MovieObject alloc] initWithDictionary:testMovieDictionary];
    
    XCTAssert([movieObject.name isEqualToString:testMovieDictionary[@"trackName"]], "movieName isn't what we expected");
    
    NSDate *releaseDate = [NSDate dateWithString:testMovieDictionary[@"releaseDate"]];
    XCTAssertEqual([movieObject.releaseDate timeIntervalSinceReferenceDate], [releaseDate timeIntervalSinceReferenceDate], "release date should be equal");
}

- (void)testDatesInMovieObject {
    NSDictionary *testMovieDictionary = @{ @"trackId" : @978943481, @"trackName" : @"Hardware Wars", @"releaseDate" : @"I am up to no good T07:00:00Z"};
    MovieObject *movieObject = [[MovieObject alloc] initWithDictionary:testMovieDictionary];
    
    XCTAssertNil(movieObject.releaseDate, "release date should be nil");
    
    testMovieDictionary = @{ @"trackId" : @978945481, @"trackName" : @"Some Other Movie"};
    
    XCTAssertNil(movieObject.releaseDate, "release date should be nil");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
