//
//  POIFinderWorkerDelegate.h
//  iPath
//
//  Created by Dileepa Jayathilake on 11/19/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol POIFinderWorkerDelegate <NSObject>
- (void) nearbyPOIFound : (NSArray *)nearbyPOIList;
@end
