//
//  DBWrapperTests.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "DBWrapperTests.h"

@implementation DBWrapperTests

- (void)setUp
{
    [super setUp];
    
    FMDatabase *db = [[FMDatabase alloc] init];
    self.mockFMDB = [OCMockObject partialMockForObject:db];
    
    self.dbWrapper = [[DBWrapper alloc] init];
    
    //Set the Mock Object
    self.dbWrapper.db = self.mockFMDB;
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testGetPOIList
{
    [[self.mockFMDB expect] executeQuery:@"select * from poi_table"];
    [self.dbWrapper getPOIList];
    [self.mockFMDB verify];
}

- (void)testGetSavedTrackPointsWithTrackId{
    [[self.mockFMDB expect] executeQuery:@"select * from tracks"];
    [self.dbWrapper getSavedTracksWithLocations];
    [self.mockFMDB verify];
}

@end
