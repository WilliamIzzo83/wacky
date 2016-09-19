//
//  MoleReleaseData.h
//  Moles
//
//  Created by William Izzo on 03/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct MoleReleaseData {
    NSUInteger holeIndex;
    NSTimeInterval appearanceTime;
    NSTimeInterval permanenceTime;
    NSTimeInterval retreatTime;
    NSTimeInterval dieTime;
} MoleReleaseData;
