//
//  POIObject.m
//  iPath
//
//  Created by Ramindu Weeraman on 11/15/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "POIObject.h"

@implementation POIObject

-(id)initWithName:(NSString*)name description:(NSString*) desc POIPoint:(PointObject*)point
{
    self = [super init];
    if(self){
        self.name = name;
        self.description = desc;
        self.point=point;
    
    }
    return self;
}

-(id)initWithDistance:(NSString*)distanceTocurrentLocation description:(NSString*)desc POIPoint:(PointObject*)point name:(NSString*)name{

    self = [super init];
    if(self){
        self.name = name;
        self.description = desc;
        self.point = point;
        self.point = point;
        self.distanceTocurrentLocation = distanceTocurrentLocation;
        
    }
    return self;
}
@end
