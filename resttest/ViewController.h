//
//  ViewController.h
//  resttest
//
//  Created by BenCloud on 30/09/13.
//  Copyright (c) 2013 BenCloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>
{
    NSURLConnection *currentConnection;
    NSURLConnection *currentConnection1;
    NSURLConnection *currentConnection2;
}
@property (weak, nonatomic) IBOutlet UITextField *jobid;
- (IBAction)jobresult:(id)sender;

- (IBAction)runjob:(id)sender;

- (IBAction)listjob:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextView *result;
@property (copy, nonatomic) NSString *enteredURL;
@property (copy, nonatomic) NSString *atoken;
@property (copy, nonatomic) NSString *caction;
@property (copy, nonatomic) NSMutableDictionary *jobtemp;
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (retain, nonatomic) NSMutableData *apiReturnJSONData;
@end
