//
//  Process.h
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"
#import "IProcess.h"

NS_ASSUME_NONNULL_BEGIN

@interface Process : Event<IProcess>
- (void)inited;
- (void)success;
- (void)fail;
- (void)addChild:(Process*)process;
- (Process*)peekChild;
- (Process*)moveChild;
- (BOOL)didEnd;
@end

NS_ASSUME_NONNULL_END
