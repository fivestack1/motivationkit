
#import "DBManager.h"

@implementation DBManager

-(instancetype)initDatabase {
    self = [super init];
    if (self) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"myapp.db"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            const char *dbpath = [databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
            {
                char *errMsg;
                const char *sql_stmt = "CREATE TABLE IF NOT EXISTS FITNESSTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WID INTEGER, WTYPE INTEGER, WNAME TEXT, WDATE TEXT, WEXERCISES INTEGER, WCALORIES INTEGER, WTIME INTEGER, WDISTANCE INTEGER)";
                
                if (sqlite3_exec(myappDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Failed to create table");
                }
                
                const char *sql_stmt1 = "CREATE TABLE IF NOT EXISTS RUNTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WDATE TEXT, WDISTANCE INTEGER, WCALORIES INTEGER, WTIME INTEGER, WMIN FLOAT, WMAX FLOAT, WAVG FLOAT)";
                
                if (sqlite3_exec(myappDB, sql_stmt1, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Failed to create table");
                }
                
                const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS PEDOMETERTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WDATE TEXT, TIME INTEGER, DISTANCE FLOAT, STEPS INTEGER, FLOOR INTEGER)";
                
                if (sqlite3_exec(myappDB, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Failed to create table");
                }
                
                const char *sql_stmt3 = "CREATE TABLE IF NOT EXISTS WATERTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WDATE TEXT, VALUE FLOAT)";
                
                if (sqlite3_exec(myappDB, sql_stmt3, NULL, NULL, &errMsg) != SQLITE_OK){
                    NSLog(@"Failed to create table");
                }
                
                const char *sql_stmt4 = "CREATE TABLE IF NOT EXISTS YOGATABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WTYPE INTEGER, WNAME TEXT, WDATE TEXT, WSECONDS INTEGER, WHAPPY INTEGER, WENERGIES INTEGER, WID INTEGER, WTITLE TEXT, WTIME TEXT)";
                
                if (sqlite3_exec(myappDB, sql_stmt4, NULL, NULL, &errMsg) != SQLITE_OK){
                    NSLog(@"Failed to create table");
                }
                
                const char *sql_stmt5 = "CREATE TABLE IF NOT EXISTS HEARTTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WDATE TEXT, RATE INTEGER, TYPE INTEGER)";
                
                if (sqlite3_exec(myappDB, sql_stmt5, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Failed to create table runs");
                }
                
                const char *sql_stmt6 = "CREATE TABLE IF NOT EXISTS CALORIESTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WDATE TEXT, VALUE FLOAT, TYPE TEXT)";
                
                if (sqlite3_exec(myappDB, sql_stmt6, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Failed to create table");
                }
                
                const char *sql_stmt7 = "CREATE TABLE IF NOT EXISTS WEIGHTTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, WDATE TEXT, VALUE FLOAT)";
                
                if (sqlite3_exec(myappDB, sql_stmt7, NULL, NULL, &errMsg) != SQLITE_OK){
                    NSLog(@"Failed to create table");
                }
                
                sqlite3_close(myappDB);
            } else {
                NSLog(@"Failed to open/create database");
            }
        }
    }
    return self;
}

- (NSMutableArray *) loadTopItem:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    NSInteger counter = 0;
    NSInteger cexercises = 0;
    NSInteger cseconds = 0;
    NSInteger ccalories = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM FITNESSTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM FITNESSTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID DESC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                counter++;
                cexercises = cexercises + sqlite3_column_int(statement, 5);
                ccalories = ccalories + sqlite3_column_int(statement, 6);
                cseconds = cseconds + sqlite3_column_int(statement, 7);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    [arrItem addObject:[NSNumber numberWithInteger:cexercises]];
    [arrItem addObject:[NSNumber numberWithInteger:ccalories]];
    [arrItem addObject:[NSNumber numberWithInteger:cseconds]];
    [arrItem addObject:[NSNumber numberWithInteger:counter]];

    return arrItem;
}

- (NSMutableArray *) loadAllItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM FITNESSTABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM FITNESSTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM FITNESSTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 5)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 6)],
                                  [NSString stringWithFormat:@"%ld", (long)sqlite3_column_int(statement, 7)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

- (BOOL) updateItem:(NSInteger)wid onwtype:(NSInteger)wtype onwname:(NSString *)wname onwdate:(NSString *)wdate onwexercises:(NSInteger)wexercises onwcalories:(NSInteger)wcalories onwtime:(NSInteger)wtime {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
            
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO FITNESSTABLE (WID, WTYPE, WNAME, WDATE, WEXERCISES, WCALORIES, WTIME) VALUES ( \"%ld\", \"%ld\", \"%@\", \"%@\", \"%ld\", \"%ld\", \"%ld\")", wid, wtype, wname, wdate, wexercises, wcalories, wtime];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Items added");
            ckey = TRUE;
            
        } else {
            NSLog(@"Failed to add items");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    return ckey;
}

- (NSInteger) countTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSInteger lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM FITNESSTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (NSMutableArray *) loadRunTopItem:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    NSInteger counter = 0;
    float cdistance = 0;
    NSInteger cseconds = 0;
    NSInteger ccalories = 0;
    float cmin = 0;
    float cmax = 0;
    float cavg = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM RUNTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM RUNTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID DESC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                counter++;
                cdistance = cdistance + sqlite3_column_int(statement, 2);
                ccalories = ccalories + sqlite3_column_int(statement, 3);
                cseconds = cseconds + sqlite3_column_int(statement, 4);
                if (sqlite3_column_int(statement, 5) >= cmin) cmin = sqlite3_column_double(statement, 5);
                if (sqlite3_column_int(statement, 6) >= cmax) cmax = sqlite3_column_double(statement, 6);
                cavg = cavg + sqlite3_column_double(statement, 7);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    [arrItem addObject:[NSNumber numberWithInteger:cdistance]];
    [arrItem addObject:[NSNumber numberWithInteger:ccalories]];
    [arrItem addObject:[NSNumber numberWithInteger:cseconds]];
    [arrItem addObject:[NSNumber numberWithInteger:counter]];
    [arrItem addObject:[NSNumber numberWithFloat:cmin]];
    [arrItem addObject:[NSNumber numberWithFloat:cmax]];
    [arrItem addObject:[NSNumber numberWithFloat:cavg/counter]];

    return arrItem;
}

