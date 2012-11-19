//
//  ApplicationControllerTests.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/19/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "ApplicationControllerTests.h"

@implementation ApplicationControllerTests

- (void)setUp
{
    [super setUp];
    
    self.applicationController = [[ApplicationController alloc] init];
    
    GenericLocationBasedWorker *locationWorker = [[GenericLocationBasedWorker alloc] init];
    self.mockGenericLocationBasedWorker = [OCMockObject partialMockForObject:locationWorker];
    
    //Set the Mock Object
    self.applicationController.genericLocationBasedWorker = self.mockGenericLocationBasedWorker;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetPOIList
{
    __block BOOL isServiceStarted = NO;
    
    [[[self.mockGenericLocationBasedWorker expect] andDo:^(NSInvocation *invocation) {
        isServiceStarted = YES;
        
    }] startLocationServices];
    
    
    [self.applicationController initialize];
    [self.mockGenericLocationBasedWorker verify];
    
    STAssertTrue(isServiceStarted, nil);
}

@end
