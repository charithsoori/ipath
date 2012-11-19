//
//  ApplicationController.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericLocationBasedWorker.h"

@class DBWrapper;

@interface ApplicationController : NSObject

@property (strong) DBWrapper *dbWrapper;
@property (strong) GenericLocationBasedWorker *genericLocationBasedWorker;

- (void) initialize;
@end
