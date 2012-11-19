//
//  ValidationHelper.m
//  iPath

#import "ValidationHelper.h"

@implementation ValidationHelper

-(BOOL)validateWithTextField:(UITextField *)textField :(BOOL)colorTheField{

    if(textField){
        
        if(textField.text.length == 0){
            if (colorTheField) {
                [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                
                shakeDirection = 1;
                numberOfShakes = 0;
                [self shake:textField];
            }
            return NO;
        }
    }
    return YES;
}

-(void)shake:(UIView *)view{
    
    [UIView animateWithDuration:0.07 animations:^
     {
         view.transform = CGAffineTransformMakeTranslation(5*shakeDirection, 0);
     }
                     completion:^(BOOL finished)
     {
         if(numberOfShakes >= 15)
         {
             view.transform = CGAffineTransformIdentity;
             return;
         }
         numberOfShakes++;
         shakeDirection = shakeDirection * -1;
         [self shake:view];
     }];
}
@end
