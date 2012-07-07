

@interface SAFormHeaderFooter : NSObject
@property (strong) UIView* view;
@property (strong) NSString* title;
@property (assign) CGFloat height; 

- (id)initWithView:(UIView*)view;
- (id)initWithTitle:(NSString*)title;
@end