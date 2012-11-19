//
//  AppDelegate.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 10/30/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ApplicationController.h"

@class PageContentViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic)IBOutlet UIWindow *window;
@property (strong, nonatomic)IBOutlet PageContentViewController *pageContentViewController;
@property (strong, nonatomic) NSMutableDictionary *tracks ;
@property (strong, nonatomic) ApplicationController *applicationController ;

@end
