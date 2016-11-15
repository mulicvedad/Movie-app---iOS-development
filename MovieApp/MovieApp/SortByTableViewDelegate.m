#import "SortByTableViewDelegate.h"
#import "MainSortByTableViewCell.h"
#import "SortByDropDownTableViewCell.h"

#define NumberOfSectionsInTable 2
#define TvEventsPageSize 20

enum{
    SortByTableMainSection,
    SortByTableDropdownSection
};

@interface SortByTableViewDelegate (){
    id<SelectedIndexChangeDelegate> _callbackDelegate;
    NSArray *_criteriaForSorting;
    BOOL _isDropdownActive;
    NSUInteger _selectedIndex;
    MainSortByTableViewCell *_mainCell;
}

@end

static CGFloat const SortByTableDefaultCellHeight=43.0f;

@implementation SortByTableViewDelegate

-(void)configureWithCriteriaForSorting:(NSArray *)criteria selectionHandlerDelegate:(id<SelectedIndexChangeDelegate>)delegate{
    _criteriaForSorting=criteria;
    _callbackDelegate=delegate;
    
    [self.sortByControlTableView registerNib:[UINib nibWithNibName:[MainSortByTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[MainSortByTableViewCell cellIdentifier]];
    [self.sortByControlTableView registerNib:[UINib nibWithNibName:[SortByDropDownTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SortByDropDownTableViewCell cellIdentifier]];
    
    _mainCell=[self.sortByControlTableView dequeueReusableCellWithIdentifier:[MainSortByTableViewCell cellIdentifier]];
    _mainCell.selectionStyle=UITableViewCellSelectionStyleNone;

}

-(void)setCriteriaForSorting:(NSArray *)criteria{
    _criteriaForSorting=criteria;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NumberOfSectionsInTable;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==SortByTableMainSection){
        return 1;
    }
    else if(section==SortByTableDropdownSection && _isDropdownActive){
        return [_criteriaForSorting count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==SortByTableMainSection){
        [_mainCell setupWithCriterion:_criteriaForSorting[_selectedIndex] isDropDownActive:_isDropdownActive];
        return _mainCell;
    }
    else if(indexPath.section==1){
        SortByDropDownTableViewCell *dropDownCell=[tableView dequeueReusableCellWithIdentifier:[SortByDropDownTableViewCell cellIdentifier] forIndexPath:indexPath];
        
        [dropDownCell setupWithCriterion:_criteriaForSorting[indexPath.row] isSelected:(indexPath.row==_selectedIndex)];
        return dropDownCell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SortByTableDefaultCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isDropdownActive=!_isDropdownActive;
    if(indexPath.section==SortByTableDropdownSection){
        _selectedIndex=indexPath.row;
        [_callbackDelegate selectedIndexChangedTo:_selectedIndex];
    }
    [self.sortByControlTableView reloadData];
    CGRect frame = self.sortByControlTableView.frame;
    frame.size.height = self.sortByControlTableView.contentSize.height;
    self.sortByControlTableView.frame = frame;
    
}

-(NSUInteger)getSelectedIndex{
    return _selectedIndex;
    
}

@end
