CXX      := clang++
CXXFLAGS := -std=c++17 -Wall -Wextra -MMD -MP
SRC      := $(filter-out src/main.cpp,$(wildcard src/*.cpp))

release: CXXFLAGS += -O2
release: build/trainer

debug: CXXFLAGS += -O0 -g -fsanitize=address,undefined
debug: LDFLAGS  += -fsanitize=address,undefined
debug: build/trainer

test: CXXFLAGS += -O0 -g -fsanitize=address,undefined
test: LDFLAGS  += -fsanitize=address,undefined
test: build/tests
	./build/tests

build/trainer: $(SRC) src/main.cpp | build
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

build/tests: $(SRC) tests/tests.cpp | build
	$(CXX) $(CXXFLAGS) -Isrc $^ -o $@ $(LDFLAGS)

build:
	mkdir -p build

clean:
	rm -rf build

.PHONY: release debug test clean