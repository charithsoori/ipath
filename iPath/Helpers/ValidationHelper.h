//
//  ValidationHelper.h
//  iPath


#import <Foundation/Foundation.h>

@interface ValidationHelper : NSObject{
    int shakeDirection;
    int numberOfShakes;
}

-(BOOL)validateWithTextField:(UITextField *)textField :(BOOL)colorTheField;
@end
