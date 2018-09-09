//
//  PKNSessionListViewController.m
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import "PKNSessionListViewController.h"

@interface PKNSessionListViewController ()

@end

@implementation PKNSessionListViewController

@synthesize selectionTableView = _selectionTableView;
@synthesize sessionsInfo = _sessionsInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Recent";
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCell)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editSelectionTable)];
    self.selectionTableView.textDisabled = YES;
    self.selectionTableView.delegate = self;
    
    NSLog(@"sessions count:%i", [PKNSessionManager sessionsInfo].count);
    [self reloadSessions];
}

- (void)reloadSessions
{
    self.sessionsInfo = [PKNSessionManager sessionsInfo];
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:self.sessionsInfo.count];
    if(self.isViewLoaded){
        for (NSDictionary *info in self.sessionsInfo) {
            NSString *thumbnailPath = [[info objectForKey:@"path"] stringByAppendingPathComponent:@"thumbnail"];
            NSLog(@"thumb:%@", thumbnailPath);
            PKNSelectionTableViewCell *cell = [[PKNSelectionTableViewCell alloc] initWithText:@"" icon:[UIImage imageWithContentsOfFile:thumbnailPath] highlightedIcon:nil value:info];
            [cells addObject:cell];
        }
    }
    [self.selectionTableView setCells:cells];
}

- (void)viewDidLayoutSubviews
{
}

- (void)addCell
{
    [self.selectionTableView addCell:[[PKNSelectionTableViewCell alloc] initWithText:[NSString stringWithFormat:@"Session %i", self.selectionTableView.cells.count+1] icon:nil highlightedIcon:nil value:[NSString stringWithFormat:@"%i", self.selectionTableView.cells.count+1]] animated:YES];
}

- (void)editSelectionTable
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(stopEditSelectionTable)];
    [self.selectionTableView setEditing:YES];
}

- (void)stopEditSelectionTable
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editSelectionTable)];
    [self.selectionTableView setEditing:NO];
}

- (void)touchUpInsideCell:(id)cell
{
    PKNSelectionTableViewCell *selectionCell = cell;
    NSString *path = [[selectionCell value] objectForKey:@"path"];
    PKNSessionManager *sessionManager = [[PKNSessionManager alloc] initWithPath:path];
    PKNPracticeViewController *practiceViewController = [[PKNPracticeViewController alloc] initWithSessionManager:sessionManager];
    [self.navigationController pushViewController:practiceViewController animated:YES];
}

- (void)willDeleteCell:(id)cell
{
    PKNSelectionTableViewCell *selectionCell = cell;
    NSString *path = [selectionCell.value objectForKey:@"path"];
    [PKNSessionManager deleteSavedSessionAtPath:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
