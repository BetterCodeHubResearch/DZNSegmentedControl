//
//  ViewController.m
//  Sample
//
//  Created by Ignacio Romero Zurbuchen on 3/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ViewController.h"
#import "DZNSegmentedControl.h"

#define allowAppearance YES

@interface ViewController () <DZNSegmentedControlDelegate>
@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation ViewController

+ (void)load
{
    [super load];
    
    if (!allowAppearance) {
        return;
    }
    
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor colorWithRed:226/255.0 green:241/255.0 blue:243/255.0 alpha:1.0]];
    [[DZNSegmentedControl appearance] setTintColor:[UIColor colorWithRed:18/255.0 green:130/255.0 blue:138/255.0 alpha:1.0]];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor colorWithRed:129/255.0 green:180/255.0 blue:188/255.0 alpha:1.0]];
    [[DZNSegmentedControl appearance] setFont:[UIFont fontWithName:@"Times" size:19.0]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:3];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.5];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"DZNSegmentedControl";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSegment:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshSegments:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = @[[@"Tweets" uppercaseString], [@"Following" uppercaseString], [@"Followers" uppercaseString]];

    self.tableView.tableHeaderView = self.control;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateControlCounts];
}

- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
//        _control.selectedSegmentIndex = 1;
        
        _control.displayCount = NO;
//        _control.autoAdjustSelectionIndicatorWidth = NO;
        
        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ #%d", [[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] capitalizedString], (int)indexPath.row+1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - ViewController Methods

- (void)addSegment:(id)sender
{
    NSUInteger newSegment = self.control.numberOfSegments;

    [self.control setTitle:[@"Favorites" uppercaseString] forSegmentAtIndex:self.control.numberOfSegments];
    [self.control setCount:@((arc4random()%300)) forSegmentAtIndex:newSegment];
}

- (void)refreshSegments:(id)sender
{
    if (self.control.selectedSegmentIndex >= 0) {
        [self.control removeAllSegments];
    }
    else {
        [self.control setItems:self.menuItems];
        [self updateControlCounts];
    }
}

- (void)updateControlCounts
{
    [self.control setCount:@((arc4random()%300)) forSegmentAtIndex:0];
    [self.control setCount:@((arc4random()%300)) forSegmentAtIndex:1];
    [self.control setCount:@((arc4random()%300)) forSegmentAtIndex:2];
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    [self.tableView reloadData];
}


#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

@end
