
#import <UIKit/UIKit.h>
#import "HXCharts.h"
#import "GlobalState.h"
#import "DBManager.h"

@interface HeartActivityViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *arrayChart;
    HXBarChart *bar;
    int total_rates;
    int min_rate;
    int max_rate;
}

@property (weak, nonatomic) IBOutlet UIView *chartViewBlock;
@property (weak, nonatomic) IBOutlet UIView *viewTotal;
@property (weak, nonatomic) IBOutlet UIView *viewList;
@property (weak, nonatomic) IBOutlet UILabel *labelTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelAvg;
@property (weak, nonatomic) IBOutlet UILabel *labelMin;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;

@end
