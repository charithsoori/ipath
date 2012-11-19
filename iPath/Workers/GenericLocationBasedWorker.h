//
//  GenericLocationBasedWorker.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "LocationServiceDelegate.h"

@class PPObjectionInjector;
@class LocationService;

@interface GenericLocationBasedWorker : NSObject <LocationServiceDelegate>

@property(nonatomic)LocationService *locationService;

//@property (strong) PPObjectionInjector *globalInjector;
//@property (strong) PPObjectionInjector *injector;

- (void) registerDIClasses;
-(void)subscribeToLocationServices;
-(void)unsubscribeFromLocationServices;
@end
