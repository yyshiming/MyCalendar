//
//  EventHelper.m
//  KDBCommon
//
//  Created by Zsm on 15/12/15.
//  Copyright © 2015年 YY. All rights reserved.
//

#import "MyEventHelper.h"

NSString *const kEventTitle = @"event_title";
NSString *const kEventDate = @"event_date";
NSString *const kEventTime = @"event_time";
NSString *const kEventContent = @"event_content";
NSString *const kMyEvent = @"my_event";
@implementation MyEventHelper

+ (MyEventHelper *)sharedEvent
{
    static MyEventHelper *__shareEventHelper__ = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __shareEventHelper__ = [[MyEventHelper alloc] init];
    });
    return __shareEventHelper__;
}

- (NSDictionary *)allEvents
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kMyEvent];
}
- (NSArray *)eventsWithDate:(NSString *)dateString
{
    return [[self allEvents] objectForKey:dateString];
}
- (void)addEventWithContents:(NSDictionary *)contents
{
    NSMutableDictionary *allMyEvents = [NSMutableDictionary dictionaryWithDictionary:[self allEvents]];
    NSString *key = contents[kEventDate];
    NSArray *dateEvents = [allMyEvents objectForKey:key];
    
    NSString *timeValue = [NSString stringFromDate:[NSDate date]];
    NSMutableDictionary *newContents = [NSMutableDictionary dictionaryWithDictionary:contents];
    [newContents setObject:timeValue forKey:kEventTime];
    
    NSInteger index = -1;
    for (NSDictionary *dict in dateEvents) {
        NSString *eventTime = dict[kEventTime];
        if ([eventTime isEqualToString:contents[kEventTime]]) {
            index = [dateEvents indexOfObject:dict];
        }
    }
    
    NSMutableArray *addEvents = [NSMutableArray arrayWithArray:dateEvents];
    if (index >= 0) {
        [addEvents replaceObjectAtIndex:index withObject:newContents];
    }
    else {
        [addEvents addObject:newContents];
    }

    [allMyEvents setObject:addEvents forKey:key];
    
    NSLog(@"%@", allMyEvents);
    [[NSUserDefaults standardUserDefaults] setObject:allMyEvents forKey:kMyEvent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeEventWithContents:(NSDictionary *)contents
{
    NSMutableDictionary *allMyEvents = [NSMutableDictionary dictionaryWithDictionary:[self allEvents]];
    NSString *key = contents[kEventDate];
    NSArray *dateEvents = [allMyEvents objectForKey:key];
    NSMutableArray *newEvents = [NSMutableArray arrayWithArray:dateEvents];
    
    for (NSDictionary *dict in dateEvents) {
        NSString *eventTime = dict[kEventTime];
        if ([eventTime isEqualToString:contents[kEventTime]]) {
            [newEvents removeObject:dict];
        }
    }
    [allMyEvents setObject:newEvents forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:allMyEvents forKey:kMyEvent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
