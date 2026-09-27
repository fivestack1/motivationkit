
#import <Foundation/Foundation.h>
#import "GlobalState.h"

@interface DBManager : NSObject

-(instancetype)initDatabase;

- (void) emptyDataBase;

/*  Fitness  */
- (NSMutableArray *) loadTopItem:(NSString *)wdate;
- (NSMutableArray *) loadAllItems:(NSString *)wdate;
- (BOOL) updateItem:(NSInteger)wid onwtype:(NSInteger)wtype onwname:(NSString *)wname onwdate:(NSString *)wdate onwexercises:(NSInteger)wexercises onwcalories:(NSInteger)wcalories onwtime:(NSInteger)wtime;
- (NSInteger) countTotalItems;

/*  Run  */
- (NSMutableArray *) loadRunTopItem:(NSString *)wdate;
- (NSMutableArray *) loadRunAllItems:(NSString *)wdate;
- (BOOL) updateRunItem:(NSString *)wdate onwdistance:(int)wdistance onwcalories:(int)wcalories onwtime:(int)wtime onwmin:(float)wmin onwmax:(float)wmax onwavg:(float)wavg;
- (NSInteger) countRunTotalItems;
- (BOOL) emptyRunDataBase;

/*  Steps  */
- (long) loadStepsHomeItems;
- (NSArray *) loadStepsLastActivityItems;
- (NSMutableArray *) loadStepsAllItems:(NSString *)wdate;
- (NSMutableArray *) loadStepsDataItems;
- (NSMutableArray *) loadStepsLogTitles;
- (NSMutableArray *) loadStepsLogSubTitles;
- (BOOL) saveStepsDataItem:(NSString *)date ontime:(long)time ondistance:(float)distance onsteps:(long)steps onfloors:(long)floors;
- (long) checkStepsDataItems:(int)cday onmonth:(int)cmonth onyear:(int)cyear;
- (int) countStepsTotalItems;
- (long) loadStepsTotalItems;

/*  Water  */
- (NSMutableArray *) loadWaterAllItems:(NSString *)wdate;
- (NSMutableArray *) loadLogTitles;
- (NSMutableArray *) loadLogSubtitles;
- (double) loadWaterTopItems;
- (BOOL) checkWaterDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear;
- (void) deleteWaterDataItem;
- (void) saveWaterDataItem:(double)wvalue;
- (int) loadWaterCountActivityItems;
- (int) countWaterTotalItems;
- (double) loadWaterLastActivityItems;

/* Yoga */
- (NSMutableArray *) loadYogaTopItem:(NSString *)wdate;
- (NSMutableArray *) loadYogaAllItems:(NSString *)wdate;
- (BOOL) updateYogaItem:(NSInteger)wtype onwname:(NSString *)wname onwdate:(NSString *)wdate onwseconds:(NSInteger)wseconds onwhappy:(NSInteger)whappy onwenergies:(NSInteger)wenergies onwid:(NSInteger)wid onwtitle:(NSString *)wtitle onwtime:(NSString *)wtime;
- (NSInteger) countYogaTotalItems;

/* Heart */
- (NSMutableArray *) loadHeartLastActivityItems;
- (int) countHeartTotalItems;
- (int) countHeartMinItems;
- (int) countHeartMaxItems;
- (NSMutableArray *) loadHeartLogTitles;
- (NSMutableArray *) loadHeartLogSubTitles;
- (BOOL) saveHeartDataItem:(NSString *)date onrate:(long)rate ontype:(long)type;
- (int) checkHeartDataItems:(int)cday onmonth:(int)cmonth onyear:(int)cyear;

/* Food Calories */
- (NSMutableArray *) loadCaloriesLogItems:(NSString *)wdate;
- (void) deleteCaloriesDataItem:(long)elem;
- (void) deleteCaloriesDataItem1;
- (void) saveCaloriesDataItem:(double)wvalue onval:(NSString *)wtype;
- (int) countCaloriesTotalItems;
- (double) countCaloriesSumItems;
- (BOOL) checkCaloriesDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear;
- (double) loadCaloriesTopItems;
- (NSMutableArray *) loadCaloriesTopItem:(NSString *)wdate;

/*  Weight Tracker  */
//- (NSMutableArray *) loadWeightLogTitles;
//- (NSMutableArray *) loadWeightLogSubtitles;
//- (NSMutableArray *) loadWeightLogIds;
- (NSMutableArray *) loadWeightLogData:(NSString *)wdate;
- (double) loadWeightTopItems;
- (BOOL) checkWeightDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear;
- (void) deleteWeightDataItem:(long)elem;
- (void) saveWeightDataItem:(double)wvalue;
- (int) loadWeightCountActivityItems;
- (int) countWeightTotalItems;
- (double) loadWeightLastActivityItems;

/*  Relax Sounds  */
- (NSMutableArray *) loadRelaxLogItems:(NSString *)wdate;
- (void) deleteRelaxDataItem:(long)elem;
- (void) saveRelaxDataItem:(long)wvalue onval:(long)wtype;
- (int) countRelaxTotalItems;
- (double) countRelaxSumItems;
- (BOOL) checkRelaxDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear;
- (double) loadRelaxTopItems;
- (NSMutableArray *) loadRelaxTopItem:(NSString *)wdate;
- (void) createRelaxTable;

- (NSInteger) loadFitnessCalories:(NSString *)wdate;
- (NSInteger) loadRunDistance:(NSString *)wdate;
- (NSInteger) loadStepsCount:(NSString *)wdate;
- (double) loadWaterCount:(NSString *)wdate;
- (NSInteger) loadYogaTime:(NSString *)wdate;
- (double) loadCaloriesCount:(NSString *)wdate;
- (NSInteger) loadHeartCount:(NSString *)wdate;
- (double) loadWeightCount:(NSString *)wdate;

@end
