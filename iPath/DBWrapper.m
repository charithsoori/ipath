//
//  DBWrapper.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/14/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "DBWrapper.h"

@interface DBWrapper ()

@end

@implementation DBWrapper

-(id)init{
    if ( ( self = [super init] ) ) {
        
        NSString *searchPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)
                                objectAtIndex:0];
        NSString *databasePath = [searchPath stringByAppendingPathComponent:DATABASE_NAME];

        self.db = [FMDatabase databaseWithPath:databasePath];
    }
    return self;
}

-(void)insertTrackWithLocations:(NSMutableArray*)locationList moreInfo:(MoreInfo *)moreInfo
{
    [self.db open];
    
    NSDictionary *argsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              moreInfo.trackFrom, @"track_from", moreInfo.trackTo, @"track_to",
                              moreInfo.duration, @"track_duration", moreInfo.distance, @"track_distance",
                              moreInfo.startTime, @"track_date",nil];
    
    [self.db executeUpdate:@"INSERT INTO tracks (track_from, track_to,track_duration,track_distance,track_date) VALUES (:track_from, :track_to,:track_duration,:track_distance,:track_date)" withParameterDictionary:argsDict];
    
    NSString *trackId = [NSString stringWithFormat:@"%llu",[self.db lastInsertRowId]];
    
    @autoreleasepool {
        
        for(int i=0; i< [locationList count]; i++){
            
            PointObject *point =(PointObject*)[locationList objectAtIndex:i];
            
            NSDictionary *argsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      trackId, @"track_id", point.latitude, @"latitude",
                                      point.longitude, @"longitude" ,nil];
            
            [self.db executeUpdate:@"INSERT INTO points (track_id, latitude, longitude) VALUES (:track_id, :latitude, :longitude)"
           withParameterDictionary:argsDict];
        }
    }
    
    [self.db close];
}

-(NSMutableArray *) getSavedTracksWithLocations{
    
    NSMutableArray *trackList =[[NSMutableArray alloc]init];
    
    [self.db open];
    FMResultSet *results = [self.db executeQuery:@"select * from tracks"];
    
    while([results next]) {
        
        NSInteger trackId = [results intForColumn:@"track_id"];
        
                
        MoreInfo *moreInfo =[[MoreInfo alloc] initWithDistance:[results stringForColumn:@"track_distance"] trackFrom:[results stringForColumn:@"track_from"] trackTo:[results stringForColumn:@"track_to"] duration:[results stringForColumn:@"track_duration"] startTime:[results stringForColumn:@"track_date"]];
        
        // get points list using track id
        NSMutableArray *pointArray = [self getSavedTrackPointsWithTrackId:trackId];
        if([pointArray count]>0){
            TrackDetail *trackDetail = [[TrackDetail alloc] initWithLocations:pointArray moreInfo:moreInfo];
            // add track into track list
            [trackList addObject:trackDetail];
        }
    }
    
    [self.db close];
    return trackList;
}

- (NSMutableArray*) getSavedTrackPointsWithTrackId:(NSInteger)trackID{
    NSMutableArray *pointArray =[[NSMutableArray alloc] init];
    
    // preapre sql statment for get points using track id
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM  points WHERE track_id=%i",trackID];
    FMResultSet *results = [self.db executeQuery:queryStatement];
    
    while([results next]) {
        // create point object using longitude and latitude values
        PointObject *point= [[PointObject alloc] initWithLatitude:[results stringForColumn:@"latitude"] longitude:[results stringForColumn:@"longitude"]];
        [pointArray addObject:point];
    }
    
    return pointArray;
}
//get point list related to track(saved track is drawing using this points)
-(NSMutableArray*) getPOIList{
    
    NSMutableArray *poiList =[[NSMutableArray alloc]init];
    [self.db open];
    FMResultSet *results = [self.db executeQuery:@"select * from poi_table"];
    while([results next]) {
        PointObject *point= [[PointObject alloc] initWithLatitude:[results stringForColumn:@"latitude"] longitude:[results stringForColumn:@"longitude"]];
        
        POIObject *poiObj =[[POIObject alloc] initWithName:[results stringForColumn:@"poi_name"] description:[results stringForColumn:@"poi_desc"] POIPoint:point];
        
        [poiList addObject:poiObj];      
    }
    
    [self.db close];
    return poiList;
}

@end
