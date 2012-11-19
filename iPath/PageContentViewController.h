
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MapDetailViewController.h"

@class MapViewController;
@class PPObjectionInjector;

@interface PageContentViewController :UIViewController <UIScrollViewDelegate, MapDetailViewControllerDelegate>
{   
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic,strong) MapViewController *mapViewController;
@property (nonatomic,strong) MapDetailViewController *mapDetailViewController;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *viewControllers;
@property(nonatomic)PPObjectionInjector *injector;

- (void) initialize;
- (IBAction)changePage:(id)sender;
@end