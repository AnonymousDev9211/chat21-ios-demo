//
//  DocProfileTVC.m
//  bppmobile
//
//  Created by Andrea Sponziello on 19/07/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "DocProfileTVC.h"
#import "SHPApplicationContext.h"
#import "ChatManager.h"
//#import "HomeMenuTableViewController.h"
#import "ChatRootNC.h"
#import "SHPUser.h"
#import "SHPAppDelegate.h"
#import "ChatUtil.h"
#import "ChatManager.h"
#import "ChatUser.h"
#import "HelpFacade.h"
#import "HelpFacade.h"

@interface DocProfileTVC ()

@end

@implementation DocProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = [NSString stringWithFormat:@"ver. %@ build %@", version, build];
    
    [[HelpFacade sharedInstance] activateSupportBarButton:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) { // cella supporto
        if (![HelpFacade sharedInstance].supportEnabled) {
            return 0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)logoutAction:(id)sender {
    NSLog(@"Logout");
    UIAlertController * view =   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:@"Vuoi uscire?"
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* logout = [UIAlertAction
                             actionWithTitle:@"Si"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Sending request");
                                 [self confirmLogout];
                             }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Annulla"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"action canceled");
                             }];
    [view addAction:logout];
    [view addAction:cancel];
    // for ipad
    view.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SHPUser *loggedUser = [SHPApplicationContext getSharedInstance].loggedUser;
    self.usernameLabel.text = loggedUser.username;
    self.fullNameLabel.text = loggedUser.fullName;
}

- (void)confirmLogout {
    NSLog(@"LOGOUT");
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    SHPAppDelegate *app = (SHPAppDelegate *) [[UIApplication sharedApplication] delegate];
    SHPApplicationContext *context = app.applicationContext;
    [context signout];
    [self resetTab];
    
    // LOGOUT FIREBASE...
    //START SIGNOUT
    ChatManager *chat = [ChatManager getInstance];
    [chat dispose];
    //signout firebase
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    NSLog(@"logut status %d", status);
    if (!status) {
        NSLog(@"Error signing out from Firebase: %@", signOutError);
    }
    else {
        NSLog(@"Successfully signed out from Firebase");
    }
}

-(void)resetTab {
    //    int chat_tab_index = [SHPApplicationContext tabIndexByName:@"ChatController"];
    //    // move to the converstations tab
    //    if (chat_tab_index >= 0) {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabController = (UITabBarController *)window.rootViewController;
    //        NSArray *controllers = [tabController viewControllers];
    //        ChatRootNC *nc = [controllers objectAtIndex:chat_tab_index];
    //        [nc popToRootViewControllerAnimated:NO];
    tabController.selectedIndex = 0;
    //    }
}

- (IBAction)helpAction:(id)sender {
    NSLog(@"Help in %@ view.", NSStringFromClass([self class]));
    [[HelpFacade sharedInstance] openSupportView:self];
}

-(void)helpWizardEnd:(NSDictionary *)context {
    NSLog(@"helpWizardEnd");
    [context setValue:NSStringFromClass([self class]) forKey:@"section"];
    [[HelpFacade sharedInstance] handleWizardSupportFromViewController:self helpContext:context];
}

@end
