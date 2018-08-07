//
//  ReviewDataDelegate.h
//  MentorMe
//
//  Created by Taylor Murray on 8/6/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ReviewDataDelegate : NSObject <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) id origin;
- (id)initWithOrigin:(id)origin;
@end
