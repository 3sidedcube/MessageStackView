//
//  UIViewController+Lifecycle.m
//  MessageStackView
//
//  Created by Ben Shutt on 26/07/2020.
//  Copyright © 2020 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+Lifecycle.h"
#import "SwizzledMethod.h"

#define SWIZZLE_LOG 0
#define SWIZZLE(X, Y) [[SwizzledMethod alloc] initWithOriginal:(X) swizzled:(Y)]

NSString *kViewWillAppearNotification = @"kViewWillAppearNotification";
NSString *kViewWillDisappearNotification = @"kViewWillDisappearNotification";

@implementation UIViewController (Lifecycle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        for (SwizzledMethod *swizzledMethod in [UIViewController swizzledMethods]) {
            SEL originalSelector = swizzledMethod.original;
            SEL swizzledSelector = swizzledMethod.swizzled;
            
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod = class_addMethod(
                class,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod)
            );
            
            if (didAddMethod) {
                class_replaceMethod(
                    class,
                    swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod)
                );
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

+ (NSArray<SwizzledMethod *> *)swizzledMethods {
    return @[
        SWIZZLE(@selector(viewWillAppear:), @selector(swizzled_viewWillAppear:)),
        SWIZZLE(@selector(viewWillDisappear:), @selector(swizzled_viewWillDisappear:))
    ];
}

#pragma mark - Method Swizzling

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    
    if (SWIZZLE_LOG) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kViewWillAppearNotification object:self];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated {
    [self swizzled_viewWillDisappear:animated];
    
    if (SWIZZLE_LOG) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kViewWillDisappearNotification object:self];
}

@end
