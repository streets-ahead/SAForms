#import "SAFormHeaderFooter.h"

@implementation SAFormHeaderFooter : NSObject
@synthesize view = _view;
@synthesize title = _title;
@synthesize height = _height; 
- (id)initWithView:(UIView*)view {
    self = [super init];
    if (self) {
        self.view = view;
        self.height = view.frame.size.height;
    }
    return self;
}

- (id)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.height = 22;
    }
    return self;
}
@end