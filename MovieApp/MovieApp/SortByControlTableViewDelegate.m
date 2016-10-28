#import "SortByControlTableViewDelegate.h"
#import "MainSortByTableViewCell.h"
#import "SortByDropDownTableViewCell.h"

#define NumberOfSections 2

@interface SortByControlTableViewDelegate (){
    NSUInteger _selectedIndex;
    BOOL _isDropDownActive;
    id<SelectedIndexChangeDelegate> _delegate;
}

@end

static CGFloat const DefaultCellHeight=43.0f;

enum{
    MainSection,
    DropdownSection
};

@implementation SortByControlTableViewDelegate

-(void)registerDelegate:(id<SelectedIndexChangeDelegate>)delegate{
    _delegate=delegate;
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NumberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==MainSection){
        return 1;
    }
    else if(section==DropdownSection && _isDropDownActive){
        return [self.criterions count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==MainSection){
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
    return DefaultCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isDropDownActive=!_isDropDownActive;
    if(indexPath.section==DropdownSection){
        _selectedIndex=indexPath.row;
        [_delegate selectedIndexChangedTo:_selectedIndex];
    }
    [tableView reloadData];
}

-(NSUInteger)getSelectedIndex{
    return _selectedIndex;
    
}

@end
