
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface SuccessViewController : UIViewController{
    NSMutableArray *json;
}

- (IBAction)buttonShareAction:(id)sender;
- (IBAction)buttonHomeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelAward;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, assign) int exCount;
@property (nonatomic, assign) int calCount;
@property (nonatomic, assign) NSString *wType;
@property (nonatomic, assign) int wId;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
