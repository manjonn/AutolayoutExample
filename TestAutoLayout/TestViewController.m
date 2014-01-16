//
//  TestViewController.m
//  TestAutoLayout
//
//  Created by Manjula Jonnalagadda on 1/7/14.
//  Copyright (c) 2014 Manjula Jonnalagadda. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

-(void)loadView{
    
    [super loadView];
    
    UIView *supview=[UIView new];
    supview.translatesAutoresizingMaskIntoConstraints=NO;
    supview.tag=1001;
    [self.view addSubview:supview];
    
    UIView *view1=[UIView new];
    view1.translatesAutoresizingMaskIntoConstraints=NO;
    view1.tag=101;
    view1.backgroundColor=[UIColor redColor];
    [supview addSubview:view1];
    
    UIView *view2=[UIView new];
    view2.translatesAutoresizingMaskIntoConstraints=NO;
    view2.tag=102;
    view2.backgroundColor=[UIColor blueColor];
    [supview addSubview:view2];
    
    id topLayoutGuide=[self topLayoutGuide];
    
    _h1Constraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view1(==view2)][view2]|" options:0 metrics:nil views:@{@"view1":view1,@"view2":view2}];
    NSArray *v1Constraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view1]|" options:0 metrics:nil views:@{@"view1":view1}];

    NSArray *v2Constraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view2]|" options:0 metrics:nil views:@{@"view2":view2}];

    [supview addConstraints:_h1Constraints];
    [supview addConstraints:v1Constraints];
    [supview addConstraints:v2Constraints];
    
    UIButton *btn=[UIButton new];
    btn.translatesAutoresizingMaskIntoConstraints=NO;
    [btn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=[UIColor greenColor];
    [self.view addSubview:btn];
    
    NSArray *btnHConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[supview]|" options:0 metrics:nil views:@{@"supview":supview}];
    NSArray *supHConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]|" options:0 metrics:nil views:@{@"btn":btn}];
   NSArray *btnVerConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][btn(40)][supview]|" options:0 metrics:nil views:@{@"btn": btn,@"topLayoutGuide":topLayoutGuide,@"supview":supview}];
    
    [self.view addConstraints:btnHConstraints];
    [self.view addConstraints:btnVerConstraints];
    [self.view addConstraints:supHConstraints];
    
    
    
}

-(void)btnTapped{
    
    
    NSString *view1Width=@"0";
    if ([self.view viewWithTag:101].hidden) {
        view1Width=@"view2";
    }
    NSString *format=[NSString stringWithFormat:@"H:|[view1(==%@)][view2]|",view1Width];
    [[self.view viewWithTag:1001] removeConstraints:_h1Constraints];
    _h1Constraints=[NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatAlignAllTop metrics:nil views:@{@"view1":[self.view viewWithTag:101],@"view2":[self.view viewWithTag:102]}];
    [[self.view viewWithTag:1001]  addConstraints:_h1Constraints];
    [[self.view viewWithTag:1001] setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
        [[self.view viewWithTag:1001] layoutIfNeeded];
        
        [self.view viewWithTag:101].hidden=![self.view viewWithTag:101].hidden;
    }];
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