- (NSMutableArray *) loadRunAllItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM RUNTABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM RUNTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM RUNTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 3)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 4)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

- (BOOL) updateRunItem:(NSString *)wdate onwdistance:(int)wdistance onwcalories:(int)wcalories onwtime:(int)wtime onwmin:(float)wmin onwmax:(float)wmax onwavg:(float)wavg {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
            
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO RUNTABLE (WDATE, WDISTANCE, WCALORIES, WTIME, WMIN, WMAX, WAVG) VALUES ( \"%@\", \"%d\", \"%d\", \"%d\", \"%f\", \"%f\", \"%f\")", wdate, wdistance, wcalories, wtime, wmin, wmax, wavg];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Items added");
            ckey = TRUE;
            
        } else {
            NSLog(@"Failed to add items");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    return ckey;
}

- (NSInteger) countRunTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSInteger lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM RUNTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (BOOL) emptyRunDataBase {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL res = FALSE;
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM RUNTABLE"];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Database deleted");
            res = TRUE;
        }
        else {
            NSLog(@"Failed to delete");
        }
        sqlite3_finalize(statement);
        
        sqlite3_close(myappDB);
    }
    return res;
}

- (long) loadStepsHomeItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    long total_steps = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                long steps = sqlite3_column_int(statement, 4);
                
                total_steps = total_steps + steps;
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return total_steps;
}

- (NSArray *) loadStepsLastActivityItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    float dis1 = 0;
    float dis2 = 0;
    float dis3 = 0;
    float dis4 = 0;
    float dis5 = 0;
    float dis6 = 0;
    float dis7 = 0;
    float dis8 = 0;
    NSArray *points = @[@0,@0,@0,@0,@0,@0,@0,@0];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC LIMIT 8"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                if (dis1 == 0) { dis1 = sqlite3_column_int(statement, 4); }
                else if (dis2 == 0) { dis2 = sqlite3_column_int(statement, 4); }
                else if (dis3 == 0) { dis3 = sqlite3_column_int(statement, 4); }
                else if (dis4 == 0) { dis4 = sqlite3_column_int(statement, 4); }
                else if (dis5 == 0) { dis5 = sqlite3_column_int(statement, 4); }
                else if (dis6 == 0) { dis6 = sqlite3_column_int(statement, 4); }
                else if (dis7 == 0) { dis7 = sqlite3_column_int(statement, 4); }
                else if (dis8 == 0) { dis8 = sqlite3_column_int(statement, 4); }
                
            }
            
            points    = @[[NSNumber numberWithFloat:dis1], [NSNumber numberWithFloat:dis2], [NSNumber numberWithFloat:dis3], [NSNumber numberWithFloat:dis4], [NSNumber numberWithFloat:dis5], [NSNumber numberWithFloat:dis6], [NSNumber numberWithFloat:dis7], [NSNumber numberWithFloat:dis8]];
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return points;
    
}

