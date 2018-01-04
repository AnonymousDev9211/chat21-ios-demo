//
//  ChatSelectGroupMembersLocal.h
//  bppmobile
//
//  Created by Andrea Sponziello on 14/09/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ChatUsersDC.h"
#import "SHPImageDownloader.h"
#import "SHPModalCallerDelegate.h"

@class HelloApplicationContext;
@class ChatImageCache;
@class ChatGroup;
@class ChatUser;
//@class AlfrescoRequest;

@interface ChatSelectGroupMembersLocal : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SHPImageDownloaderDelegate>

@property (strong, nonatomic) HelloApplicationContext *applicationContext;
@property (strong, nonatomic) ChatUser *userSelected;
@property (strong, nonatomic) NSArray<ChatUser *> *users;
@property (strong, nonatomic) NSMutableArray<ChatUser *> *members;

//@property (strong, nonatomic) AlfrescoRequest *currentRequest;

//@property (strong, nonatomic) ChatUsersDC *userDC;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (strong, nonatomic) id <SHPModalCallerDelegate> modalCallerDelegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)createGroupAction:(id)sender;

@property (strong, nonatomic) NSString *searchBarPlaceholder;
@property (strong, nonatomic) NSString *textToSearch;
@property (strong, nonatomic) NSTimer *searchTimer;
@property (strong, nonatomic) NSString *lastUsersTextSearch;

@property (strong, nonatomic) ChatImageCache *imageCache;

@end