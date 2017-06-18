//
//  StoryPartViewController.h
//  AVStoryBook
//
//  Created by Jimmy Hoang on 2017-06-16.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryBook.h"

@interface StoryPartViewController : UIViewController

@property (nonatomic, strong) StoryBook* storyPage;
@property (nonatomic, assign) int pageNumber;


@end
