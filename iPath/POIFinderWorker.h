//
//  POIFinder.h
//  iPath
//
//  Created by Ramindu Weeraman on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "POIObject.h"
#import "PointObject.h"
#import "DBWrapper.h"
#import "LocationService.h"
#import "GenericLocationBasedWorkerDelegate.h"
#import "GenericLocationBasedWorker.h"
#import "POIFinderWorkerDelegate.h"

@interface POIFinderWorker : GenericLocationBasedWorker{
    MKMapPoint prevPoint;
}

extern int const POI_SEARCH_RANGE;

@property(nonatomic,weak) id<GenericLocationBasedWorkerDelegate> genericLocationDelegate;
@property(nonatomic,weak) id<POIFinderWorkerDelegate> poiFinderWorkerDelegate;

-(void)setPOIList:(NSMutableArray*)poiList;
-(void)startCapturingPois;
-(void)stopCapturingPois;
@end
