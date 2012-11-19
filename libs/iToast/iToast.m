//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast


- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
        toastBeingShown = NO;
        scheduledToastsText = nil;
        scheduledToastsDuration = nil;
	}
	
	return self;
}

- (id) initWithText:(NSString *) tex withFont:(UIFont*) textFont{
	if (self = [self initWithText:tex]) {
        textfont = [textFont retain];
        toastBeingShown = NO;
        scheduledToastsText = nil;
        scheduledToastsDuration = nil;
	}
	
	return self;
}

-(void) dealloc
{
    [textfont release];
    [scheduledToastsDuration release];
    [scheduledToastsText release];
    [super dealloc];
}

- (void) setText:(NSString *)tex {
    text = [tex copy];
}


 UIFont *font;

- (void) scheduleToast:(NSString *)tex forDuration:(NSInteger)duration {
    if (toastBeingShown) {
        if(scheduledToastsDuration == nil) {
            scheduledToastsDuration = [[NSMutableArray array] retain];
        }                
        [scheduledToastsDuration addObject:[NSNumber numberWithInteger:duration]];
        if(scheduledToastsText == nil) {
            scheduledToastsText = [[NSMutableArray array] retain];
        }
        [scheduledToastsText addObject:[tex copy]];
    }
    else {
        if(text != nil) {
            [text release];
        }
        [self setText:tex];
        [self setGravity:iToastGravityTop];
        [self setDuration:duration];
        [self show];
    }
}

- (void) show{
	
	iToastSettings *theSettings = _settings;
	
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
    if (textfont) {
        font = textfont;
    }else
        font = [UIFont systemFontOfSize:13];

	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 140)];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
	label.numberOfLines = 10;
	label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.textAlignment = UITextAlignmentCenter;
	
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
	v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
	//label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    //label.center = CGPointMake(round(v.frame.size.width/2)+0.5,round(v.frame.size.height/2)+0.5);
	[v addSubview:label];
    
    [label release];
	
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point ;
	
	if (theSettings.gravity == iToastGravityTop) {
		point = CGPointMake(window.frame.size.width / 2, 150);
	}else if (theSettings.gravity == iToastGravityBottom) {
		point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
	}else if (theSettings.gravity == iToastGravityCenter) {
		point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	}else{
		point = theSettings.postition;
	}
	
	point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
	v.center = point;
	
	NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	[window addSubview:v];
	
	view = [v retain];
	
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
    
    toastBeingShown = YES;
}

- (void) hideToastMessage {
    if(!toastBeingShown) {
        return;
    }
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
    toastBeingShown = NO;
}

- (void) resumeShowingToasts {
    if ((scheduledToastsDuration != nil) && ([scheduledToastsDuration count] > 0)) {
        
        
        NSNumber* duration = [[NSNumber alloc] initWithInt:[[scheduledToastsDuration objectAtIndex:0] intValue]];
        [scheduledToastsDuration removeObjectAtIndex:0];
        [self setDuration:[duration integerValue]];
        [duration release];
        [self setText:[scheduledToastsText objectAtIndex:0]];
        [scheduledToastsText removeObjectAtIndex:0];
        [self show];
    }
}

- (void) hideToast:(NSTimer*)theTimer{
    if(!toastBeingShown) {
        return;
    }
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
    toastBeingShown = NO;
	
	/*NSTimer *timer2 = [NSTimer timerWithTimeInterval:500 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];*/
    if ((scheduledToastsDuration != nil) && ([scheduledToastsDuration count] > 0)) {
        
        
        NSNumber* duration = [[NSNumber alloc] initWithInt:[[scheduledToastsDuration objectAtIndex:0] intValue]];
        [scheduledToastsDuration removeObjectAtIndex:0];
        [self setDuration:[duration integerValue]];
        [duration release];
        [self setText:[scheduledToastsText objectAtIndex:0]];
        [scheduledToastsText removeObjectAtIndex:0];
        [self show];
    }
    
}

- (void) removeToast:(NSTimer*)theTimer{
    if(view.superview)
        [view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[[iToast alloc] initWithText:_text] autorelease];
	
	return toast;
}

+ (iToast *) makeText:(NSString *) _text withTextSize:(UIFont *) _textFont{
	iToast *toast = [[[iToast alloc] initWithText:_text withFont:_textFont] autorelease];
	
	return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationShort;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end