- (NSMutableArray *) loadStepsAllItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)],
                                  [NSString stringWithFormat:@"%f", sqlite3_column_double(statement, 3)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 4)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 5)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

- (NSMutableArray *) loadStepsDataItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    NSInteger total_workouts = 0;
    NSInteger total_time = 0;
    float total_distance = 0;
    NSInteger total_steps = 0;
    NSInteger total_floors = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                long time = sqlite3_column_int(statement, 2);
                float distance = sqlite3_column_double(statement, 3);
                int steps = sqlite3_column_int(statement, 4);
                int floors = sqlite3_column_int(statement, 5);
                
                total_workouts++;
                total_time = total_time+time;
                total_distance = total_distance+distance;
                total_steps = total_steps + steps;
                total_floors = total_floors + floors;
                
            }
            
            [arrItem addObject:[NSNumber numberWithInteger:total_workouts]];
            [arrItem addObject:[NSNumber numberWithInteger:total_time]];
            [arrItem addObject:[NSNumber numberWithFloat:total_distance]];
            [arrItem addObject:[NSNumber numberWithInteger:total_steps]];
            [arrItem addObject:[NSNumber numberWithInteger:total_floors]];
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return arrItem;
}

- (NSMutableArray *) loadStepsLogTitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                [arrItems addObject:[NSString stringWithFormat:@"%@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return arrItems;
}

- (NSMutableArray *) loadStepsLogSubTitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                [arrItems addObject:[NSString stringWithFormat:@"%ld Steps", (long)sqlite3_column_int(statement, 4)]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return arrItems;
}

- (BOOL) saveStepsDataItem:(NSString *)date ontime:(long)time ondistance:(float)distance onsteps:(long)steps onfloors:(long)floors {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL tr = TRUE;

    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO PEDOMETERTABLE (wdate, time, distance, steps, floor) VALUES ( \"%@\", \"%ld\", \"%f\", \"%ld\", \"%ld\")", date, time, distance, steps, floors];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item added");
        } else {
            NSLog(@"Failed to add item");
            tr = FALSE;
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    return tr;
}

- (long) checkStepsDataItems:(int)cday onmonth:(int)cmonth onyear:(int)cyear {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    long currsteps = -1;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM PEDOMETERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                if (cyear == [components year]) {
                    if (cmonth == [components month]) {
                        if (cday == [components day]) {
                            currsteps = currsteps + sqlite3_column_int(statement, 4);
                            
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return currsteps;
}

- (int) countStepsTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM PEDOMETERTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (long) loadStepsTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    long water_total = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(STEPS) FROM PEDOMETERTABLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                water_total =  sqlite3_column_int(statement, 0);
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return water_total;
    
}

- (NSMutableArray *) loadWaterAllItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%f", sqlite3_column_double(statement, 2)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}
- (NSMutableArray *) loadLogTitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *tarr = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                //[titles addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                if ([Settings integerForKey:@"typeUnits"] == 0) {
                    [tarr addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                }
                else if ([Settings integerForKey:@"typeUnits"] == 1) {
                    [tarr addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                }
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return tarr;
    
}

- (NSMutableArray *) loadLogSubtitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *tarr = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                //[titles addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                if ([Settings integerForKey:@"typeUnits"] == 0) {
                    [tarr addObject:[NSString stringWithFormat:@"Water - %.1f Oz", sqlite3_column_double(statement, 2)]];
                }
                else if ([Settings integerForKey:@"typeUnits"] == 1) {
                    [tarr addObject:[NSString stringWithFormat:@"Water - %2.f Ml", sqlite3_column_double(statement, 2)*oztoml]];
                }
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return tarr;
    
}

- (double) loadWaterTopItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger cday = [components day];
    NSInteger cmonth = [components month];
    NSInteger cyear = [components year];
    
    double todayValue = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                if (cyear == [components1 year]) {
                    if (cmonth == [components1 month]) {
                        if (cday == [components1 day]) {
                            //ckey = TRUE;
                            todayValue = todayValue + sqlite3_column_double(statement, 2);
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return todayValue;
}

- (BOOL) checkWaterDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE WHERE id = (SELECT MAX(id) FROM WATER)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                
                if (cyear == [components year]) {
                    if (cmonth == [components month]) {
                        if (cday == [components day]) {
                            ckey = TRUE;
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return ckey;
}



- (void) deleteWaterDataItem {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM WATERTABLE WHERE id = (SELECT MAX(id) FROM WATER);"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item removed");
        } else {
            NSLog(@"Failed to remove item");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
}

- (void) saveWaterDataItem:(double)wvalue {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO WATERTABLE (wdate, value) VALUES ( \"%@\", \"%f\")", dateString, wvalue];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item added");
        } else {
            NSLog(@"Failed to add item");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    
}

- (int) loadWaterCountActivityItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int water_count = 0;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger aday = [components day];
    NSInteger amonth = [components month];
    NSInteger ayear = [components year];
    
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                if ((ayear == [components1 year]) & (amonth == [components1 month]) & (aday == [components1 day])) {
                    if (water_count == 0) water_count++;
                }
                else {
                    ayear = [components1 year];
                    amonth = [components1 month];
                    aday = [components1 day];
                    water_count++;
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return water_count;
}

- (int) countWaterTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM WATERTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (double) loadWaterLastActivityItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    double water_total =0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WATERTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                water_total = water_total + sqlite3_column_double(statement, 2);
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return water_total;
    
}


- (NSMutableArray *) loadYogaTopItem:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    NSInteger counter = 0;
    NSInteger cseconds = 0;
    NSInteger chappy = 0;
    NSInteger cegergies = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM YOGATABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM YOGATABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID DESC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                counter++;
                cseconds = cseconds + sqlite3_column_int(statement, 4);
                chappy = chappy + sqlite3_column_int(statement, 5);
                cegergies = cegergies + sqlite3_column_int(statement, 6);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    [arrItem addObject:[NSNumber numberWithInteger:cseconds]];
    [arrItem addObject:[NSNumber numberWithInteger:chappy]];
    [arrItem addObject:[NSNumber numberWithInteger:cegergies]];
    [arrItem addObject:[NSNumber numberWithInteger:counter]];

    return arrItem;
}

- (NSMutableArray *) loadYogaAllItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM YOGATABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM YOGATABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM YOGATABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 4)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 5)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 6)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 7)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}


