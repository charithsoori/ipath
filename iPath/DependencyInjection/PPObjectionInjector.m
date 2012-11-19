//
//  PPObjectionInjector.m
//  PagePlanner
//
//  Created by Dileepa Jayathilake on 10/18/12.
//  Copyright (c) 2012 99X Technology. All rights reserved.
//

#import "pthread.h"
#import "PPObjectionInjector.h"

static pthread_mutex_t gObjectionMutex;
static NSMutableDictionary *gObjectionContext;

@implementation PPObjectionInjector

@synthesize parent;

+ (PPObjectionInjector *)createInjectorWithModule:(JSObjectionModule *)module {
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        return [[PPObjectionInjector alloc] initWithContext:gObjectionContext andModule:module];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex); 
    }
    
    return nil;
}

- (PPObjectionInjector *)createChildInjectorWithModule:(JSObjectionModule *)module {
    PPObjectionInjector *childInjector = nil;
    pthread_mutex_lock(&gObjectionMutex);
    @try {
        childInjector = [[PPObjectionInjector alloc] initWithContext:gObjectionContext andModule:module];
    }
    @finally {
        pthread_mutex_unlock(&gObjectionMutex); 
    }
    
    if (childInjector) {
        childInjector.parent = self;
    }
    
    return childInjector;
}

- (void) bind:(id)instance toClass:(Class)aClass  {
    if (!aClass) {
        return;
    }
    pthread_mutex_lock(&gObjectionMutex);
    NSString *key = NSStringFromClass(aClass);
    if ([_context objectForKey:key] == nil) {
        [_context setObject:[[JSObjectionBindingEntry alloc] initWithObject:instance] forKey:key];
    }
    pthread_mutex_unlock(&gObjectionMutex);
}

- (void) registerClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)lifeCycle {
    pthread_mutex_lock(&gObjectionMutex);
    if (lifeCycle != JSObjectionInstantiationRuleSingleton && lifeCycle != JSObjectionInstantiationRuleNormal) {
        @throw [NSException exceptionWithName:@"JSObjectionInjectorException" reason:@"Invalid Instantiation Rule" userInfo:nil];
    }
    
    if (theClass && [_context objectForKey:NSStringFromClass(theClass)] == nil) {
        [_context setObject:[JSObjectionInjectorEntry entryWithClass:theClass lifeCycle:lifeCycle] forKey:NSStringFromClass(theClass)];
    }
    pthread_mutex_unlock(&gObjectionMutex);
}

- (id)getObject:(id)classOrProtocol {
    id theObject = [super getObject:classOrProtocol];
    if (theObject) {
        return theObject;
    } else if (parent) {
        return [parent getObject:classOrProtocol];
    }
    return nil;
}

- (void)automaticallyRegisterClassesInTheLoadedBundle {
    int numberOfClasses = objc_getClassList(NULL, 0);   // get all classes including the ones in Cocoa frameworks
    void *classes = calloc(sizeof(Class), numberOfClasses);
    numberOfClasses = objc_getClassList((Class *)classes, numberOfClasses);
    for (int i = 0; i < numberOfClasses; ++i) {
        Class theClass = ((Class *)classes)[i];
        // Register only the classes that are in the main bundle
        if ([NSBundle bundleForClass:theClass] == [NSBundle mainBundle]) {
            [self registerClass:theClass lifeCycle:JSObjectionInstantiationRuleNormal];
        }
    }
    free(classes);
}

id (^(^factoryTemplate) (PPObjectionInjector*, Class)) (void) = ^(PPObjectionInjector *injector, Class cls) {return ^(void){return [injector getObject:cls];};};


@end
