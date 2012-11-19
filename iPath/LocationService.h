//
//  LocationService.h
//  iNordecaCore
//
//  Created by Janidu Wanigasuriya on 10/9/12.
//  Copyright (c) 2012 Norge-serien. All rights reserved.
//
//  Purpose: A wrapper class to abstract location logic required

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "LocationServiceDelegate.h"
#import "LocationErrorDelegate.h"

@interface LocationService : NSObject <CLLocationManagerDelegate>
{
    NSMutableArray *subscribedLocationReceivers;
    NSMutableArray *subscribedLocationErrorReceivers;
}

/**
 Invokes location services to figure out the current location. The caller should subscribe
 to notifications for the key NOTIFICATION_LOCATE. 
 
 If location services are disabled or if there is a failure obtaining the location, 
 an error message is returned.
 
 MAX_LOCATION_ATTEMPTS are performed to obtain the current location with the best accuracy.
 
 NOTE: A nil object is always notified to remove any notification subscriptions.
*/
-(void)subscribeForLocations : (id<LocationServiceDelegate>) locationReceiver;
-(void)unsubscribeForLocations : (id<LocationServiceDelegate>) locationReceiver;

-(void)subscribeForLocationErrors : (id<LocationErrorDelegate>) locationErrorReceiver;
-(void)unsubscribeForLocationErrors : (id<LocationErrorDelegate>) locationErrorReceiver;

@end