- (BOOL) updateYogaItem:(NSInteger)wtype onwname:(NSString *)wname onwdate:(NSString *)wdate onwseconds:(NSInteger)wseconds onwhappy:(NSInteger)whappy onwenergies:(NSInteger)wenergies onwid:(NSInteger)wid onwtitle:(NSString *)wtitle onwtime:(NSString *)wtime {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
            
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO YOGATABLE (WTYPE, WNAME, WDATE, WSECONDS, WHAPPY, WENERGIES, WID, WTITLE, WTIME) VALUES ( \"%ld\", \"%@\", \"%@\", \"%ld\", \"%ld\", \"%ld\", \"%ld\", \"%@\", \"%@\")", wtype, wname, wdate, wseconds, whappy, wenergies, wid, wtitle, wtime];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Items added");
            ckey = TRUE;
            
        } else {
            NSLog(@"Failed to add items");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    return ckey;
}

- (NSInteger) countYogaTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSInteger lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM YOGATABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (NSMutableArray *) loadHeartLastActivityItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM HEARTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)],
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 3)],
                                  nil];
    
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

- (int) countHeartTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM HEARTTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (int) countHeartMinItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int min_rate = 1000;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM HEARTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                int rate = sqlite3_column_int(statement, 2);
        
                if (rate < min_rate) min_rate = rate;
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    if (min_rate == 1000) { min_rate = 0; }
    return min_rate;
}

