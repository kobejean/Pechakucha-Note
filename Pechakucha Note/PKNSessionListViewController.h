//
//  PKNSessionListViewController.h
//  Pechakucha Note
//
//  Created by Jean on 4/19/13.
//  Copyright (c) 2013 Pechakucha Note. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKNSelectionTableView.h"
#import "PKNSelectionTableViewCell.h"
#import "PKNSessionManager.h"
#import "PKNPracticeViewController.h"

@interface PKNSessionListViewController : UIViewController <PKNSelectionTableViewDelegate>
{
    IBOutlet PKNSelectionTableView *_selectionTableView;
    NSArray *_sessionsInfo;
}

@property (nonatomic, strong) PKNSelectionTableView *selectionTableView;
@property (nonatomic, retain) NSArray *sessionsInfo;


@end
