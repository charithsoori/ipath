//
//  GenericLocationBasedWorkerDelegate.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/16/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GenericLocationBasedWorkerDelegate <NSObject>

- (void) onStart;
- (void) onStop;

@end
