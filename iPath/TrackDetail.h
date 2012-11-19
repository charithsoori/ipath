//
//  TrackDetail.h
//  iPath
//
//  Created by Ramindu Weeraman on 31/10/2012.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//
/*
 This object hold all information related to track eg.more information,point list
 */
#import <Foundation/Foundation.h>

#import "MoreInfo.h"

@interface TrackDetail : NSObject{
}

-(id)initWithLocations:(NSMutableArray*)locationList moreInfo:(MoreInfo*)moreInfo;

@property (nonatomic)NSMutableDictionary *pathInfo;
@property (nonatomic)NSMutableArray *locationList;
@property (nonatomic)MoreInfo *moreInfo;

@end
