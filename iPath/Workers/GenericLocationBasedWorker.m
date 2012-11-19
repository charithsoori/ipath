//
//  GenericLocationBasedWorker.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "GenericLocationBasedWorker.h"
#import "PPObjectionInjector.h"
#import "LocationService.h"

@implementation GenericLocationBasedWorker

objection_requires(@"locationService")

- (void)awakeFromObjection {
   // self.injector = [self.globalInjector createChildInjectorWithModule:[[JSObjectionModule alloc] init]];
    //[self registerDIClasses];
}

-(void)subscribeToLocationServices{
    [self.locationService subscribeForLocations:self];
}

-(void)unsubscribeFromLocationServices{
    [self.locationService unsubscribeForLocations:self];
}

- (void)newLocationReceived:(CLLocation *)newLocation {
}

- (void) registerDIClasses {
}

@end
