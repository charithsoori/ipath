//
//  DBWrapper.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/14/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//
/*
 This class hold all operations related to database
 */
#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Constants.h"
#import "MoreInfo.h"
#import "PointObject.h"
#import "FMDatabase.h"
#import "TrackDetail.h"
#import "PointObject.h"
#import "POIObject.h"

@interface DBWrapper : NSObject

@property (nonatomic)FMDatabase *db;

-(void)insertTrackWithLocations:(NSMutableArray*)locationList moreInfo:(MoreInfo *)moreInfo;
-(NSMutableArray *) getSavedTracksWithLocations;
-(NSMutableArray*) getPOIList;
@end
