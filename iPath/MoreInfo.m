//
//  MoreInfo.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/13/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "MoreInfo.h"

@implementation MoreInfo

-(id)initWithDistance:(NSString*)distance trackFrom:(NSString*) trackFrom
              trackTo:(NSString*) trackTo duration:(NSString*) duration
            startTime:(NSString*) startTime
{
    self = [super init];
    if(self){
        self.distance = distance;
        self.trackFrom = trackFrom;
        self.trackTo = trackTo;
        self.duration = duration;
        self.startTime = startTime;
    }
    return self;
}
- (id) proxyForJson{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.distance, @"distance",
            self.trackFrom, @"trackFrom",
            self.trackTo, @"trackTo",
            self.duration, @"duration",
            self.startTime, @"startTime",
            nil];
}

- (void) parseResponse :(NSDictionary *) receivedObjects {
    self.distance = (NSString *) [receivedObjects objectForKey:@"distance"];
    self.trackFrom = (NSString *) [receivedObjects objectForKey:@"trackFrom"];
    self.trackTo = (NSString *) [receivedObjects objectForKey:@"trackTo"];
    self.duration = (NSString *) [receivedObjects objectForKey:@"duration"];
    self.startTime = (NSString *) [receivedObjects objectForKey:@"startTime"];
}
@end
