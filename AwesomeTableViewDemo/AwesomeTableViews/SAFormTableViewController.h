@class SAFormCell;
@class SAFormCellConfig;
@class SAFormSection;

@interface SAFormTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, readonly) NSMutableArray* sections;
@property (strong) UIToolbar* keyboardAccessoryBar;
@property (assign) BOOL addKeyboardAccessroy;
@property (strong, readonly) SAFormCell* currentFirstResponder;

- (SAFormSection*) addSection:(SAFormSection*) section;
- (SAFormSection*) addSection:(SAFormSection*) section withAnimation:(BOOL)animation;

- (SAFormSection*) removeSection:(SAFormSection*) section;
- (SAFormSection*) removeSectionAtIndex:(NSInteger) ind;

- (void) removeSectionAtIndex:(NSInteger)ind withAnimation:(BOOL)animate;

- (void) replaceSection:(SAFormSection*)oldSection withSection:(SAFormSection*)newSection;
- (void) replaceSectionAtIndex:(NSInteger)ind withSection:(SAFormSection*)newSection;

- (void) keyboardWillShow:(NSNotification*)notification;

- (void) registerFirstResponder:(SAFormCell*)cell;
- (void) deRegisterFirstResponder:(SAFormCell*)cell;
- (void) doneEditing;
- (SAFormCell*) cellForView:(UIView*)view;
@end
