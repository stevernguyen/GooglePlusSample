// https://developers.google.com/+/mobile/ios/sign-in

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

#define kClientId @"734583861244-n1lu320gdsj1kd8m97aijfnetk2ksqng.apps.googleusercontent.com"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GPPSignInButton *signInButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
        
        if (person != nil)
        {
            if ([[GPPSignIn sharedInstance].userEmail length] > 0)
            {
                GTLPlusPersonName *googleUserName = person.name ;
                NSLog(@"%@ %@ %@ %@",googleUserName.givenName,googleUserName.familyName,person.gender,person.displayName );
                
                NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
                
                [dicData setObject:[GPPSignIn sharedInstance].userEmail forKey:@"email"];
                [dicData setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"app_version"];
                [dicData setValue:googleUserName.givenName forKey:@"firstname"];
                [dicData setValue:googleUserName.familyName forKey:@"lastname"];
                
                
                //*** Profile Pic
                NSData *avatarData = nil;
                
                NSString *imageURLString = person.image.url;
                
                imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@"sz=50" withString:@"sz=300"];
                
                NSURL *imageURL = [NSURL URLWithString:imageURLString];
                avatarData = [NSData dataWithContentsOfURL:imageURL];
                
                //                [avatarData writeToFile:[self getSocialProfilePicPath] atomically:NO];
            }
            else
            {
                //                [self alertshow:@"Google" :error.localizedDescription];
            }
        }
        else
        {
            //            [self alertshow:@"Google" :error.localizedDescription];
        }
        
        NSLog(@"Google Plus Logged %@",person);
        NSLog(@"User Email Address = %@",[GPPSignIn sharedInstance].userEmail);
    }
}


@end
