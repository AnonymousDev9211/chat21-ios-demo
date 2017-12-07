//
//  ChatGroup.m
//  Smart21
//
//  Created by Andrea Sponziello on 27/03/15.
//
//

#import "ChatGroup.h"
//#import "Firebase/Firebase.h"
#import "SHPPushNotification.h"
#import "SHPPushNotificationService.h"
#import "SHPApplicationContext.h"
#import "ChatUtil.h"
#import "SHPAppDelegate.h"

@implementation ChatGroup

-(NSString *)iconUrl {
    return [ChatUtil groupImageUrlById:self.groupId];
}

-(FIRDatabaseReference *)reference {
//    SHPAppDelegate *appDelegate = (SHPAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSLog(@"appDelegate.applicationContext %@", appDelegate.applicationContext);
//    NSDictionary *plistDictionary = appDelegate.applicationContext.plistDictionary;
//    NSDictionary *settingsDictionary = [plistDictionary objectForKey:@"Settings"];
//    NSLog(@"settingsDictionary %@", settingsDictionary);
//    NSString *firebase_chat_ref = (NSString *)[settingsDictionary objectForKey:@"Firebase-chat-ref"];
//    FIRDatabaseReference *groups_ref = [ChatUtil groupsRefWithBase:firebase_chat_ref];
//    FIRDatabaseReference *group_ref = [groups_ref child:self.groupId];
    
    FIRDatabaseReference *rootRef = [[FIRDatabase database] reference];
    NSString *groups_path = [ChatUtil groupsPath];
    FIRDatabaseReference *group_ref = [[rootRef child:groups_path] child:self.groupId];
    NSLog(@"group_ref %@", group_ref);
    return group_ref;
}

-(NSString *)memberPath:(NSString *)memberId {
    NSString *member_path = [[NSString alloc] initWithFormat:@"members/%@", memberId];
    return member_path;
}

-(FIRDatabaseReference *)memberReference:(NSString *)memberId {
    FIRDatabaseReference *group_ref = [self reference];
    NSString *member_path = [self memberPath:memberId];
    FIRDatabaseReference *member_ref = [group_ref child:member_path];
    return member_ref;
}

-(BOOL)isMember:(NSString *)user_id {
    NSString *member_id = [self.members objectForKey:user_id];
    return member_id ? YES : NO;
}

+(NSMutableDictionary *)membersArray2Dictionary:(NSArray *)membersIds {
    NSMutableDictionary *members_dict = [[NSMutableDictionary alloc] init];
    for (NSString *memberId in membersIds) {
        [members_dict setObject:@(true) forKey:memberId];
    }
    return members_dict;
}

+(NSMutableArray *)membersDictionary2Array:(NSDictionary *)membersDict {
    NSMutableArray *membersIds = [[NSMutableArray alloc] init];
    for(id key in membersDict) {
//        id memberId = [membersDict objectForKey:key];
//        [membersIds addObject:memberId];
        [membersIds addObject:key];
    }
    return membersIds;
}

+(NSMutableArray *)membersString2Array:(NSString *)membersString {
    NSArray *splits = [membersString componentsSeparatedByString:@","];
    NSMutableArray *members = [[NSMutableArray alloc] init];
    for (NSString *part in splits) {
        NSString *member = [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![member isEqualToString:@""]) {
            [members addObject:member];
        }
    }
    return members;
}

+(NSMutableDictionary *)membersString2Dictionary:(NSString *)membersString {
    NSArray *splits = [membersString componentsSeparatedByString:@","];
    NSMutableDictionary *members = [[NSMutableDictionary alloc] init];
    for (NSString *part in splits) {
        NSString *memberId = [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![memberId isEqualToString:@""]) {
//            [trimmed_members setObject:memberId forKey:memberId];
            [members setObject:@(true) forKey:memberId];
        }
    }
    return members;
}

+(NSString *)membersArray2String:(NSArray *)membersArray {
    if (membersArray.count == 0) {
        return @"";
    }
    
    NSString *members_string = [membersArray objectAtIndex:0];
    for (int i = 1; i < membersArray.count; i++) {
        id m = [membersArray objectAtIndex:i];
        if (m != [NSNull null]) {
            NSString *member = (NSString *)m;
            NSString *m_to_add = [[NSString alloc] initWithFormat:@",%@",member];
            members_string = [members_string stringByAppendingString:m_to_add];
        }
    }
    return members_string;
}

+(NSString *)membersDictionary2String:(NSDictionary *)membersDictionary {
    if (membersDictionary.count == 0) {
        return @"";
    }
    NSMutableArray *membersArray = [[NSMutableArray alloc] init];
    
    for(id key in membersDictionary) {
//        id value = [membersDictionary objectForKey:key];
//        [membersArray addObject:value];
        [membersArray addObject:key];
    }
    
    NSString *members_string = [ChatGroup membersArray2String:membersArray];
    return members_string;
}

-(NSDictionary *)asDictionary {
    NSDictionary *group_dict = @{
                                 GROUP_OWNER: self.owner,
                                 GROUP_NAME: self.name,
                                 GROUP_MEMBERS : self.members,
                                 GROUP_CREATEDON: [FIRServerValue timestamp]
                                 };
//    if (self.iconID) {
//        [group_dict setValue:self.iconID forKey:GROUP_ICON_ID];
//    }
    return group_dict;
}

-(BOOL)completeData {
    BOOL complete = (self.name != nil);
    NSLog(@"complete: %d", complete);
    return complete;
}

@end