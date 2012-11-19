//
//  MapDetailViewController.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 10/30/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBWrapper.h"
#import "TrackDetail.h"

@protocol MapDetailViewControllerDelegate <NSObject>
@required
- (void)mapDetailSelectedWithTrack:(TrackDetail *)selectedTrack;
@end

@interface MapDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
   
}

@property (strong, nonatomic) IBOutlet UITableView *availableMapsTableView;
@property (nonatomic, weak) id <MapDetailViewControllerDelegate> mapDetailViewControllerDelegate;

-(void)initTrackList;
@end
