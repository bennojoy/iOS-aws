//
//  ViewController.m
//  resttest
//
//  Created by BenCloud on 30/09/13.
//  Copyright (c) 2013 BenCloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize enteredURL = _enteredURL;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"Called%@", textView.text);
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    if (currentConnection1){
        self.caction = @"submitjob";
    }
    if (currentConnection2){
         self.caction = @"execjob";
    }
    self.apiReturnJSONData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    
    [self.apiReturnJSONData appendData:data];
    
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"URL Connection Failed!");
    currentConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError* error;
  
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.apiReturnJSONData
                          options:kNilOptions
                          error:&error];
    if ([self.caction isEqualToString:@"connect"] )
    {
        self.atoken = [json valueForKey:@"token"];
        self.result.text = [[NSString alloc] initWithData:self.apiReturnJSONData encoding:NSASCIIStringEncoding];
        [self.result scrollRangeToVisible:NSMakeRange([self.apiReturnJSONData length], 0)];
    }
    if ([self.caction isEqualToString:@"runjob"] )
    {
       
        self.jobtemp = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *tt = [[NSMutableDictionary alloc] init];
        NSString *job_id          = [ json objectForKey:@"id"];
        NSString *job_name        = [ json objectForKey:@"name"];
        NSString *job_type        = [ json objectForKey:@"job_type"];
        NSString *job_inventory   = [ json objectForKey:@"inventory"];
        NSString *job_project     = [ json objectForKey:@"project"];
        NSString *job_play        = [ json objectForKey:@"playbook"];
        NSString *job_credential  = [ json objectForKey:@"credential"];
        NSString *job_verbosity   = [ json objectForKey:@"verbosity"];
        NSDate *now = [NSDate date];
        job_name = [ NSString stringWithFormat:@"%@ %@", job_name, now];
        [tt setObject:job_id   forKey:@"template_id"];
        [tt setObject:job_name   forKey:@"name"];
        [tt setObject:job_type   forKey:@"job_type"];
        [tt setObject:job_inventory   forKey:@"inventory"];
        [tt setObject:job_project   forKey:@"project"];
        [tt setObject:job_play   forKey:@"playbook"];
        [tt setObject:job_credential   forKey:@"credential"];
        [tt setObject:job_verbosity   forKey:@"verbosity"];
        
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tt
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        NSString *token = [NSString stringWithFormat:@"Token %@", self.atoken];
        
        NSString *restCallString = [NSString stringWithFormat:@"%@/job_templates/%@/jobs/", self.url.text, self.jobid.text];
        NSURL *restURL = [NSURL URLWithString:restCallString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:token
              forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:jsonData];
        currentConnection1 = [[NSURLConnection alloc]   initWithRequest:request delegate:self];
        
        currentConnection = nil;
       
        
    

        
    }
    
    if ([self.caction isEqualToString:@"submitjob"] )
    {
        
        self.result.text = @"";
       
        NSString *job_id1          = [ json objectForKey:@"id"];
        NSString *res = [ NSString stringWithFormat:@"The new job was submitted the job id is %@", job_id1];
        NSString *token = [NSString stringWithFormat:@"Token %@", self.atoken];
        NSString *restCallString = [NSString stringWithFormat:@"%@/jobs/%@/start/", self.url.text, job_id1];
        NSURL *restURL = [NSURL URLWithString:restCallString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:token forHTTPHeaderField:@"Authorization"];

        currentConnection2 = [[NSURLConnection alloc]   initWithRequest:request delegate:self];
        currentConnection1 = nil;
        self.result.text = res;
       
        
    }
    if ([self.caction isEqualToString:@"execjob"] )
    {

    
          currentConnection2 = nil;
        
    }
    
    
    
    if ([self.caction isEqualToString:@"listjob"] )
    {

        NSArray *results = [ json objectForKey:@"results"];
         NSMutableDictionary *jobdata = [[NSMutableDictionary alloc] init];
        for(NSDictionary *item in results) {
            NSString *job_id   = [ item objectForKey:@"id"];
            NSString *job_name = [ item objectForKey:@"name"];
            NSString *jid = [ NSString stringWithFormat:@"job_%@",job_id];
            NSString *jname = [ NSString stringWithFormat:@"Job_id:%@ job_Name:%@",job_id, job_name];
            [jobdata setObject:jname   forKey:jid];
            
        }
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jobdata
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        self.result.text = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        [self.result scrollRangeToVisible:NSMakeRange([self.apiReturnJSONData length], 0)];
        
        
      
    
    }
    if ([self.caction isEqualToString:@"runresult"] )
    {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        NSString *res = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        NSString *replacementText = [self.result.text stringByAppendingString:res];
        NSString *job_status = [ json objectForKey:@"status"];
        NSString *job_result = [ json objectForKey:@"result_stdout"];
        NSString *job_res = [ NSString stringWithFormat:@" The job result is: %@ and output: %@", job_status, job_result];
        self.result.text = job_res;
        [self textView:self.result shouldChangeTextInRange:NSMakeRange(0, 1000) replacementText:replacementText];
        [self.result scrollRangeToVisible:NSMakeRange([self.apiReturnJSONData length], 0)];

        
    }
    
  currentConnection = nil;
                          
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)password {
    
    [password resignFirstResponder];
   
    return YES;
    
}


