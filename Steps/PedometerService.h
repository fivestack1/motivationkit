
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface PedometerService : NSObject

+ (instancetype)sharedManager;

- (void)startTracking;

- (void)getPastPedometerDataSince:(int)days;

- (void)getPedometerDataForday:(NSDate*)day;

@end
