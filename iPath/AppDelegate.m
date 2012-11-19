//
//  AppDelegate.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 10/30/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "AppDelegate.h"
#import "PageContentViewController.h"
#import "Constants.h"
#import "PPObjectionInjector.h"
#import "ApplicationController.h"
#import "LocationService.h"
#import "GenericLocationBasedWorker.h"
#import "POIFinderWorker.h"
#import "TrackWorker.h"
#import "MapViewController.h"
#import "MapDetailViewController.h"
#import "DBWrapper.h"
#import "ValidationHelper.h"

@implementation AppDelegate

@synthesize window,pageContentViewController;
@synthesize tracks;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PPObjectionInjector *injector = [self initializeGlobalDI];
    [self registerGlobalDI:injector];
    
    self.applicationController = [injector getObject:[ApplicationController class]];
    [self.applicationController initialize];
    
    [self checkAndCreateDatabase];
    
    [[NSBundle mainBundle] loadNibNamed:@"MainContentViewController" owner:self options:nil];
    self.pageContentViewController.injector = injector;
    [self.pageContentViewController initialize];
    [self.window addSubview:self.pageContentViewController.scrollView];
    [self.window makeKeyAndVisible];
    self.tracks = [[NSMutableDictionary alloc] init];
    
    return YES;
}

- (PPObjectionInjector *) initializeGlobalDI {
    PPObjectionInjector *globalInjector = [PPObjectionInjector createInjectorWithModule:[[JSObjectionModule alloc] init]];
    [globalInjector bind:globalInjector toClass:[PPObjectionInjector class]];
    [globalInjector bind:self toClass:[AppDelegate class]];
    
    return globalInjector;
}

- (void) registerGlobalDI : (PPObjectionInjector *)injector {
    [injector registerClass:[ApplicationController class] lifeCycle:JSObjectionInstantiationRuleSingleton];
    [injector registerClass:[LocationService class] lifeCycle:JSObjectionInstantiationRuleSingleton];
    [injector registerClass:[GenericLocationBasedWorker class] lifeCycle:JSObjectionInstantiationRuleNormal];
    [injector registerClass:[POIFinderWorker class] lifeCycle:JSObjectionInstantiationRuleNormal];
    [injector registerClass:[TrackWorker class] lifeCycle:JSObjectionInstantiationRuleNormal];
    [injector registerClass:[PageContentViewController class] lifeCycle:JSObjectionInstantiationRuleSingleton];
    [injector registerClass:[MapViewController class] lifeCycle:JSObjectionInstantiationRuleSingleton];
    [injector registerClass:[MapDetailViewController class] lifeCycle:JSObjectionInstantiationRuleSingleton];
    [injector registerClass:[DBWrapper class] lifeCycle:JSObjectionInstantiationRuleSingleton];
    [injector registerClass:[ValidationHelper class] lifeCycle:JSObjectionInstantiationRuleSingleton];
}

-( void ) checkAndCreateDatabase{
    
    //Check if the database exist, if not copy the database from resources
    NSString *searchPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	BOOL success;
    
	NSString *databasePath = [searchPath stringByAppendingPathComponent:DATABASE_NAME];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	success = [fileManager fileExistsAtPath:databasePath];
    
    //Verify if columns exist, if not create
	if(!success)
    {
        NSLog(@"DB does not exists, Copying");
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
}
@end
