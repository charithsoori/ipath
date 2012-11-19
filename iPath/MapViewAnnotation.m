//
//  MapViewAnnotation.m
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	
    self = [super init];
    
    if (self) {
        self.title = ttl;
        self.coordinate = c2d;
    }
    
	return self;
}
@end
