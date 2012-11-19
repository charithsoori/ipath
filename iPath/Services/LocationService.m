//
//  LocationService.m
//  iNordecaCore
//
//  Created by Janidu Wanigasuriya on 10/9/12.
//  Purpose: A wrapper class to abstract location logic required

#import "LocationService.h"
#import "PPObjectionInjector.h"

@interface LocationService ()
@property(nonatomic)CLLocationManager *locationManager;
@end

@implementation LocationService

- (void)awakeFromObjection {
    subscribedLocationReceivers = [[NSMutableArray alloc] init];
    subscribedLocationErrorReceivers = [[NSMutableArray alloc] init];
}

- (void)subscribeForLocations:(id<LocationServiceDelegate>)locationReceiver {
    [subscribedLocationReceivers addObject:locationReceiver];
    [self initializeLocationServices];
}

- (void)unsubscribeForLocations:(id<LocationServiceDelegate>)locationReceiver {
    [subscribedLocationReceivers removeObject:locationReceiver];
    [self stopLocationService];
}

- (void) initializeLocationServices {
    if (subscribedLocationReceivers.count == 1) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            [self.locationManager startUpdatingLocation];
        }else{
            //Notify that services are disabled
            //TODO:Call error
            [self stopLocationService];
        }
    }
}

-(void)stopLocationService{
    if (subscribedLocationReceivers.count == 0) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    for (id item in subscribedLocationReceivers) {
        id<LocationServiceDelegate> locationReceiver = (id<LocationServiceDelegate>) item;
        [locationReceiver newLocationReceived:newLocation];
    }
}

-(void)subscribeForLocationErrors : (id<LocationErrorDelegate>) locationErrorReceiver{
    [subscribedLocationErrorReceivers addObject:locationErrorReceiver];
}

-(void)unsubscribeForLocationErrors : (id<LocationErrorDelegate>) locationErrorReceiver{
    [subscribedLocationErrorReceivers removeObject:locationErrorReceiver];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    for (id item in subscribedLocationErrorReceivers) {
        id<LocationErrorDelegate> locationErrorReceiver = (id<LocationErrorDelegate>) item;
        [locationErrorReceiver onLocationError:error];
    }
    
    [self stopLocationService];
    
    /*
     
     NSString *strError;
     if( [error domain] == kCLErrorDomain ) {
     switch([error code]) {
     case kCLErrorDenied:
     strError = @"Access to the location service was denied.";
     break;
     case kCLErrorLocationUnknown:
     strError = @"Was unable to obtain a location value right now.";
     break;
     default:
     strError = @"Location Error.";
     break;
     }
     } else {
     strError = [@"Error doamin: " stringByAppendingString: error.domain];
     strError = [[strError stringByAppendingString:@" Error Code: "]stringByAppendingString: [[NSNumber numberWithInteger:error.code] stringValue]];
     }
     
     //Notify failure
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATE object:strError];*/
}
@end
