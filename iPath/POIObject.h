//
//  POIObject.h
//  iPath
//
//  Created by Ramindu Weeraman on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//
/*
 This object hold all information related to POI
 */
#import <Foundation/Foundation.h>
#import "PointObject.h"

@interface POIObject : NSObject

-(id)initWithName:(NSString*)name description:(NSString*)desc POIPoint:(PointObject*)point;
-(id)initWithDistance:(NSString*)distanceTocurrentLocation description:(NSString*)desc
             POIPoint:(PointObject*)point name:(NSString*)name;

@property(nonatomic)NSString *distanceTocurrentLocation;
@property(nonatomic)NSString *name;
@property(nonatomic)NSString *description;
@property(nonatomic)PointObject *point;
@end
