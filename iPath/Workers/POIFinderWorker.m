//
//  POIFinder.m
//  iPath
//
//  Created by Ramindu Weeraman on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "POIFinderWorker.h"

@interface POIFinderWorker()
@property(nonatomic) NSMutableArray *poiList;
@end

@implementation POIFinderWorker

int const POI_SEARCH_RANGE = 1000;

-(void)setPOIList:(NSMutableArray*)poiList{
    self.poiList = poiList;
}

-(void)startCapturingPois{
    [self subscribeToLocationServices];
    [self.genericLocationDelegate onStart];
}

-(void)stopCapturingPois{
    [self unsubscribeFromLocationServices];
    [self.genericLocationDelegate onStop];
}

- (void) newLocationReceived : (CLLocation *)newLocation{
    if (newLocation) {
        NSArray *nearByPOIList = [self getNearByPOIList:newLocation.coordinate];
        if(nearByPOIList.count !=0){
            [self.poiFinderWorkerDelegate nearbyPOIFound:nearByPOIList];
        }
    }
}

/*
- (void) locationUpdates:(NSNotification *)notification {
    
    if ([[notification object] isKindOfClass:[NSString class]]) {
        NSString *message = [notification object];
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:nil message:message
                                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"")
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
        
    }else if ([[notification object] isKindOfClass:[CLLocation class]])  {
        
        CLLocation *location = (CLLocation *)[notification object];
        
        if (location) {
            NSArray *nearByPOIList = [self getNearByPOIList:location.coordinate];
            if(nearByPOIList.count !=0){
                //Notify delegate
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POI_FOUND object:nearByPOIList];
            }
        }
    }
}*/

-(NSArray *)getNearByPOIList:(CLLocationCoordinate2D)coord{
    
    MKMapPoint currentPoint = MKMapPointForCoordinate(coord);
    NSMutableArray *nearByPoiList =[[NSMutableArray alloc]init];
    
    CLLocationDistance changedDistance = MKMetersBetweenMapPoints(prevPoint, currentPoint);
    
    // if user changed his location more than 1000m ,then again try to search near by POIs
    if(changedDistance < POI_SEARCH_RANGE){
        return nearByPoiList;
    }
    // assign current location -this is use to caluculate the distance
    prevPoint = currentPoint;
    
    for(int i=0; i < [self.poiList count]; i++){
        
        POIObject *obj = [self.poiList objectAtIndex:i];
        PointObject *point = obj.point;
        
        CLLocationCoordinate2D poi_coordinate = {  [point.latitude doubleValue], [point.longitude doubleValue]};
        MKMapPoint poiPoint = MKMapPointForCoordinate(poi_coordinate);
        
        CLLocationDistance metersApart = MKMetersBetweenMapPoints(poiPoint, currentPoint);
        
        // return POIs which are inside 1000m range to user's current location
        if(metersApart <= POI_SEARCH_RANGE){
            POIObject *poiObj=[[POIObject alloc]initWithDistance:[NSString stringWithFormat:@"%.2f Km", (metersApart / 1000)] description:obj.description POIPoint:point name:obj.name];
            [nearByPoiList addObject:poiObj];
        }
    }
    
    return nearByPoiList;
}

@end
