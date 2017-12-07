//
//  Message.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/20/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "ChatMessage.h"
//#import <Firebase/Firebase.h>
#import "SHPStringUtil.h"

@implementation ChatMessage

-(id)init {
    self = [super init];
    if (self) {
        // initialization
    }
    return self;
}

-(NSString *)dateFormattedForListView {
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    NSString *date = [timeFormat stringFromDate:self.date];
    return date;
}

-(void)updateStatusOnFirebase:(int)status {
    NSDictionary *message_dict = @{
        @"status": [NSNumber numberWithInt:status]
    };
    [self.ref updateChildValues:message_dict];
}

+(ChatMessage *)messageFromSnapshotFactory:(FIRDataSnapshot *)snapshot {
    NSString *conversationId = snapshot.value[MSG_FIELD_CONVERSATION_ID];
    NSString *type = snapshot.value[MSG_FIELD_TYPE];
    NSString *text = snapshot.value[MSG_FIELD_TEXT];
    NSString *sender = snapshot.value[MSG_FIELD_SENDER];
    NSString *senderFullname = snapshot.value[MSG_FIELD_SENDER_FULLNAME];
    NSString *recipient = snapshot.value[MSG_FIELD_RECIPIENT];
    NSString *recipientGroupId = snapshot.value[MSG_FIELD_RECIPIENT_GROUP_ID];
    NSString *lang = snapshot.value[MSG_FIELD_LANG];
    NSNumber *timestamp = snapshot.value[MSG_FIELD_TIMESTAMP];
    NSMutableDictionary *attributes = snapshot.value[MSG_FIELD_ATTRIBUTES];
    NSLog(@"snapshot. %@", [snapshot.value[MSG_FIELD_ATTRIBUTES] class]);
    NSLog(@"DECODED ATTRIBUTES (%@): %@", text, attributes);
    
    ChatMessage *message = [[ChatMessage alloc] init];
    
    message.attributes = attributes;
    NSLog(@"MESSAGE.ATTRIBUTES.. %@", message.attributes);
    message.key = snapshot.key;
    message.ref = snapshot.ref;
    message.messageId = snapshot.key;
    message.conversationId = conversationId;
    message.text = text;
    message.lang = lang;
    message.mtype = type;
    NSLog(@"DECODED TYPE %@", message.mtype);
    message.sender = sender;
    message.senderFullname = senderFullname;
    message.date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue/1000];
    NSLog(@"Message date %@", message.date);
    message.status = [(NSNumber *)snapshot.value[MSG_FIELD_STATUS] intValue];
    message.recipient = recipient;
    message.recipientGroupId = recipientGroupId;
    return message;
}

@end
