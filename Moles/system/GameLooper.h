//
//  GameLooper.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISystem.h"
#import "GameTickEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Game looper is the system at the heart of the engine. His duty is to update
 * all of the subsystem it owns. Among the others, the most important pieces are
 * default instances of EventBus and ProcessManager. Those two system are 
 * linked with screen refresh through CADisplayLink.
 * @par On each vsync the GameLooper sends a GameTickEvent through its EventBus
 */
@interface GameLooper : NSObject<ISystem>
@end

NS_ASSUME_NONNULL_END
