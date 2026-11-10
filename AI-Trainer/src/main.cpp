#include <iostream>
#include <random>
#include <cstdint>
#include <cstdio>
#include <string>
using namespace std;

int main(int argc, char* argv[]){
    int games = 1000; //default for no flag
    uint32_t seed = 42; //default for no flag

    for(int i = 1; i < argc; i++){
        string arg = argv[i]; // wrap so == compares text not address

        if (arg == "--games" && i + 1 < argc) {
            games = stoi(argv[i + 1]); // text -> int
            i++;                            // skip the value we just consumed
        } else if (arg == "--seed" && i + 1 < argc) {
            seed = stoul(argv[i + 1]); // text -> int
            i++;                            // skip the value
        }else {
            std::printf("unknown argument: %s\n", argv[i]);
            return 1;
        }
    }
    std::mt19937 rng(seed);                              // one engine, seeded
    std::uniform_int_distribution<int> d100(0, 99);      // ints 0..99 inclusive

    
    
    printf("seed = %u\n", seed);

    printf("games = %d\n", games);

    uniform_int_distribution<int>(0,99);

}