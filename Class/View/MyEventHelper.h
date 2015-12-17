//
//  EventHelper.h
//  KDBCommon
//
//  Created by Zsm on 15/12/15.
//  Copyright © 2015年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const kEventTitle;
UIKIT_EXTERN NSString *const kEventDate;
UIKIT_EXTERN NSString *const kEventTime;
UIKIT_EXTERN NSString *const kEventContent;
@interface MyEventHelper : NSObject

+ (MyEventHelper *)sharedEvent;
- (NSDictionary *)allEvents;
- (NSArray *)eventsWithDate:(NSString *)dateString;
- (void)addEventWithContents:(NSDictionary *)contents;
- (void)removeEventWithContents:(NSDictionary *)contents;

@end
