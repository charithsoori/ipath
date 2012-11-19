//
//  Path.h
//  iPath
//
//  Created by Ramindu Weeraman on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//
/*
 This class inherited from CrumbPath .This class have additional method to return total distance of the track
 */
#import <Foundation/Foundation.h>

#import "CrumbPath.h"

@interface Path : CrumbPath{
    double trackDistance;
     MKMapPoint *pointsList;
}
@property (nonatomic)NSMutableArray *pointList;
- (double)getTotatlDistance;
- (void)resetTotatlDistance;
-(id)initWithLocation:(CLLocationCoordinate2D)coord;
- (MKMapRect)addCoordinateToPath:(CLLocationCoordinate2D)coord;
@end