- (IBAction)connect:(id)sender {
    
    self.url.text = self.url.text;
    self.username.text = self.username.text;
    self.password.text = self.password.text;
    self.result.text = @"";
    self.caction = @"connect";
   
    
    NSError* error;
    
    
    
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] init];
    [postdata setObject:self.username.text  forKey:@"username"];
    [postdata setObject:self.password.text  forKey:@"password"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:postdata
        options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *pdata = [[NSString alloc] initWithData:jsonData
                                            encoding:NSASCIIStringEncoding];
    
    NSData *postData = [pdata dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"Json--%@", postData);
                         
    NSString *restCallString = [NSString stringWithFormat:@"%@/authtoken/", self.url.text];
    NSURL *restURL = [NSURL URLWithString:restCallString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    if( currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc]   initWithRequest:request delegate:self];
    NSLog(@"connection initialted");
}

- (IBAction)jobresult:(id)sender {
    self.jobid.text = self.jobid.text;
    self.result.text = @"";
    self.caction = @"runresult";
    NSString *token = [NSString stringWithFormat:@"Token %@", self.atoken];
    NSString *restCallString = [NSString stringWithFormat:@"%@/jobs/%@/", self.url.text, self.jobid.text];
    NSURL *restURL = [NSURL URLWithString:restCallString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token
   forHTTPHeaderField:@"Authorization"];
    
    
    if( currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc]   initWithRequest:request delegate:self];
}

- (IBAction)runjob:(id)sender {
    
    self.jobid.text = self.jobid.text;
    self.result.text = @"";
    self.caction = @"runjob";
    
    NSString *token = [NSString stringWithFormat:@"Token %@", self.atoken];

    
    
   NSString *restCallString = [NSString stringWithFormat:@"%@/job_templates/%@/", self.url.text, self.jobid.text];
    NSURL *restURL = [NSURL URLWithString:restCallString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token
        forHTTPHeaderField:@"Authorization"];
    
    
    if( currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc]   initWithRequest:request delegate:self];
    
    NSLog(@"connection initialted");
}


- (IBAction)listjob:(id)sender{
    
    self.url.text = self.url.text;
    self.username.text = self.username.text;
    self.password.text = self.password.text;
    self.result.text = @"";
    self.caction = @"listjob";
    
    

    
    NSString *restCallString = [NSString stringWithFormat:@"%@/job_templates/", self.url.text];
    NSString *token = [NSString stringWithFormat:@"Token %@", self.atoken];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:restURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token
        forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@request", request);
    
    
    if( currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnJSONData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc]   initWithRequest:request delegate:self];
    NSLog(@"connection initialted");
    

}

@end
