//
//  MoreInfo.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/13/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//
/*
 This object hold more information related to track
 */
#import <Foundation/Foundation.h>

@interface MoreInfo : NSObject


-(id)initWithDistance:(NSString*)distance trackFrom:(NSString*) trackFrom
trackTo:(NSString*) trackTo duration:(NSString*) duration
            startTime:(NSString*) startTime;

@property(nonatomic)NSString *distance;
@property(nonatomic)NSString *trackFrom;
@property(nonatomic)NSString *trackTo;
@property(nonatomic)NSString *duration;
@property(nonatomic)NSString *startTime;
@end
