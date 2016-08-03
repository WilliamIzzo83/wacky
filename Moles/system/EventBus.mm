//
//  EventBus.m
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "EventBus.h"
#include <list>

/// Type definition for events listeners delegates list.
typedef NSHashTable<id<EventBusDelegate>> EBDelegatesList;
/**
 * Type definition for listeners map
 * @note The NSNumber is used to have the event type as a key. This comes with
 * some overhead while boxing the NSUInteger (representing the event type) 
 * inside the NSNumber. The situation can be completely avoided by using
 * std::map
 */
typedef NSMutableDictionary<NSNumber*,EBDelegatesList*> EBListenersMap;
/** 
 * Typedef defining the event queue
 * @note The c++ std list has been choosen because it allows list updating
 * while iterating on the list itself. This is most desirable because an event
 * may be sent to a listener that enqueues other events on his own. 
 * NSMutableArray won't allow this essential behavior.
 */
typedef std::list<id<IEvent>> EBCEventsQueue;

@interface EventBus() {
    NSTimeInterval elapsedTime;
    EBCEventsQueue eventsQueue;
};

@property (strong, nonatomic) EBListenersMap* listenersMap;

@end

@implementation EventBus
- (instancetype)init {
    self = [super init];
    
    self.listenersMap = [EBListenersMap dictionary];
    return self;
}
- (void)registerListener:(id<EventBusDelegate>)delegate
            forEventType:(NSUInteger)eType{
    NSNumber* nEType = @(eType);
    EBDelegatesList* dlList = self.listenersMap[nEType];
    if (dlList == nil) {
        dlList = [EBDelegatesList hashTableWithOptions:NSPointerFunctionsWeakMemory];
        self.listenersMap[nEType] = dlList;
    }
    
    [dlList addObject:delegate];
}

- (void)queueEvent:(id<IEvent>)event {
    self->eventsQueue.push_back(event);
}

- (void)fireEvent:(id<IEvent>)event {
    NSNumber* et = @([event type]);
    EBDelegatesList* dlList = self.listenersMap[et];
    for (id<EventBusDelegate> delegate in dlList) {
        [delegate receivedEvent:event
                       withType:[event type]];
    }
}

- (void)update:(NSTimeInterval)dt {
    self->elapsedTime += dt;
    
    
    auto eqIt = self->eventsQueue.begin();
    
    for (; eqIt != self->eventsQueue.end(); ++eqIt) {
        id<IEvent> event = *eqIt;
        NSNumber* et = @([event type]);
        EBDelegatesList* dlList = self.listenersMap[et];
        for (id<EventBusDelegate> delegate in dlList) {
            [delegate receivedEvent:event
                           withType:[event type]];
        }
    }
    
    self->eventsQueue.clear();

}
@end

@implementation EventBus(Shared)

+ (EventBus*)defaultBus {
    static dispatch_once_t onceToken;
    static EventBus* defaultEventBus = nil;
    dispatch_once(&onceToken, ^{
        defaultEventBus = [[EventBus alloc] init];
    });
    
    return defaultEventBus;
}

@end
