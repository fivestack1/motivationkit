
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface RunSuccessViewController : UIViewController{
    NSMutableArray *json;
}

- (IBAction)buttonShareAction:(id)sender;
- (IBAction)buttonHomeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelAward;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, assign) float disCount;
@property (nonatomic, assign) int calCount;
@property (nonatomic, assign) int secCount;
@property (nonatomic, assign) float minCount;
@property (nonatomic, assign) float maxCount;
@property (nonatomic, assign) float avgCount;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
