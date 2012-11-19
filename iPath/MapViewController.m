//
//  MapViewController.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 10/30/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "MapViewController.h"
#import "PPObjectionInjector.h"


@interface MapViewController ()
@property (nonatomic)LocationService *locationService;
@property (nonatomic)NSDate *startDate;
@property (nonatomic)NSString *startDateString;
@end

@implementation MapViewController

objection_requires(@"injector", @"validationHelper", @"dbWrapper", @"poiFinderWorker")

- (void)awakeFromObjection {
    self.trackWorkerFactory = factoryTemplate(self.injector, [TrackWorker class]);
}

- (void) onStart{
    
}

- (void) onStop{
    [self showTrackSaveView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //Start to find near by POIs
    NSMutableArray *poiList = [self.dbWrapper getPOIList];
    [self.poiFinderWorker setPOIList:poiList];
    
    [self.poiFinderWorker startCapturingPois];
    self.poiFinderWorker.poiFinderWorkerDelegate = self;

    [self addPOIAnnotations:poiList];
    isRecording = false;
    
    self.mapView.delegate = self;
}

-(void)addPOIAnnotations:(NSMutableArray *)pois{
    
    for (int i=0; i < pois.count; i++) {
        
        POIObject *obj = [pois objectAtIndex:i];
        PointObject *point = obj.point;
        
        double lat = [point.latitude doubleValue];
        double longi = [point.longitude doubleValue];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, longi);
        
        // Add the annotation to our map view
        MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc]
                                            initWithTitle:obj.description andCoordinate:location];
        [self.mapView addAnnotation:newAnnotation];
    }
}

- (void) nearbyPOIFound : (NSArray *)nearbyPOIList{
    
    for (int i = 0; i < nearbyPOIList.count; i++) {
        
        POIObject *poiObj = (POIObject*)[nearbyPOIList objectAtIndex:i];
        
        NSString *message = [NSString stringWithFormat:@"POI %@ with distance %@",
                             poiObj.description , poiObj.distanceTocurrentLocation];
        
        [self showToastWithMsg:message forDuration:iToastDurationNormal];
    }
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self zoomMapToCoordinate:userLocation.coordinate];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!self.trackWorker.crumbPathView) {
        self.trackWorker.crumbPathView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    return self.trackWorker.crumbPathView;
}

- (IBAction)clickSaveTrack:(id)sender {
    
    if([self.validationHelper validateWithTextField:self.trackFrom :YES]
       && [self.validationHelper validateWithTextField:self.trackTo :YES]){
        
        MoreInfo *moreInfo = [[MoreInfo alloc]
                              initWithDistance:self.distanceLabel.text trackFrom:self.trackFrom.text
                              trackTo:self.trackTo.text duration:self.durationLabel.text startTime:self.startDateString];
        
        [self.dbWrapper insertTrackWithLocations:self.trackWorker.locationList moreInfo:moreInfo];
        
        UIAlertView *savedAlert = [[UIAlertView alloc] initWithTitle:@"Track Saved" message:nil
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [savedAlert show];
        [self hideTrackSaveView];
    }
    [self onTrackSaveFinished];
}

- (void) onTrackSaveFinished {
    [self.trackWorker clearOverlay];
    self.trackWorker = nil;    
}

-(void)hideTrackSaveView{
    self.trackSaveView.hidden = YES;
    self.trackFrom.text = @"";
    self.trackTo.text = @"";
}

-(void)showTrackSaveView{
    
    float totalDistance = [self.trackWorker.crumbs getTotatlDistance];
    
    if(totalDistance > 0 ){
        
        self.trackSaveView.hidden = NO;
        self.trackSaveView.alpha = 0;
        
        [UIView animateWithDuration:0.1 animations:^{self.trackSaveView.alpha = 1.0;}];
        self.trackSaveView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.5],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:0.8],
                                  [NSNumber numberWithFloat:1.0], nil];
        
        bounceAnimation.duration = 0.3;
        bounceAnimation.removedOnCompletion = NO;
        [self.trackSaveView.layer addAnimation:bounceAnimation forKey:@"bounce"];
        self.trackSaveView.layer.transform = CATransform3DIdentity;
        
        //Set total distance
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", totalDistance/1000];
        
        //Set Start Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, hh:mm a"];
        self.startDateString = [dateFormatter stringFromDate:self.startDate];
        
        //Set Duration
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.startDate];
        NSString *duration = [NSString stringWithFormat:@"%02li:%02li",
                              lround(floor(time / 3600.)) % 100,
                              lround(floor(time / 60.)) % 60];
        
        self.durationLabel.text = duration;
    }
}


