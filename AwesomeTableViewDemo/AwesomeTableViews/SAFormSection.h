
@class SAFormHeaderFooter;
@class SAFormCellConfig;

@interface SAFormSection : NSObject 
@property (strong, readonly) NSMutableArray* cells;
@property (strong) SAFormHeaderFooter* header;
@property (strong) SAFormHeaderFooter* footer;
@property (weak) UITableView* tableView;
@property (assign) NSInteger sectionNumber;

- (SAFormCellConfig*) addCell:(SAFormCellConfig*) cell;
- (SAFormCellConfig*) addCell:(SAFormCellConfig *)cell withAnimation:(BOOL)animate;

- (SAFormCellConfig*) insertCell:(SAFormCellConfig*)cell atIndex:(NSInteger) ind;
- (SAFormCellConfig*) insertCell:(SAFormCellConfig*)cell atIndex:(NSInteger) ind withAnimation:(BOOL)animate;

- (SAFormCellConfig*) removeCell:(SAFormCellConfig*) cell;
- (SAFormCellConfig*) removeCellAtIndex:(NSInteger) ind;
- (SAFormCellConfig*) removeCell:(SAFormCellConfig*)cell withAnimation:(BOOL)animate;
- (SAFormCellConfig*) removeCellAtIndex:(NSInteger)ind withAnimation:(BOOL)animate;
@end