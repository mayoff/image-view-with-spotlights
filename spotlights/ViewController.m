//
//  ViewController.m
//  spotlights
//
//  Created by Rob Mayoff on 3/7/14.
//  Copyright (c) 2014 Rob Mayoff. All rights reserved.
//

#import "ViewController.h"
#import "SpotlightsView.h"

@interface ViewController ()

@property (nonatomic, strong) SpotlightsView *view;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.image = [UIImage imageNamed:@"Kaz-800.jpg"];
    [self.view addDraggableSpotlightWithCenter:CGPointMake(100, 100) radius:70];
    [self.view addDraggableSpotlightWithCenter:CGPointMake(220, 200) radius:80];
    [self.view addDraggableSpotlightWithCenter:CGPointMake(120, 360) radius:100];
}

@end
