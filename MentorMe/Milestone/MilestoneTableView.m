//
//  MilestoneTableView.m
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MilestoneTableView.h"

@implementation MilestoneTableView
- (void)finishedTask:(UITableView *)tableView andPath:(NSIndexPath *)indexPath{
//    NSLog(@"WE SELECTED ⚡️");
//    
//    int index = 0;
//    for(int i = 0; i < self.tableViews.count; ++i){
//        if(tableView == self.tableViews[i]){
//            index = i;
//        }
//    }
//    NSString *old = ((NSArray *)(self.tasks[index]))[indexPath.row];
//    NSMutableAttributedString *newStrMutable = [[NSMutableAttributedString alloc]initWithString:old];
//    [newStrMutable addAttribute:NSStrikethroughStyleAttributeName
//                   value:@2
//                   range:NSMakeRange(0, [newStrMutable length])];
//    NSMutableArray *oldArrayMutable = [NSMutableArray arrayWithArray:self.tasks[index]];
//    NSString *newStr = newStrMutable.string;
//    [oldArrayMutable replaceObjectAtIndex:indexPath.row withObject:newStr];
//    NSMutableArray *oldTasks = [NSMutableArray arrayWithArray:self.tasks];
//    [oldTasks replaceObjectAtIndex:index withObject:oldArrayMutable];
//    self.tasks = [NSArray arrayWithArray:oldTasks];
//    
//    [tableView reloadData];
}
- (id)initWithTableViews:(NSArray *)tableViewArray andTasks:(NSArray *)tasks andLastBar:(UIView *)lastBar{
    self = [super init];
    if(self){
        self.tasks = tasks;
        self.tableViews = tableViewArray;
        self.myView = lastBar;
    }
   
    return self;
}

- (void)addedTask:(NSString *)taskText{
    unsigned long lastIndex = self.tableViews.count-1;
    __block UITableView *lastOne = self.tableViews[lastIndex];
    NSMutableArray *old = [NSMutableArray arrayWithArray:self.tasks[lastIndex]];
    [old insertObject:taskText atIndex:0];
    NSMutableArray *newone = [NSMutableArray arrayWithArray:self.tasks];
    [newone replaceObjectAtIndex:lastIndex withObject:old];
    self.tasks = [NSArray arrayWithArray:newone];
    
    [UIView animateWithDuration:.3 animations:^{
        lastOne.frame = CGRectMake(lastOne.frame.origin.x, lastOne.frame.origin.y, lastOne.frame.size.width, (old.count+1)* 45);
        self.myView.frame = CGRectMake(self.myView.frame.origin.x, self.myView.frame.origin.y, self.myView.frame.size.width, (old.count+1)* 45);
    }];
    [lastOne reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%@", [NSString stringWithFormat:@"%f", tableView.frame.origin.y]);
    int index = 0;
    for(int i = 0; i < self.tableViews.count; ++i){
        if(tableView == self.tableViews[i]){
            index = i;
        }
    }
    
    if(index == (self.tableViews.count - 1)){
        return (((NSArray *)self.tasks[index]).count + 1);
    } else{
        return ((NSArray *)self.tasks[index]).count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    unsigned long indexOfTableView;
    for(int i = 0; i < self.tableViews.count; ++i){
        if(tableView == self.tableViews[i]){
            indexOfTableView = i;
        }
    }
    NSLog(@"%@", [NSString stringWithFormat:@"%f", tableView.frame.origin.y]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f", indexPath.row]);
    
    
    //last one and first cell (add)
    if(tableView == self.tableViews[self.tableViews.count -1] && indexPath.row == 0){
        AddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
        if(cell == nil){
            cell = [[AddCell alloc]init];
            
        }
        [cell setUpAdd];
        cell.delegate = self;
        cell.userInteractionEnabled = YES;
        return cell;
        
    } else{
        MilestoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MilestoneCell"];
        
        if(cell == nil){
            cell = [[MilestoneCell alloc]init];
        }
        [cell setUpMilestone];
        
        //if it's the last table view we need to index -1
        if(tableView == self.tableViews[self.tableViews.count -1]){
            cell.task.text = self.tasks[indexOfTableView][indexPath.row - 1];
        } else{
            cell.task.text = self.tasks[indexOfTableView][indexPath.row];

        }
        cell.delegate = self;
        cell.userInteractionEnabled = YES;
        return cell;
    }
}






@end