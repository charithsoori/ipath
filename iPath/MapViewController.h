//
//  MapViewController.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 10/30/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PPObjectionInjector.h"
#import "DBWrapper.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "PointObject.h"
#import "MoreInfo.h"
#import "TrackDetail.h"
#import "TrackWorker.h"
#import "POIFinderWorker.h"
#import "ValidationHelper.h"
#import "MapViewAnnotation.h"
#import "TrackDetail.h"
#import "iToast.h"
#import "GenericLocationBasedWorker.h"
#import "GenericLocationBasedWorkerDelegate.h"
#import "LocationErrorDelegate.h"

typedef id (^InjectedObjectFactory) ();

@interface MapViewController : UIViewController<POIFinderWorkerDelegate,LocationErrorDelegate,MKMapViewDelegate,UITextFieldDelegate, GenericLocationBasedWorkerDelegate>{
@private
    BOOL isRecording;
    BOOL isShowingSavedTrack;
}

// injected properties
@property (strong) ValidationHelper *validationHelper;
@property (strong) DBWrapper *dbWrapper;
@property (strong) POIFinderWorker *poiFinderWorker;
@property (strong) InjectedObjectFactory trackWorkerFactory;
@property (strong) PPObjectionInjector *injector;

@property(nonatomic)iToast *genericToastMsg;
@property(nonatomic)TrackWorker *trackWorker;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *trackSaveView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *recordPathBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *currentLocationBtn;
@property (strong, nonatomic) IBOutlet UIImageView *recordingIndicatorImage;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UITextField *trackFrom;
@property (strong, nonatomic) IBOutlet UITextField *trackTo;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveTrack;

- (IBAction)clickSaveTrack:(id)sender;
- (IBAction)clickClose:(id)sender;
- (IBAction)clickCurrentLocation:(id)sender;
- (IBAction)clickRecordPath:(id)sender;

-(void)drawTrack:(TrackDetail *)track;
@end