- (IBAction)clickCurrentLocation:(id)sender {
    
    if(isShowingSavedTrack){
        self.recordPathBtn.enabled = YES;
        [self.trackWorker clearOverlay];
    }
    
    CLLocationCoordinate2D currentLocation = [[[self.mapView userLocation] location] coordinate];
    [self.mapView setCenterCoordinate:currentLocation];
}

- (IBAction)clickRecordPath:(id)sender {
    
    isRecording = (!isRecording) ;
    
    if(isRecording){
        self.trackWorker = self.trackWorkerFactory();
        [self.trackWorker setMapView:self.mapView];
        self.trackWorker.genericLocationDelegate = self;
        [self.trackWorker startTracking];
        
        self.recordPathBtn.title = @"Stop";
        
        self.trackSaveView.hidden = YES;
        self.currentLocationBtn.enabled = NO;
        [self toggleRecordIndicator];
        
        // Save track recording start time
        self.startDate = [NSDate date];
    }
    else{
        [self.trackWorker stopTracking];
        //self.trackWorker = nil;
        
        self.recordPathBtn.title = @"Record";
        self.recordingIndicatorImage.hidden = YES;
        self.currentLocationBtn.enabled = YES;
        
        [self toggleRecordIndicator];
    }
}

-(void)drawTrack:(TrackDetail *)track{
    if (self.trackWorker) {
        [self.trackWorker clearOverlay];
    }
    self.trackWorker = self.trackWorkerFactory();
    [self.trackWorker setMapView:self.mapView];
    [self.trackWorker drawTrack:track];
    
    
    isShowingSavedTrack = YES;
    
    self.recordPathBtn.enabled = NO;
    self.recordPathBtn.title = @"Record";
    
    isRecording = NO;
    [self toggleRecordIndicator];
}


//Zoom map to a given coordinate
-(void)zoomMapToCoordinate:(CLLocationCoordinate2D) coordinate{
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coordinate,
                                       2000,
                                       2000);
    [self.mapView setRegion:region animated:YES];
}

-(void)toggleRecordIndicator{
    
    if (!isRecording) {
        self.recordingIndicatorImage.hidden = YES;
        self.recordingIndicatorImage.alpha  = 0.0;
        return;
    }else{
        self.recordingIndicatorImage.hidden = NO;
        self.recordingIndicatorImage.alpha  = 1.0;
    }
    
    [UIView animateWithDuration: 2.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.recordingIndicatorImage.alpha = !self.recordingIndicatorImage.alpha;
                     }
                     completion:^(BOOL finished) {
                         [self toggleRecordIndicator];
                     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField == self.trackFrom) {
        [self.trackTo becomeFirstResponder];
    } else if(textField == self.trackTo) {
       
        //Hide keyboard and submit
        [self.trackTo resignFirstResponder];
        [self clickSaveTrack:nil];
    }

    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)clickClose:(id)sender {
    self.trackSaveView.hidden = YES;
}

- (void) showToastWithMsg:(NSString *) message forDuration:(int) duration{
    if(self.genericToastMsg == nil) {
        self.genericToastMsg = [iToast makeText:message withTextSize:[UIFont systemFontOfSize:16]];
    }
    [self.genericToastMsg scheduleToast:message forDuration:duration];
}

- (void) onLocationError : (NSError *) error{
    
    NSString *strError;
    if( [error domain] == kCLErrorDomain ) {
        switch([error code]) {
            case kCLErrorDenied:
                strError = @"Access to the location service was denied.";
                break;
            case kCLErrorLocationUnknown:
                strError = @"Was unable to obtain a location value right now.";
                break;
            default:
                strError = @"Location Error.";
                break;
        }
    } else {
        strError = [@"Error doamin: " stringByAppendingString: error.domain];
        strError = [[strError stringByAppendingString:@" Error Code: "]stringByAppendingString: [[NSNumber numberWithInteger:error.code] stringValue]];
    }
    
    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:nil message:strError
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil];
    [servicesDisabledAlert show];
}

- (void)viewDidUnload {
    [self setCurrentLocationBtn:nil];
    [self setRecordPathBtn:nil];
    [self setRecordingIndicatorImage:nil];
    [self setBtnSaveTrack:nil];
    [self setTrackFrom:nil];
    [self setTrackFrom:nil];
    [self setTrackTo:nil];
    [self setTrackSaveView:nil];
    [self setTrackFrom:nil];
    [self setTrackTo:nil];
    [self setTrackFrom:nil];
    [self setTrackTo:nil];
    [self setDistanceLabel:nil];
    [self setDurationLabel:nil];
    [self setTimeLabel:nil];
    [self setTrackFrom:nil];
    [self setTrackTo:nil];
    [self setBtnClose:nil];
    [self setBtnSaveTrack:nil];
    [super viewDidUnload];
}

@end
