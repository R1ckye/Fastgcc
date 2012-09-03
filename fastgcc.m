#import "NSTask.h"

int main(int argc, char **argv, char **envp) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            if (argc < 2) { printf("gcc: no input files\n"); return 1; }
        NSString *arg1 = [NSString stringWithCString:argv[1]];
        NSString *nev = [[arg1 componentsSeparatedByString:@"."]objectAtIndex:0];
        NSTask *gccTask = [[NSTask alloc] init];
        [gccTask setLaunchPath:@"/usr/bin/gcc"];
        [gccTask setArguments:[NSArray arrayWithObjects:arg1, @"-o", [NSString stringWithFormat:@"%@", nev], nil]];
        [gccTask launch];
        printf("Compiling....\n");
        [gccTask waitUntilExit];
        [gccTask release];
        NSTask *ldidTask = [[NSTask alloc]init];
        [ldidTask setLaunchPath:@"/usr/bin/ldid"];
        [ldidTask setArguments:[NSArray arrayWithObjects:@"-S", nev, nil]];
        [ldidTask launch];
        printf("Signing the binary...\n");
        [ldidTask waitUntilExit];
        [ldidTask release];
            if (argc > 2) {
                if (strcmp(argv[2], "-launch") == 0) {
                    printf("Launching the program...\n");
                    NSTask *launchTask = [[NSTask alloc]init];
                        if ([nev rangeOfString:@"/"].location == NSNotFound) nev = [NSString stringWithFormat:@"./%@", nev];
                    [launchTask setLaunchPath:nev];
                            if (argc > 3) {
                                int i = 3;
                                NSMutableArray *arguments = [[NSMutableArray alloc]init];
                                while (i < argc) {
                                    [arguments addObject:[NSString stringWithCString:argv[i]]];
                                    i++;
                                }       
                                [launchTask setArguments:arguments];
                            }
                    [launchTask launch];
                    [launchTask waitUntilExit];
                    [launchTask release];
                }
        }
        [pool release];
        return 0;
}