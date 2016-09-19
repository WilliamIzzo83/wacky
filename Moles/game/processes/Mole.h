//
//  Mole.h
//  Moles
//
//  Created by William Izzo on 31/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Process.h"
#import "MoleReleaseData.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mole : Process {
    
}

- (instancetype)init __unavailable;
- (instancetype)initWithHoleView:(UIView*)holeView
                       holeIndex:(NSUInteger)holeIndex;

- (instancetype)initWithHoleView:(UIView*)holeView
                     releaseData:(MoleReleaseData)releaseData
NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
