//
//  IEvent.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#ifndef IEvent_h
#define IEvent_h

NS_ASSUME_NONNULL_BEGIN

/**
 * IEvent defines an interface for game engine's event. The engine is
 * message based. This allows for a certain degree of decoupling between 
 * engine's subsystems, actors, processes and the like.
 * @par This interface defines the very least method an event must have. Those
 * are:
 * @par type: An unique identifier for an event. Event receivers may check this
 * to know what to do.
 * @par timestamp: It gives an indication about when the event have been 
 * created.
 */
@protocol IEvent <NSObject>
/**
 * Event unique identifier.
 */
- (NSUInteger)type;
/**
 * Event creation timestamp.
 */
- (NSTimeInterval)timestamp;

@end

NS_ASSUME_NONNULL_END

#endif /* IEvent_h */
