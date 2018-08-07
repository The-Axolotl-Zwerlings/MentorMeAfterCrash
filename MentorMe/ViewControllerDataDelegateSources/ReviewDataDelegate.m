//
//  ReviewDataDelegate.m
//  MentorMe
//
//  Created by Taylor Murray on 8/6/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ReviewDataDelegate.h"
#import "ComplimentsCell.h"
@implementation ReviewDataDelegate
- (id)initWithOrigin:(id)origin{
    self = [super init];
    if(self){
        self.origin = origin;
    }
    
    return self;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *compliments = [NSArray arrayWithObjects:@"Great Conversation",@"Down to Earth",@"Useful Advice",@"Friendly",@"Super Knowledgeable", nil];
    NSArray *icons = [NSArray arrayWithObjects:@"bubbles3.png",@"earth.png",@"eye.png",@"grin.png",@"cool.png", nil];

    ComplimentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComplimentsCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ComplimentsCell"];
        
    }
    [cell formatCellReview:[NSNumber numberWithInteger:indexPath.item] andSelected:@(0) andDelegate:self.origin];
    return cell;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
@end
