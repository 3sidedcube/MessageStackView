//
//  SwizzledMethod.h
//  MessageStackView
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwizzledMethod : NSObject

@property (nonatomic, assign) SEL original;
@property (nonatomic, assign) SEL swizzled;

-(instancetype)initWithOriginal:(SEL)original swizzled:(SEL)swizzled;

@end

NS_ASSUME_NONNULL_END
