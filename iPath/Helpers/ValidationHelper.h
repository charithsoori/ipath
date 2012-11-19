//
//  ValidationHelper.h
//  iPath
//
//  Created by Janidu Wanigasuriya on 11/19/12.
//  Copyright (c) 2012 99XTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationHelper : NSObject{
    int shakeDirection;
    int numberOfShakes;
}

-(BOOL)validateWithTextField:(UITextField *)textField :(BOOL)colorTheField;
@end
