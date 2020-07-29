//
//  SwizzledMethod.m
//  MessageStackView
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import "SwizzledMethod.h"

@implementation SwizzledMethod

- (instancetype)initWithOriginal:(SEL)original swizzled:(SEL)swizzled {
    if (self = [super init]) {
        self.original = original;
        self.swizzled = swizzled;
    }
    return self;
}

@end
