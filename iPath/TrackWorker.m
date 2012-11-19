//
//  TrackService.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "TrackWorker.h"
#import "PPObjectionInjector.h"

@interface TrackWorker()

@end

@implementation TrackWorker

- (void)awakeFromObjection {
    self.locationList = [[NSMutableArray alloc] init];
}

-(void)setMapView:(MKMapView *)map{
    mapView = map;
}

-(void)startTracking{
    [self subscribeToLocationServices];
    [self.genericLocationDelegate onStart];
    
    [self resetDistance];
    [self clearOverlay];
    [self.locationList removeAllObjects];
}

-(void)stopTracking{
    [super unsubscribeFromLocationServices];
    [self.genericLocationDelegate onStop];
}

- (void) newLocationReceived : (CLLocation *)newLocation{
    if (newLocation) {
        PointObject *point = [[PointObject alloc]
                              initWithLatitude:[[NSString alloc] initWithFormat:@"%f°", newLocation.coordinate.latitude]
                              longitude:[[NSString alloc] initWithFormat:@"%f°", newLocation.coordinate.longitude]];
        
        [self.locationList addObject:point];
        
        if (!self.crumbs) {
            // This is the first time we're getting a location update, so create
            // the CrumbPath and add it to the map.
            self.crumbs = [[Path alloc] initWithLocation:newLocation.coordinate];
            [mapView addOverlay:self.crumbs];
            
            // On the first location update only, zoom map to user location
            [self zoomMapToCoordinate:newLocation.coordinate];
        } else {
            /// Move to view
            [self drawMapPath:newLocation];
        }
    }
}

-(void)clearOverlay{
    [mapView removeOverlay:self.crumbs];
    self.crumbPathView = nil;
    self.crumbs = nil;
}

-(void)resetDistance{
    [self.crumbs resetTotatlDistance];
}

-(void)drawTrack:(TrackDetail *)track{
    
    [self clearOverlay];
    
    //Get the start location
    PointObject *firstPoint = [track.locationList objectAtIndex:0];
    
    double lat = [firstPoint.latitude doubleValue];
    double longitude = [firstPoint.longitude doubleValue];
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:lat longitude:longitude];
    
    //Re initialize crumbs
    self.crumbs = [[Path alloc] initWithLocation:firstLocation.coordinate];
    [mapView addOverlay:self.crumbs];
    
    // On the first location update only, zoom map to user location
    [self zoomMapToCoordinate:firstLocation.coordinate];
    
    @autoreleasepool {
        for (int i=1; i < track.locationList.count; i++) {
            
            PointObject *point = [track.locationList objectAtIndex:i];
            
            double lat = [point.latitude doubleValue];
            double longitude = [point.longitude doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:longitude];
            
            [self drawMapPath:location];
        }
    }
}


/*
- (void) locationUpdates:(NSNotification *)notification {
    
    if ([[notification object] isKindOfClass:[NSString class]]) {
        NSString *message = [notification object];
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:nil message:message
                                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil];
        [servicesDisabledAlert show];
        
    }else if ([[notification object] isKindOfClass:[CLLocation class]])  {
        
        CLLocation *location = (CLLocation *)[notification object];
        
        if (location) {
            
            // Add location coordinate to list
            PointObject *point = [[PointObject alloc]
                                  initWithLatitude:[[NSString alloc] initWithFormat:@"%f°", location.coordinate.latitude]
                                  longitude:[[NSString alloc] initWithFormat:@"%f°", location.coordinate.longitude]];
            
            [self.locationList addObject:point];
            
            if (!self.crumbs) {
                // This is the first time we're getting a location update, so create
                // the CrumbPath and add it to the map.
                self.crumbs = [[Path alloc] initWithLocation:location.coordinate];
                [self.mapView addOverlay:self.crumbs];
                
                // On the first location update only, zoom map to user location
                [self zoomMapToCoordinate:location.coordinate];
            } else {
                /// Move to view
                [self drawMapPath:location];
            }
        }
    }
}*/

//Zoom map to a given coordinate
-(void)zoomMapToCoordinate:(CLLocationCoordinate2D) coordinate{
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate,
                                       2000,
                                       2000);
    [mapView setRegion:region animated:YES];
}

//Draws the given location in the map
-(void)drawMapPath:(CLLocation *)location{
    
    MKMapRect updateRect = [self.crumbs addCoordinateToPath:location.coordinate];
    if (!MKMapRectIsNull(updateRect)) {
        // There is a non null update rect.
        // Compute the currently visible map zoom scale
        MKZoomScale currentZoomScale = mapView.bounds.size.width / mapView.visibleMapRect.size.width;
        // Find out the line width at this zoom scale and outset the updateRect by that amount
        CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
        updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
        // Ask the overlay view to update just the changed area.
        [self.crumbPathView setNeedsDisplayInMapRect:updateRect];
    }
}
@end