- (int) countHeartMaxItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int max_rate = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM HEARTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                int rate = sqlite3_column_int(statement, 2);
                if (rate > max_rate) max_rate = rate;
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return max_rate;
}

- (NSMutableArray *) loadHeartLogTitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray *ttls = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM HEARTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                [ttls addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return ttls;
}

- (NSMutableArray *) loadHeartLogSubTitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray *sbttls = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM HEARTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);

                //[sbttls addObject:self getActivity:sqlite3_column_int(statement, 3)]];
                
                [sbttls addObject:[NSString stringWithFormat:@"Heart rate - %d ", sqlite3_column_int(statement, 2)]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return sbttls;
}

- (BOOL) saveHeartDataItem:(NSString *)date onrate:(long)rate ontype:(long)type {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    BOOL tr = TRUE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO HEARTTABLE (wdate, rate, type) VALUES ( \"%@\", \"%ld\",\"%ld\")", date, rate, type];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item added");
        } else {
            NSLog(@"Failed to add item");
            tr = FALSE;
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    return tr;
}

- (int) checkHeartDataItems:(int)cday onmonth:(int)cmonth onyear:(int)cyear {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int currbeat = 0;
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM HEARTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                
                if (cyear == [components year]) {
                    if (cmonth == [components month]) {
                        if (cday == [components day]) {
                            currbeat = sqlite3_column_int(statement, 2);
                            break;
                        }
                    }
                }
                
                //break;
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return currbeat;
}

- (NSMutableArray *) loadCaloriesLogItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%f", sqlite3_column_double(statement, 2)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

- (void) deleteCaloriesDataItem:(long)elem {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM CALORIESTABLE WHERE ID = \"%ld\"", elem];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) NSLog(@"Item deleted");
        else NSLog(@"Failed to delete item");
        sqlite3_finalize(statement);
        
        sqlite3_close(myappDB);
    }
}

- (void) deleteCaloriesDataItem1 {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM CALORIESTABLE WHERE id = (SELECT MAX(id) FROM CALORIES);"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item removed");
        } else {
            NSLog(@"Failed to remove item");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
}


- (void) saveCaloriesDataItem:(double)wvalue onval:(NSString *)wtype {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CALORIESTABLE (wdate, value, type) VALUES ( \"%@\", \"%f\", \"%@\")", dateString, wvalue, wtype];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item added");
        } else {
            NSLog(@"Failed to add item");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    
}

