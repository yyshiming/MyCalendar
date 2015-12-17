//
//  BaseSearchVC.m
//  KDBCommon
//
//  Created by YY on 15/7/20.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseSearchVC.h"
#import "YYBaseSearchResultVC.h"

@interface YYBaseSearchVC ()<UISearchDisplayDelegate, UISearchBarDelegate,
                            UISearchControllerDelegate,UISearchResultsUpdating>

#ifdef kSearchControllerType
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) YYBaseSearchResultVC *searchResultController;
#else
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;
#endif

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation YYBaseSearchVC

- (NSMutableArray *)searchResults
{
    if (_searchResults == nil) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}
- (UISearchBar *)searchBar
{
#ifdef kSearchControllerType
    return _searchController.searchBar;
#else
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索";
        [_searchBar sizeToFit];
    }
    return _searchBar;
#endif
}
- (void)dealloc
{
    
#ifdef kSearchControllerType
    self.searchController.delegate = nil;
    self.searchController.searchResultsUpdater = nil;
    self.searchController = nil;
    self.searchResults = nil;
#else
    self.mySearchDisplayController.delegate = nil;
    self.mySearchDisplayController.searchResultsDataSource = nil;
    self.mySearchDisplayController.searchResultsDelegate = nil;
    self.mySearchDisplayController = nil;
#endif
    
    self.searchBar = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
#ifdef kSearchControllerType
    _searchResultController = [[YYBaseSearchResultVC alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultController];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    _searchResultController.tableView.delegate = self;
    _searchController.searchBar.delegate = self;
#else
    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    
    self.tableView.tableHeaderView = self.searchBar;
    self.searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
#ifdef kSearchControllerType

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.dataArray mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // yearIntroduced field matching
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
        if (targetNumber != nil) {   // searchString may not convert to a number
            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
            
            // price field matching
            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    YYBaseSearchResultVC *tableController = (YYBaseSearchResultVC *)self.searchController.searchResultsController;
    tableController.filteredResults = searchResults;
    [tableController.tableView reloadData];
}
#else
#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *scope;
    NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0) {
        scope = [self.searchDisplayController.searchBar scopeButtonTitles][selectedScopeButtonIndex];
    }
    
    [self updateFilteredContentForName:searchString type:scope];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = [self.searchDisplayController.searchBar text];
    NSString *scope;
    
    if (searchOption > 0)
    {
        scope =  [self.searchDisplayController.searchBar scopeButtonTitles][searchOption];
    }
    
    [self updateFilteredContentForName:searchString type:scope];
    
    return YES;
}
#pragma mark - help method
- (void)updateFilteredContentForName:(NSString *)name type:(NSString *)typeName
{
    [self.searchResults removeAllObjects];
    
    for (id object in self.dataArray) {
        
    }
    
}
#endif
@end
