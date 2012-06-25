@class SAFormCell;
@class SAFormCellConfig;
@class SAFormSection;

@interface SAFormTableViewController : UITableViewController
@property (strong, readonly) NSMutableArray* sections;

- (SAFormSection*) addSection:(SAFormSection*) section;
- (SAFormSection*) addSection:(SAFormSection*) section withAnimation:(BOOL)animation;

- (SAFormSection*) removeSection:(SAFormSection*) section;
- (SAFormSection*) removeSectionAtIndex:(NSInteger) ind;

- (void) replaceSection:(SAFormSection*)oldSection withSection:(SAFormSection*)newSection;
- (void) replaceSectionAtIndex:(NSInteger)ind withSection:(SAFormSection*)newSection;
@end