- (int) countCaloriesTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM CALORIESTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (double) countCaloriesSumItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    double lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(VALUE) FROM CALORIESTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_double(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (BOOL) checkCaloriesDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE WHERE id = (SELECT MAX(id) FROM CALORIES)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                
                if (cyear == [components year]) {
                    if (cmonth == [components month]) {
                        if (cday == [components day]) {
                            ckey = TRUE;
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return ckey;
}

- (double) loadCaloriesTopItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    double todayValue = 0;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger cday = [components day];
    NSInteger cmonth = [components month];
    NSInteger cyear = [components year];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                if (cyear == [components1 year]) {
                    if (cmonth == [components1 month]) {
                        if (cday == [components1 day]) {
                            //ckey = TRUE;
                            todayValue = todayValue + sqlite3_column_double(statement, 2);
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return todayValue;
}

- (NSMutableArray *) loadCaloriesTopItem:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    NSInteger counter = 0;
    NSInteger ccalories = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE WHERE WDATE = \"%@\" ORDER BY ID DESC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                counter++;
                ccalories = ccalories + sqlite3_column_double(statement, 2);
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    //[arrItem addObject:[NSNumber numberWithInteger:cdistance]];
    [arrItem addObject:[NSNumber numberWithInteger:ccalories]];
    //[arrItem addObject:[NSNumber numberWithInteger:cseconds]];
    [arrItem addObject:[NSNumber numberWithInteger:counter]];

    return arrItem;
}


- (void) emptyDataBase {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        const char *delete_stmt1 = [[NSString stringWithFormat:@"DELETE FROM FITNESSTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt1, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt2 = [[NSString stringWithFormat:@"DELETE FROM RUNTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt2, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt3 = [[NSString stringWithFormat:@"DELETE FROM PEDOMETERTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt3, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt4 = [[NSString stringWithFormat:@"DELETE FROM WATERTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt4, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt5 = [[NSString stringWithFormat:@"DELETE FROM YOGATABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt5, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt6 = [[NSString stringWithFormat:@"DELETE FROM HEARTTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt6, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt7 = [[NSString stringWithFormat:@"DELETE FROM CALORIESTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt7, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        const char *delete_stmt8 = [[NSString stringWithFormat:@"DELETE FROM WEIGHTTABLE"] UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt8, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) { NSLog(@"Fitness database deleted"); }
        else { NSLog(@"Failed to delete"); }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(myappDB);
    }
}

- (NSMutableArray *) loadWeightLogData:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID ASC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%.2f", sqlite3_column_double(statement, 2)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

/*- (NSMutableArray *) loadWeightLogTitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *tarr = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                //[titles addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                [tarr addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return tarr;
    
}

- (NSMutableArray *) loadWeightLogSubtitles {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *tarr = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                //[titles addObject:[NSString stringWithFormat:@"Date - %@", [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                if ([Settings boolForKey:@"profileImperial"]) {
                    [tarr addObject:[NSString stringWithFormat:@"Weight - %.1f lb", sqlite3_column_double(statement, 2)/lbtokg]];
                }
                else {
                    [tarr addObject:[NSString stringWithFormat:@"Weight - %2.f kg", sqlite3_column_double(statement, 2)]];
                }
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return tarr;
    
}

- (NSMutableArray *) loadWeightLogIds {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *tarr = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                [tarr addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)]];

            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return tarr;
    
}*/

- (double) loadWeightTopItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    double todayValue = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT VALUE FROM WEIGHTTABLE ORDER BY ID DESC LIMIT 1"];
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT VALUE FROM WEIGHTTABLE ORDER BY ID DESC WHERE instr(WDATE, \"%@\") > 0  LIMIT 1", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                todayValue = sqlite3_column_double(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return todayValue;
}

- (BOOL) checkWeightDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE WHERE id = (SELECT MAX(id) FROM WATER)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                
                if (cyear == [components year]) {
                    if (cmonth == [components month]) {
                        if (cday == [components day]) {
                            ckey = TRUE;
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return ckey;
}

- (void) deleteWeightDataItem:(long)elem {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM WEIGHTTABLE WHERE ID = \"%ld\"", elem];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) NSLog(@"Item deleted");
        else NSLog(@"Failed to delete item");
        sqlite3_finalize(statement);
        
        sqlite3_close(myappDB);
    }
}

- (void) saveWeightDataItem:(double)wvalue {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO WEIGHTTABLE (wdate, value) VALUES ( \"%@\", \"%f\")", dateString, wvalue];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item added");
        } else {
            NSLog(@"Failed to add item");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    
}

- (int) loadWeightCountActivityItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int water_count = 0;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger aday = [components day];
    NSInteger amonth = [components month];
    NSInteger ayear = [components year];
    
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                if ((ayear == [components1 year]) & (amonth == [components1 month]) & (aday == [components1 day])) {
                    if (water_count == 0) water_count++;
                }
                else {
                    ayear = [components1 year];
                    amonth = [components1 month];
                    aday = [components1 day];
                    water_count++;
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return water_count;
}

- (int) countWeightTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM WEIGHTTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (double) loadWeightLastActivityItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    double water_total =0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM WEIGHTTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                water_total = water_total + sqlite3_column_double(statement, 2);
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return water_total;
    
}








- (NSInteger) loadFitnessCalories:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSInteger vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(WCALORIES) FROM FITNESSTABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (NSInteger) loadRunDistance:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSInteger vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(WDISTANCE) FROM RUNTABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (NSInteger) loadStepsCount:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSInteger vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(STEPS) FROM PEDOMETERTABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (double) loadWaterCount:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    double vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(VALUE) FROM WATERTABLE WHERE WDATE = \"%@\"", wdate];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(VALUE) FROM WATERTABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (NSInteger) loadYogaTime:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSInteger vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(WSECONDS) FROM YOGATABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (double) loadCaloriesCount:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    double vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(VALUE) FROM CALORIESTABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (NSInteger) loadHeartCount:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSInteger vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(RATE) FROM HEARTTABLE WHERE instr(WDATE, \"%@\") > 0", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}

- (double) loadWeightCount:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    double vl = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(VALUE) FROM WATERTABLE WHERE WDATE = \"%@\"", wdate];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT VALUE FROM WEIGHTTABLE WHERE instr(WDATE, \"%@\") > 0 ORDER BY ID DESC LIMIT 1", wdate];
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                vl = sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }

    return vl;
}


- (NSMutableArray *) loadRelaxLogItems:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CALORIESTABLE ORDER BY ID DESC"];
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM RELAXTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM RELAXTABLE WHERE instr(RDATE, \"%@\") > 0 ORDER BY ID ASC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                NSArray *csarr = [[NSArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)],
                                  [NSString stringWithFormat:@"%f", sqlite3_column_double(statement, 2)],
                                  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)],
                                  nil];
                
                [arrItems addObject:csarr];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return arrItems;
}

- (void) deleteRelaxDataItem:(long)elem {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM RELAXTABLE WHERE ID = \"%ld\"", elem];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(myappDB, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) NSLog(@"Item deleted");
        else NSLog(@"Failed to delete item");
        sqlite3_finalize(statement);
        
        sqlite3_close(myappDB);
    }
}



- (void) saveRelaxDataItem:(long)wvalue onval:(long)wtype {
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO RELAXTABLE (rdate, rseconds, rworkout) VALUES ( \"%@\", \"%ld\", \"%ld\")", dateString, wvalue, wtype];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(myappDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Item added");
        } else {
            NSLog(@"Failed to add item");
        }
        sqlite3_finalize(statement);
        sqlite3_close(myappDB);
    }
    
}

