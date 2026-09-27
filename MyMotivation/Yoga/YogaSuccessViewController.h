
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface YogaSuccessViewController : UIViewController{
    NSMutableArray *json;
}

- (IBAction)buttonShareAction:(id)sender;
- (IBAction)buttonHomeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelAward;

@property (weak, nonatomic) IBOutlet UIButton *buttonStar1;
@property (weak, nonatomic) IBOutlet UIButton *buttonStar2;
@property (weak, nonatomic) IBOutlet UIButton *buttonStar3;
@property (weak, nonatomic) IBOutlet UIButton *buttonStar4;
@property (weak, nonatomic) IBOutlet UIButton *buttonStar5;
- (IBAction)buttonStarAction1:(id)sender;
- (IBAction)buttonStarAction2:(id)sender;
- (IBAction)buttonStarAction3:(id)sender;
- (IBAction)buttonStarAction4:(id)sender;
- (IBAction)buttonStarAction5:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, assign) BOOL isMedt;
@property (nonatomic, assign) int exCount;
@property (nonatomic, assign) int rateCount;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelRate;

@end
