#import <UIKit/UIKit.h>

@class SAFormCell;
@class SAFormCellConfig;

@interface SAFormHeaderFooter : NSObject
@property (strong) UIView* view;
@property (strong) NSString* title;
@property (assign) CGFloat height; 

- (id)initWithView:(UIView*)view;
- (id)initWithTitle:(NSString*)title;
@end

@interface SAFormSection : NSObject 
@property (strong, readonly) NSMutableArray* cells;
@property (strong) SAFormHeaderFooter* header;
@property (strong) SAFormHeaderFooter* footer;
@property (weak) UITableView* tableView;
@property (assign) NSInteger sectionNumber;

- (SAFormCellConfig*) addCell:(SAFormCellConfig*) cell;
- (SAFormCellConfig*)addCell:(SAFormCellConfig *)cell withAnimation:(BOOL)animate;

- (SAFormCellConfig*) insertCell:(SAFormCellConfig*) cell;
- (SAFormCellConfig*) insertCellAtIndex:(NSInteger) ind;
- (SAFormCellConfig*) insertCell:(SAFormCellConfig*)cell withAnimation:(BOOL)animate;
- (SAFormCellConfig*) insertCellAtIndex:(NSInteger)ind withAnimation:(BOOL)animate;

- (SAFormCellConfig*) removeCell:(SAFormCellConfig*) cell;
- (SAFormCellConfig*) removeCellAtIndex:(NSInteger) ind;
- (SAFormCellConfig*) removeCell:(SAFormCellConfig*)cell withAnimation:(BOOL)animate;
- (SAFormCellConfig*) removeCellAtIndex:(NSInteger)ind withAnimation:(BOOL)animate;
@end

@interface SAFormTableViewController : UITableViewController
@property (strong, readonly) NSMutableArray* sections;

- (SAFormSection*) addSection:(SAFormSection*) section;
- (SAFormSection*) addSection:(SAFormSection*) section withAnimation:(BOOL)animation;

- (SAFormSection*) removeSection:(SAFormSection*) section;
- (SAFormSection*) removeSectionAtIndex:(NSInteger) ind;

- (void) replaceSection:(SAFormSection*)oldSection withSection:(SAFormSection*)newSection;
- (void) replaceSectionAtIndex:(NSInteger)ind withSection:(SAFormSection*)newSection;
@end
