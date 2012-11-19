//
//  PointObject.m
//  iPath
//
//  Created by Ramindu Weeraman on 11/12/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "PointObject.h"

@implementation PointObject

-(id)initWithLatitude:(NSString*)lat longitude:(NSString*) longitude;
{
    self = [super init];
    if(self){
        self.latitude = lat;
        self.longitude = longitude;
    }
    
    return self;
}


@end