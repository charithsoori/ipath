//
//  TrackDetail.m
//  iPath
//
//  Created by Ramindu Weeraman on 31/10/2012.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "TrackDetail.h"

@implementation TrackDetail

-(id)initWithLocations:(NSMutableArray*)locationList moreInfo:(MoreInfo*)moreInfo{
    
    self = [super init];
    if(self){
        self.locationList = locationList;
        self.moreInfo = moreInfo;
    }
    
    return self;
}



@end
