//
//  TrackService.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "CrumbPath.h"
#import "Path.h"
#import "CrumbPathView.h"
#import "LocationService.h"
#import "PointObject.h"
#import "TrackDetail.h"
#import "GenericLocationBasedWorkerDelegate.h"
#import "GenericLocationBasedWorker.h"

@interface TrackWorker : GenericLocationBasedWorker{
    MKMapView *mapView;
}

@property(nonatomic)Path *crumbs;
@property(nonatomic)CrumbPathView *crumbPathView;
@property(nonatomic)NSMutableArray *locationList;
@property(nonatomic,weak) id<GenericLocationBasedWorkerDelegate> genericLocationDelegate;

-(void)startTracking;
-(void)stopTracking;
-(void)setMapView:(MKMapView *)map;
-(void)drawTrack:(TrackDetail *)track;
-(void)clearOverlay;
-(void)resetDistance;
@end
