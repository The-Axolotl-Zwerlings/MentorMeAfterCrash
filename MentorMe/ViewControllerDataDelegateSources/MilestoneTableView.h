//
//  MilestoneTableView.h
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MilestoneCell.h"
#import "AddCell.h"

@interface MilestoneTableView : NSObject <UITableViewDelegate, UITableViewDataSource, AddDelegate, FinishedDeleagte>

@property (strong, nonatomic) UIView *myView;
@property (strong, nonatomic) NSArray *tableViews;
@property (strong, nonatomic) NSArray *tasks;
- (void)addedTask:(NSString *)taskText;
- (id)initWithTableViews:(NSArray *)tableViewArray andTasks:(NSArray *)tasks andLastBar:(UIView*)lastBar;
@end
