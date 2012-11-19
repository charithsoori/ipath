//
//  PPObjectionInjector.h
//  PagePlanner
//
//  Created by Dileepa Jayathilake on 10/18/12.
//  Copyright (c) 2012 99X Technology. All rights reserved.
//

#import "Objection.h"
#import "JSObjectionInjector.h"

@interface PPObjectionInjector : JSObjectionInjector
{
    
}

+ (PPObjectionInjector *) createInjectorWithModule : (JSObjectionModule *) module;
- (PPObjectionInjector *) createChildInjectorWithModule : (JSObjectionModule *) module;
- (void) bind:(id)instance toClass:(Class)aClass;
- (void) registerClass:(Class)theClass lifeCycle:(JSObjectionInstantiationRule)lifeCycle;
- (void) automaticallyRegisterClassesInTheLoadedBundle;

@property(strong) PPObjectionInjector *parent;

@end

id (^(^factoryTemplate) (PPObjectionInjector*, Class)) (void);
