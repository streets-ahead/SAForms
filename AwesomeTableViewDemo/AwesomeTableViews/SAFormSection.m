#import "SAFormSection.h"
#import "SAFormHeaderFooter.h"
#import "SAFormCellConfig.m"


@implementation SAFormSection : NSObject 
@synthesize cells = _cells;
@synthesize header = _header;
@synthesize footer = _footer;
@synthesize tableView = _tableView;
@synthesize sectionNumber = _sectionNumber;

- (id)init {
    self = [super init];
    if (self) {
        _cells = [NSMutableArray array];
    }
    return self;
}

- (SAFormCellConfig*)addCell:(SAFormCellConfig *)cell {
    [self.cells addObject:cell];
    return cell;
}

- (SAFormCellConfig*)addCell:(SAFormCellConfig *)cell withAnimation:(BOOL)animate {
    [self addCell:cell];
    NSIndexPath* path = [NSIndexPath indexPathForRow:self.cells.count-1 inSection:self.sectionNumber];
    if(animate) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    return cell;
}

- (SAFormCellConfig*) removeCell:(SAFormCellConfig*) cell {
    NSInteger ind = [self.cells indexOfObject:cell];
    [self removeCellAtIndex:ind];
    return cell;
}

- (SAFormCellConfig*) removeCellAtIndex:(NSInteger) ind {
    SAFormCellConfig* cell = [self.cells objectAtIndex:ind];    
    [self.cells removeObjectAtIndex:ind];
    return cell;
}

- (SAFormCellConfig*) removeCell:(SAFormCellConfig*)cell withAnimation:(BOOL)animate {
    NSInteger ind = [self.cells indexOfObject:cell];
    [self removeCellAtIndex:ind withAnimation:animate];
    return cell;
}

- (SAFormCellConfig*) removeCellAtIndex:(NSInteger)ind withAnimation:(BOOL)animate {
    SAFormCellConfig* cell = [self removeCellAtIndex:ind];
    NSIndexPath* path = [NSIndexPath indexPathForRow:ind inSection:self.sectionNumber];
    if(animate) {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    }
    return cell;
}

- (SAFormCellConfig*) insertCell:(SAFormCellConfig*) cell {
    @throw [NSException exceptionWithName:@"MethodNotImplemented" reason:@"this will be implemented later" userInfo:nil];
}

- (SAFormCellConfig*) insertCellAtIndex:(NSInteger) ind {
    @throw [NSException exceptionWithName:@"MethodNotImplemented" reason:@"this will be implemented later" userInfo:nil];
}

- (SAFormCellConfig*) insertCell:(SAFormCellConfig*)cell withAnimation:(BOOL)animate {
    @throw [NSException exceptionWithName:@"MethodNotImplemented" reason:@"this will be implemented later" userInfo:nil];
}

- (SAFormCellConfig*) insertCellAtIndex:(NSInteger)ind withAnimation:(BOOL)animate {
    @throw [NSException exceptionWithName:@"MethodNotImplemented" reason:@"this will be implemented later" userInfo:nil];
}
@end
