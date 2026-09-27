
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "GraphView.h"
#import "DBManager.h"
#import "ZZCircleProgress.h"

@interface StepsViewController : UIViewController{
    GraphView *graphView;
    NSArray *_values;
    long total_workouts;
    long total_time;
    float total_distance;
    long total_floors;
    long total_steps;
}

@property (strong, nonatomic) GraphView *graphView;

@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (strong, nonatomic) ZZCircleProgress *cprogressView;

- (IBAction)buttonStartAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleTotalSteps;
@property (weak, nonatomic) IBOutlet UILabel *labelGoal;
//@property (weak, nonatomic) IBOutlet UIView *historyGraph;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

@property (weak, nonatomic) IBOutlet UILabel *labelWorkouts;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelFloors;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelTsteps;
@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;

@end
