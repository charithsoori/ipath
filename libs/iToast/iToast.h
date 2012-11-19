//
//  iToast.h
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum iToastGravity {
	iToastGravityTop = 1000001,
	iToastGravityBottom,
	iToastGravityCenter
}iToastGravity;

enum iToastDuration {
	iToastDurationLong = 10000,
	iToastDurationShort = 1500,
	iToastDurationNormal = 6000
}iToastDuration;

typedef enum iToastType {
	iToastTypeInfo = -100000,
	iToastTypeNotice,
	iToastTypeWarning,
	iToastTypeError
}iToastType;


@class iToastSettings;

@interface iToast : NSObject {
	iToastSettings *_settings;
	NSInteger offsetLeft;
	NSInteger offsetTop;
	
	NSTimer *timer;
	
	UIView *view;
	NSString *text;
    
    UIFont *textfont;
    NSMutableArray* scheduledToastsDuration;
    NSMutableArray* scheduledToastsText;
    BOOL toastBeingShown;
}

- (void) show;
-(void)removeToast:(NSTimer*)theTimer;
-(void) hideToastMessage;
-(void) resumeShowingToasts;

- (void) setText:(NSString*)tex;
- (iToast *) setDuration:(NSInteger ) duration;
- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			 offsetTop:(NSInteger) top;
- (iToast *) setGravity:(iToastGravity) gravity;
- (iToast *) setPostion:(CGPoint) position;

+ (iToast *) makeText:(NSString *) text;
+ (iToast *) makeText:(NSString *) _text withTextSize:(UIFont *) _textFont;
-(iToastSettings *) theSettings;

- (void)scheduleToast:(NSString *)text forDuration:(NSInteger)duration;

@end



@interface iToastSettings : NSObject<NSCopying>{
	NSInteger duration;
	iToastGravity gravity;
	CGPoint postition;
	iToastType toastType;
	
	NSDictionary *images;
	
	BOOL positionIsSet;
}

@property(assign) NSInteger duration;
@property(assign) iToastGravity gravity;
@property(assign) CGPoint postition;
@property(readonly) NSDictionary *images;

- (void) setImage:(UIImage *)img forType:(iToastType) type;
+ (iToastSettings *) getSharedSettings;
						  
@end