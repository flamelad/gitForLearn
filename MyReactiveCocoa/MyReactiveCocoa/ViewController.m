//
//  ViewController.m
//  MyReactiveCocoa
//
//  Created by neo_chen on 2015/9/14.
//  Copyright (c) 2015年 CyberLink. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *myText;
@property (weak, nonatomic) IBOutlet UITextField *myText2;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myButton.enabled = NO;
    //map
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    // Contains: AA BB CC DD EE FF GG HH II
    RACSequence *mapped = [letters map:^(NSString *value) {
        return [value stringByAppendingString:value];
    }];
    NSLog(@"mapped:%@",mapped);
    //Signal
    [self.myText.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    //Combining latest values and reduce
    RACSignal *formalValid =
    [RACSignal combineLatest:@[self.myText.rac_textSignal,
                               self.myText2.rac_textSignal
                               ]
                      reduce:^id(NSString *firstString, NSString *secondString){
                          return @(firstString.length > 3 && secondString.length > 3);
                      }];
    RAC(self.myButton, enabled) = formalValid;
    //filter
    RAC(self.myText2, text) = [formalValid filter:^BOOL(id value) {
        return [value isEqualToString:@"2"]||[value isEqualToString:@"1"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
