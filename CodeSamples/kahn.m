#import <Foundation/Foundation.h>

NSArray<NSNumber *> *kahn(NSDictionary<NSNumber *, NSMutableSet<NSNumber *> *> *graph, NSInteger n) {
    NSMutableDictionary<NSNumber *, NSMutableSet<NSNumber *> *> *inverse = [NSMutableDictionary dictionary];
    for (NSNumber *u in graph) {
        for (NSNumber *v in graph[u]) {
            if (!inverse[v]) {
                inverse[v] = [NSMutableSet set];
            }
            [inverse[v] addObject:u];
        }
    }

    NSMutableArray<NSNumber *> *stack = [NSMutableArray array];
    for (NSInteger v = 0; v < n; v++) {
        if (!inverse[@(v)]) {
            [stack addObject:@(v)];
        }
    }

    NSMutableArray<NSNumber *> *order = [NSMutableArray array];
    while (stack.count > 0) {
        NSNumber *u = [stack lastObject];
        [stack removeLastObject];
        [order addObject:u];
        for (NSNumber *v in [graph[u] allObjects]) {
            [graph[u] removeObject:v];
            [inverse[v] removeObject:u];
            if (inverse[v].count == 0) {
                [stack addObject:v];
            }
        }
    }

    if (order.count != n) {
        return @[];
    }

    return order;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:@"input.txt"];
        NSFileHandle *outputFile = [NSFileHandle fileHandleForWritingAtPath:@"output.txt"];
        NSData *inputData = [inputFile readDataToEndOfFile];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        NSArray<NSString *> *inputLines = [inputString componentsSeparatedByString:@"\n"];
        NSInteger inputIndex = 0;
        NSInteger t = [inputLines[inputIndex] integerValue];
        inputIndex++;

        NSMutableArray<NSString *> *output = [NSMutableArray array];
        for (NSInteger i = 0; i < t; i++) {
            NSInteger n = [inputLines[inputIndex] integerValue];
            inputIndex++;
            NSMutableDictionary<NSNumber *, NSMutableSet<NSNumber *> *> *graph = [NSMutableDictionary dictionary];

            while (YES) {
                NSString *line = inputLines[inputIndex];
                inputIndex++;
                if ([line length] > 0) {
                    NSArray<NSString *> *lineComponents = [line componentsSeparatedByString:@" "];
                    NSNumber *u = @([lineComponents[0] integerValue]);
                    NSNumber *v = @([lineComponents[1] integerValue]);
                    if (!graph
