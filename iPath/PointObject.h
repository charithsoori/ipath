//
//  PointObject.h
//  iPath
//
//  Created by Ramindu Weeraman on 11/12/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//
/*
 This object hold longitude and latitude value of point on the track
 */
#import <Foundation/Foundation.h>

@interface PointObject : NSObject

-(id)initWithLatitude:(NSString*)lat longitude:(NSString*) longitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;
@end
