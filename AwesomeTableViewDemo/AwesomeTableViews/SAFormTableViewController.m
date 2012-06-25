#import "SAFormTableViewController.h"
#import "SAFormCellConfig.h"
#import "SAFormCell.h"
#import "SAFormSection.h"
#import "SAFormHeaderFooter.h"

@implementation SAFormTableViewController

@synthesize sections = _sections;

- (void)viewDidLoad {
    [super viewDidLoad];
    _sections = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will apear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disapear");
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

