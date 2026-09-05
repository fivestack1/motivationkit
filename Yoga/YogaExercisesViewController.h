
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "YogaWorkoutViewController.h"

@interface YogaExercisesViewController : UIViewController{
    NSMutableArray *json;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@end
