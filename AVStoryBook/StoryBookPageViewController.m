//
//  StoryBookPageViewController.m
//  AVStoryBook
//
//  Created by Jimmy Hoang on 2017-06-18.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

#import "StoryBookPageViewController.h"
#import "StoryBook.h"
#import "StoryPartViewController.h"

@interface StoryBookPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray* storyBook;

@end

@implementation StoryBookPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    [self setupStoryBook];
    
    StoryPartViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"story-part-view-controller"];
    viewController.storyPage = self.storyBook[0];
    viewController.pageNumber = 1;
    [self setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
-(void)setupStoryBook {
    self.storyBook = [[NSArray alloc] initWithObjects:[StoryBook new],[StoryBook new],[StoryBook new],[StoryBook new],[StoryBook new], nil];
}

#pragma mark - Data Source Delegates

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int prevPageNum = ((StoryPartViewController*)viewController).pageNumber;
    
    if (prevPageNum == 5) {
        return nil;
    }
    
    StoryPartViewController* nextPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"story-part-view-controller"];
    nextPageViewController.storyPage = self.storyBook[prevPageNum];
    nextPageViewController.pageNumber = prevPageNum + 1;
    
    return nextPageViewController;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    int prevPageNum = ((StoryPartViewController*)viewController).pageNumber;
    NSLog(@"prevPageNum: %d",prevPageNum);
    
    if (prevPageNum == 1) {
        return nil;
    }
    
    StoryPartViewController* nextPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"story-part-view-controller"];
    
    nextPageViewController.storyPage = self.storyBook[prevPageNum-2];
    if (!nextPageViewController.storyPage.image) {
        NSLog(@"image not found");
    } else {
        NSLog(@"image found");
    }
    nextPageViewController.pageNumber = prevPageNum - 1;

    return nextPageViewController;
}


@end
