//
//  EventBus.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEvent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EventBusDelegate;

/**
 * The EventBus manages message delivering and message listeners subscription.
 * To do this the class defines some concepts:
 * @par Listener registration: objects implementing EventBusDelegate protocol 
 * can be registered as listener for a specific type of messages. From then
 * on the listener is invoked whenever a message of that specific type is sent
 * around.
 * @par Event queuing: objects implementing IEvent interface may be put in a
 * queue, waiting for future dispatching. The standard EventBus implementation
 * sends queued events when update message is invoked.
 * @par Instant event: an event may be sent immediately to listeners. Sometimes
 * it makes sense to do that, but the standard method should be event queuing.
 * @note The engine uses a default instance, but users may instances as many
 * message buses as they see fit. Different instances will not share event
 * queues, nor events listeners.
 */
@interface EventBus : NSObject
/**
 * Objects implementing EventBusDelegate protocol
 * can be registered as listener for a specific type of messages. From then
 * on the listener is invoked whenever a message of that specific type is sent
 * around.
 * @par delegate An object implementing the EventBusDelegate protocol.
 * @par eType Defines the listener's event type interest.
 */
- (void)registerListener:(id<EventBusDelegate>)delegate
            forEventType:(NSUInteger)eType;
/**
 * Queues an event for future dispatch.
 * @par event An object implementing the IEvent protocol
 */
- (void)queueEvent:(id<IEvent>)event;
/**
 * Dispatches an event immediately, avoiding the queuing.
 * @par event The dispatching event.
 */
- (void)fireEvent:(id<IEvent>)event;
/**
 * Dispatches queued events.
 */
- (void)update:(NSTimeInterval)dt;
@end

/**
 * Objects interested in event listening implements this protocol.
 */
@protocol EventBusDelegate <NSObject>
@required
/**
 * Method invoked by the event bus on event dispatch.
 * @par event The event dispatched.
 * @par type Event type.
 */
- (void)receivedEvent:(id<IEvent>)event
             withType:(NSUInteger)type;

@end

@interface EventBus(Shared)
/**
 * Default event bus instance used by the engine.
 */
+ (EventBus*)defaultBus;
@end

NS_ASSUME_NONNULL_END
