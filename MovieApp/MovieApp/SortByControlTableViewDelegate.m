#import "SortByControlTableViewDelegate.h"
#import "MainSortByTableViewCell.h"
#import "SortByDropDownTableViewCell.h"

#define NUMBER_OF_SECTIONS 2
#define MAIN_SECTION 0
#define DROPDOWN_SECTION 1
#define DEFAULT_CELL_HEIGHT 43.0f

@interface SortByControlTableViewDelegate (){
    NSUInteger _selectedIndex;
    BOOL _isDropDownActive;
    id<SelectedIndexChangeDelegate> _delegate;
}

@end

@implementation SortByControlTableViewDelegate

-(void)registerDelegate:(id<SelectedIndexChangeDelegate>)delegate{
    _delegate=delegate;
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==MAIN_SECTION){
        return 1;
    }
    else if(section==DROPDOWN_SECTION && _isDropDownActive){
        return [self.criterions count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==MAIN_SECTION){
        MainSortByTableViewCell *mainCell=[tableView dequeueReusableCellWithIdentifier:[MainSortByTableViewCell cellIdentifier] forIndexPath:indexPath];
        
        [mainCell setupWithCriterion:self.criterions[_selectedIndex] isDropDownActive:_isDropDownActive];
        return mainCell;
    }
    else if(indexPath.section==1){
        SortByDropDownTableViewCell *dropDownCell=[tableView dequeueReusableCellWithIdentifier:[SortByDropDownTableViewCell cellIdentifier] forIndexPath:indexPath];
        
        [dropDownCell setupWithCriterion:self.criterions[indexPath.row] isSelected:(indexPath.row==_selectedIndex)];
        return dropDownCell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isDropDownActive=!_isDropDownActive;
    if(indexPath.section==DROPDOWN_SECTION){
        _selectedIndex=indexPath.row;
        [_delegate selectedIndexChangedTo:_selectedIndex];
    }
    [tableView reloadData];
}

-(NSUInteger)getSelectedIndex{
    return _selectedIndex;
}

@end
