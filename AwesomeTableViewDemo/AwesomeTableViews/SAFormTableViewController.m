#import "SAFormTableViewController.h"
#import "SAFormCellConfig.h"
#import "SAFormCell.h"

@interface SAFormTableViewController ()

@end

@implementation SAFormTableViewController
    @synthesize sections = _sections;

    - (void)viewDidLoad {
        [super viewDidLoad];
        _sections = [NSMutableArray array];
    }

    - (void)viewDidUnload {
        [super viewDidUnload];
    }

    #pragma mark - Table view data source

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        NSLog(@"number of sections, %d", [self.sections count]);
        return [self.sections count];
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [[[self.sections objectAtIndex:section] cells] count];
    }

    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        NSArray* cellsInSection = [[self.sections objectAtIndex:indexPath.section] cells];
        return [[cellsInSection objectAtIndex:indexPath.row] height];
    }

    - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return [[self.sections objectAtIndex:section] header].height;
    }

    - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return [[self.sections objectAtIndex:section] footer].height;
    }

    - (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
        return [[self.sections objectAtIndex:section] footer].title;    
    }

    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return [[self.sections objectAtIndex:section] header].title;
    }


    - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
        return [[self.sections objectAtIndex:section] footer].view;    
    }

    - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        return [[self.sections objectAtIndex:section] header].view;
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        SAFormCellConfig* formCell = [[[self.sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
        NSString* reuseIdent = [NSString stringWithFormat:@"%@%@", formCell.cellClass, formCell.cellStyle];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdent];
        
        if(cell == nil) {
            cell = [[formCell.cellClass alloc] initWithStyle:formCell.cellStyle reuseIdentifier:reuseIdent];
        }
        
        [formCell formatCell:(SAFormCell*)cell];
        
        return cell;
    }


    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        SAFormCellConfig* formCell = [[[self.sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
        if(formCell.selectedBlock) {
            formCell.selectedBlock(self.tableView, [self.tableView cellForRowAtIndexPath:indexPath], indexPath);   
        }
    }


    // TODO: revisit
    // the following objects set a reference to this tableviewon the section when is added
    // and remove the reference when removed.  This feels a little dirty, but its the best
    // I came up with right now... will revist later.
    - (SAFormSection*) addSection:(SAFormSection*) section {
        [self.sections addObject:section];
        if(section.tableView == nil) {
            section.tableView = self.tableView;
            section.sectionNumber = self.sections.count-1;
        }
        return section;
    }

    - (SAFormSection*) addSection:(SAFormSection*) section withAnimation:(BOOL)animation {
        [self addSection:section];
        NSIndexSet* index = [NSIndexSet indexSetWithIndex:self.sections.count-1];
        if(animation) {
            [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationNone];  
        }
        return section;
    }

    - (void) replaceSection:(SAFormSection*)oldSection withSection:(SAFormSection*)newSection {
        NSInteger ind = [self.sections indexOfObject:oldSection];
        [self replaceSectionAtIndex:ind withSection:newSection];
    }

    - (void) replaceSectionAtIndex:(NSInteger)ind withSection:(SAFormSection*)newSection {
        [self.sections replaceObjectAtIndex:ind withObject:newSection];
        NSIndexSet* set = [NSIndexSet indexSetWithIndex:ind];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    - (SAFormSection*) removeSectionAtIndex:(NSInteger) ind {
        SAFormSection* obj = [self.sections objectAtIndex:ind];
        [self.sections removeObjectAtIndex:ind];
        obj.tableView = nil;
        return obj;
    }

    - (SAFormSection*) removeSection:(SAFormSection*) section {
        [self.sections removeObject:section];
        section.tableView = nil;
        return section;
    }

@end


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

