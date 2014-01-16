//
//  TestDynViewController.m
//  TestAutoLayout
//
//  Created by Manjula Jonnalagadda on 1/7/14.
//  Copyright (c) 2014 Manjula Jonnalagadda. All rights reserved.
//

#import "TestDynViewController.h"
#import "FacebookServer.h"


@interface TestDynViewController ()

@end

@implementation TestDynViewController

-(void)loadView{
    
    [super loadView];
    FBLoginView *fbLoginView=[[FacebookServer facebookServer] fbLoginViewWithLoggedBlock:^{
        [self populateProfile];
    }];
    
    fbLoginView.translatesAutoresizingMaskIntoConstraints=NO;
    fbLoginView.tag=104;
    id topLayoutGuide=[self topLayoutGuide];
    
    [self.view addSubview:fbLoginView];
    
//    NSArray *fbLogInViewVerConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[fbLoginView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"fbLoginView": fbLoginView}];
    NSLayoutConstraint *fbLogInViewHorPosConstraint=[NSLayoutConstraint constraintWithItem:fbLoginView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
//    NSArray *fbLogInViewHorConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[fbLoginView]-(>=0)-|" options:0 metrics:nil views:@{@"fbLoginView": fbLoginView}];
    
//    [self.view addConstraints:fbLogInViewVerConstraints];
    [self.view addConstraint:fbLogInViewHorPosConstraint];
    
    UILabel *nameLabel=[UILabel new];
    nameLabel.tag=101;
    nameLabel.translatesAutoresizingMaskIntoConstraints=NO;
    nameLabel.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:nameLabel];
    
    UILabel *bdLabel=[UILabel new];
    bdLabel.translatesAutoresizingMaskIntoConstraints=NO;
    bdLabel.tag=102;
    bdLabel.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:bdLabel];
    
    UILabel *aboutLabel=[UILabel new];
    aboutLabel.translatesAutoresizingMaskIntoConstraints=NO;
    aboutLabel.tag=103;
    aboutLabel.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
    aboutLabel.numberOfLines=0;
    [self.view addSubview:aboutLabel];
    
    _verConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[fbLoginView]-[nameLabel(40)]-[bdLabel(40)]-[aboutLabel(40)]" options:0 metrics:nil views:@{@"nameLabel": nameLabel,@"bdLabel":bdLabel,@"aboutLabel":aboutLabel,@"fbLoginView":fbLoginView,@"topLayoutGuide":topLayoutGuide}];
    NSArray *horConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLabel]-|" options:0 metrics:nil views:@{@"nameLabel": nameLabel}];
    NSArray *horBdConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bdLabel]-|" options:0 metrics:nil views:@{@"bdLabel": bdLabel}];
    NSArray *horAbtConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[aboutLabel]-|" options:0 metrics:nil views:@{@"aboutLabel": aboutLabel}];
    
    [self.view addConstraints:horConstraints];
    [self.view addConstraints:_verConstraints];
    [self.view addConstraints:horBdConstraints];
    [self.view addConstraints:horAbtConstraints];
    

/*
    [[NSNotificationCenter defaultCenter]addObserverForName:@"logged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self populateProfile];
        
    }];
 */
//    [self.view addConstraints:fbLogInViewHorConstraints];
    
    
    
    
}

-(void)populateProfile{
    
    ((UILabel *)[self.view viewWithTag:101]).text=[[FacebookServer facebookServer].me name];

    ((UILabel *)[self.view viewWithTag:102]).text=[[FacebookServer facebookServer].me birthday];

    ((UILabel *)[self.view viewWithTag:103]).text=[FacebookServer facebookServer].me[@"bio"];
    
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[FacebookServer facebookServer].me[@"bio"]
     attributes:@
     {
     NSFontAttributeName: ((UILabel *)[self.view viewWithTag:103]).font
     }];
    CGRect bioRect = [attributedText boundingRectWithSize:(CGSize){[self.view viewWithTag:103].superview.bounds.size.width-50, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                   context:nil];
    
    CGFloat bdHt=40;
    CGFloat aboutHt=bioRect.size.height+20;
    CGFloat gap=8;
    if (![[FacebookServer facebookServer].me birthday]) {
        bdHt=0;
        gap=0;
    }
    
    [self.view removeConstraints:_verConstraints];
    
    id topLayoutGuide=[self topLayoutGuide];
    
    NSDictionary *metricsDictionary=@{@"bdHt": [NSNumber numberWithFloat:bdHt],@"aboutHt":[NSNumber numberWithFloat:aboutHt],@"gap":[NSNumber numberWithFloat:gap]};
    _verConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[fbLoginView]-[nameLabel(40)]-[bdLabel(bdHt)]-(gap)-[aboutLabel(aboutHt)]" options:0 metrics:metricsDictionary views:@{@"nameLabel":  [self.view viewWithTag:101],@"bdLabel": [self.view viewWithTag:102],@"aboutLabel": [self.view viewWithTag:103],@"fbLoginView":[self.view viewWithTag:104],@"topLayoutGuide":topLayoutGuide}];
    
//    _verConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[nameLabel(40)]-5-[bdLabel(bdHt)]-(gap)-[aboutLabel(aboutHt)]" options:0 metrics:metricsDictionary views:@{@"nameLabel": [self.view viewWithTag:101],@"bdLabel":[self.view viewWithTag:102],@"aboutLabel":[self.view viewWithTag:103]}];
    
    [self.view addConstraints:_verConstraints];


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
