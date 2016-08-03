//
//  ISystem.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#ifndef ISystem_h
#define ISystem_h

NS_ASSUME_NONNULL_BEGIN

/**
 * ISystem defines an interface for engine's system. As for interface definition 
 * each system has four methods that engine will invoke. Those are:
 * @par startUp: usually used to initialize the system
 * @par update: the engine will call this method, usually by synchronizing with
 * screen refresh. It is used to advance any task/computation of the system
 * itself.
 * @par pause: used to pause the system.
 * @par shutdown: invoked when the system will be deinitialized.
 */
@protocol ISystem <NSObject>
@required
/**
 * Usually used to initialize the system
 */
- (void)startUp;
/**
 * The engine will call this method, usually by synchronizing with
 * screen refresh. It is used to advance any task/computation of the system
 * itself.
 * @param dt Elapsed time interval, in seconds, since the last update call.
 */
- (void)update:(NSTimeInterval)dt;
/**
 * Used to pause the system.
 */
- (void)pause;
/**
 * Invoked when the system will be deinitialized.
 */
- (void)shutDown;
@end

NS_ASSUME_NONNULL_END

#endif /* ISystem_h */
