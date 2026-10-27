// loader.m — iOS arm64 dylib loader
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>
#include <sys/stat.h>
#include <Foundation/Foundation.h>

__attribute__((constructor))
static void loader_init() {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *src = [bundle pathForResource:@"data" ofType:@"bundle"];
    if (!src) return;

    NSString *dst = [NSTemporaryDirectory()
                     stringByAppendingPathComponent:@"libcore.dylib"];

    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:dst error:nil];

    NSError *err = nil;
    [fm copyItemAtPath:src toPath:dst error:&err];
    if (err) return;

    chmod([dst UTF8String], 0755);
    dlopen([dst UTF8String], RTLD_NOW | RTLD_GLOBAL);
}
