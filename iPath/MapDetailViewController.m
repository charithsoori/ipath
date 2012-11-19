//
//  MapDetailViewController.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 10/30/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "MapDetailViewController.h"
#import "TrackDetail.h"
#import "PointObject.h"


@interface MapDetailViewController ()

@end

@implementation MapDetailViewController

@synthesize availableMapsTableView;
@synthesize mapDetailViewControllerDelegate;
NSMutableArray *trackList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.availableMapsTableView.delegate = self;
    [self initTrackList];
}

-(void)initTrackList{
    DBWrapper *dbWrapper = [[DBWrapper alloc] init];
    trackList = [dbWrapper getSavedTracksWithLocations];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [trackList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TrackDetail *track =[trackList objectAtIndex:indexPath.row];
    [self.mapDetailViewControllerDelegate mapDetailSelectedWithTrack:track];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
    }
    
    TrackDetail *track =[trackList objectAtIndex:indexPath.row];
    
    //set text for track name
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@", [track.moreInfo trackFrom],@"-",[track.moreInfo trackTo]];
    
    
    // set more details about track
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", [track.moreInfo distance],@"-",[track.moreInfo duration],@"-",[track.moreInfo startTime]];
    
    
    UIImage *theImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Map-icon" ofType:@"png"]];
    cell.imageView.image = theImage;
    
    return cell;
}



@end
