//
//  ProxyingNavigationControllerDelegate.m
// LiveViewNative
//
//  Created by Shadowfacts on 6/13/22.
//

#import "ProxyingNavigationControllerDelegate.h"

@implementation ProxyingNavigationControllerDelegate

- (instancetype)initWithFirst:(id<UINavigationControllerDelegate>)first second:(id<UINavigationControllerDelegate>)second {
    self.first = first;
    self.second = second;
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.first respondsToSelector:aSelector] || [self.second respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    id result = [(id)self.first methodSignatureForSelector:sel];
    if (!result) {
        result = [(id)self.second methodSignatureForSelector:sel];
    }
    return result;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.first respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.first];
    }
    if ([self.second respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.second];
    }
}

@end