- (int) countRelaxTotalItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    int lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM RELAXTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_int(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (double) countRelaxSumItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    double lastRowId = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(RSECONDS) FROM RELAXTABLE"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                lastRowId = sqlite3_column_double(statement, 0);
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    return lastRowId;
}

- (BOOL) checkRelaxDataItems:(long)cday onmonth:(long)cmonth onyear:(long)cyear {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    BOOL ckey = FALSE;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM RELAXTABLE WHERE id = (SELECT MAX(id) FROM RELAXTABLE)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                
                if (cyear == [components year]) {
                    if (cmonth == [components month]) {
                        if (cday == [components day]) {
                            ckey = TRUE;
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return ckey;
}

- (double) loadRelaxTopItems {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    double todayValue = 0;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger cday = [components day];
    NSInteger cmonth = [components month];
    NSInteger cyear = [components year];
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM RELAXTABLE ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                
                
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
                NSDate *myDate =[dateFormat dateFromString:date];
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:myDate];
                
                if (cyear == [components1 year]) {
                    if (cmonth == [components1 month]) {
                        if (cday == [components1 day]) {
                            //ckey = TRUE;
                            todayValue = todayValue + sqlite3_column_double(statement, 2);
                            //break;
                        }
                    }
                }
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    return todayValue;
}

- (NSMutableArray *) loadRelaxTopItem:(NSString *)wdate {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    NSInteger counter = 0;
    NSInteger ctime = 0;
    
    if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        if ([wdate isEqualToString:@""]) querySQL = [NSString stringWithFormat:@"SELECT * FROM RELAXTABLE ORDER BY ID DESC"];
        else querySQL = [NSString stringWithFormat:@"SELECT * FROM RELAXTABLE WHERE RDATE = \"%@\" ORDER BY ID DESC", wdate];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(myappDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //int uniqueID = sqlite3_column_int(statement, 0);
                counter++;
                ctime = ctime + sqlite3_column_double(statement, 2);
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myappDB);
    }
    
    //[arrItem addObject:[NSNumber numberWithInteger:cdistance]];
    [arrItem addObject:[NSNumber numberWithInteger:ctime]];
    //[arrItem addObject:[NSNumber numberWithInteger:cseconds]];
    [arrItem addObject:[NSNumber numberWithInteger:counter]];

    return arrItem;
}

- (void) createRelaxTable {
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"myapp.db"]];
    
    //NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //if ([filemgr fileExistsAtPath: databasePath ] == NO)
    //{
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &myappDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS RELAXTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, RDATE TEXT, RSECONDS INTEGER, RWORKOUT INTEGER)";
            
            if (sqlite3_exec(myappDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(myappDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    //}
}



@end
