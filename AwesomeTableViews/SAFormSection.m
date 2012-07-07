//
// Copyright (c) 2012 Streets Ahead LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
// Software, and to permit persons to whom the Software is furnished to do so, subject 
// to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR 
// A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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

- (SAFormCellConfig*) insertCell:(SAFormCellConfig*)cell atIndex:(NSInteger) ind {
    [self.cells insertObject:cell atIndex:ind];
    return cell;
}

- (SAFormCellConfig*) insertCell:(SAFormCellConfig*)cell atIndex:(NSInteger) ind withAnimation:(BOOL)animate {
    [self insertCell:cell atIndex:ind];
    if(animate) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ind inSection:self.sectionNumber]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ind inSection:self.sectionNumber]] 
                              withRowAnimation:UITableViewRowAnimationNone];        
    }
    return cell;
    
}
@end
