//
//  Path.m
//  iPath
//
//  Created by Ramindu Weeraman on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "Path.h"

@implementation Path

-(id)initWithLocation:(CLLocationCoordinate2D)coord;
{
    self = [super initWithCenterCoordinate:coord];   
  
    return self;
} 

-(double) getTotatlDistance{
    return trackDistance;
}

- (void)resetTotatlDistance{
    trackDistance = 0;
}

- (MKMapRect)addCoordinateToPath:(CLLocationCoordinate2D)coord{
    
    MKMapRect updateRect = MKMapRectNull;   
    MKMapPoint newPoint = MKMapPointForCoordinate(coord);
    MKMapPoint prevPoint = super.points[super.pointCount - 1];
    
    CLLocationDistance metersApart = MKMetersBetweenMapPoints(newPoint, prevPoint);
    
    trackDistance += metersApart;

    updateRect = [self addCoordinate:coord];

    return updateRect;
}

@end
