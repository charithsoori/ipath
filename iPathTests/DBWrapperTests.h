//
//  DBWrapperTests.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock.h>

#import "DBWrapper.h"
#import "FMDatabase.h"

@class DBWrapper;

@interface DBWrapperTests : SenTestCase

@property (nonatomic)DBWrapper *dbWrapper;
@property (nonatomic)id mockFMDB;
@end
