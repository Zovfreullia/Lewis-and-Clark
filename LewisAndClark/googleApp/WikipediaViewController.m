//
//  WikipediaViewController.m
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "WikipediaViewController.h"

@interface WikipediaViewController ()

@end

@implementation WikipediaViewController

#pragma mark - Drop Shadow
- (void)dropShadowSideBar {
    self.sideBarUIVIew.layer.masksToBounds = NO;
    self.sideBarUIVIew.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sideBarUIVIew.layer.shadowOffset = CGSizeMake(-4.0f, 1.0f);
    self.sideBarUIVIew.layer.shadowOpacity = 1.0f;
}

- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.wikiWebView setBackgroundColor:[UIColor clearColor]];
    [self.wikiWebView setOpaque:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loadingActivity setHidden:YES];
    
    [self dropShadowSideBar];

    self.seearchTextField.delegate = self;
  

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    WikipediaHelper *wikiHelper = [[WikipediaHelper alloc] init];
    wikiHelper.apiUrl = @"http://en.wikipedia.org";
    wikiHelper.delegate = self;
    
    NSString *searchWord = textField.text;
    
    [wikiHelper fetchArticle:searchWord];
    self.titleLabel.text = textField.text;
    
    [self.loadingActivity startAnimating];
    [self.loadingActivity setHidden:NO];
    
    [self.view endEditing:YES];
    
    return YES;
}

- (void)dataLoaded:(NSString *)htmlPage withUrlMainImage:(NSString *)urlMainImage {
    [self.loadingActivity stopAnimating];
    [self.loadingActivity setHidden:YES];
    [self.wikiWebView loadHTMLString:htmlPage baseURL:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
