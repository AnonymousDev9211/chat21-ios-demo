//
//  ChatGroupsDelegate.h
//  bppmobile
//
//  Created by Andrea Sponziello on 11/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//
@class ChatGroup;

@protocol ChatGroupsDelegate
@required
-(void)groupAddedOrChanged:(ChatGroup *)group;
@end
