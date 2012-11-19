//
//  ApplicationControllerTests.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/19/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock.h>

#import "ApplicationController.h"
#import "GenericLocationBasedWorker.h"

@interface ApplicationControllerTests : SenTestCase

@property (nonatomic)ApplicationController *applicationController;
@property (nonatomic)id mockGenericLocationBasedWorker;
@end
