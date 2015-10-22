//
//  WikipediaViewController.h
//  googleApp
//
//  Created by Fatima Zenine Villanueva on 10/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikipediaHelper.h"

@interface WikipediaViewController : UIViewController <WikipediaHelperDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *wikiWebView;
@property (weak, nonatomic) IBOutlet UITextField *seearchTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (weak, nonatomic) IBOutlet UIView *sideBarUIVIew;

@end
