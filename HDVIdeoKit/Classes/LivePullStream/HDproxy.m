//
//  HDproxy.m
//  HDVideoKitDemok
//
//  Created by ^-^ on 2020/12/10.
//

#import "HDproxy.h"

@interface HDproxy()

@property (nonatomic, weak) id object;

@end

@implementation HDproxy
- (instancetype)initWithObjc:(id)object {
    
    self.object = object;
    return self;
}

+ (instancetype)proxyWithObjc:(id)object {
    
    return [[self alloc] initWithObjc:object];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    if ([self.object respondsToSelector:invocation.selector]) {
        
        [invocation invokeWithTarget:self.object];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    return [self.object methodSignatureForSelector:sel];
}
@end
