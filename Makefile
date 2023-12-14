CC=gcc
CARGS=--std=gnu99 -Os -s
CXX=g++
CXXARGS=--std=c++20 -Os -s
RC=rustc
RARGS=-C opt-level=2 -C debuginfo=0 -C codegen-units=1 -C strip=symbols -C panic=abort
OC=ocamlc
OARGS=

all: selection day01 day02 day03 day04 day05 day06 day07 day08 day09 day10 day11 day12 day13

selection:
	@mkdir -p bin
	g++ $(CXXARGS) -o bin/selection selection.cpp

day01:
	@mkdir -p bin
	@$(CC) $(CARGS) -o bin/day01 src/day01.c
	@bin/day01 < input/day01
	@$(CC) $(CARGS) -o bin/day01 src/day01part2.c
	@bin/day01 < input/day01

day02:
	@mkdir -p bin
	@$(OC) $(OARGS) -o bin/day02 -I src src/day02common.ml src/day02.ml
	@bin/day02 < input/day02
	@$(OC) $(OARGS) -o bin/day02 -I src src/day02common.ml src/day02part2.ml
	@bin/day02 < input/day02
	@rm -f src/*.cm* src/*.o

day03:
	@mkdir -p bin
	@g++ $(CXXARGS) -o bin/day03 src/day03.cpp
	@bin/day03 < input/day03
	@g++ $(CXXARGS) -o bin/day03 src/day03part2.cpp
	@bin/day03 < input/day03

day04:
	@mkdir -p bin
	@fasm src/day04.asm 1> /dev/null
	@mv src/day04 bin
	@bin/day04 < input/day04

day05:
	@mkdir -p bin
	@$(RC) $(RARGS) -o bin/day05 src/day05.rs
	@bin/day05 < input/day05
	@$(RC) $(RARGS) -o bin/day05 src/day05part2.rs
	@bin/day05 < input/day05

day06:
	@mkdir -p bin
	@fasm src/day06.asm 1> /dev/null
	@mv src/day06 bin
	@bin/day06 < input/day06

day07:
	@mkdir -p bin
	@g++ $(CXXARGS) -o bin/day07 src/day07.cpp
	@bin/day07 < input/day07
	@g++ $(CXXARGS) -o bin/day07 src/day07part2.cpp
	@bin/day07 < input/day07

day08:
	@mkdir -p bin
	@$(OC) $(OARGS) -o bin/day08 src/day08.ml
	@bin/day08 < input/day08
	@rm -f src/*.cm* src/*.o

day09:
	@mkdir -p bin
	@$(CC) $(CARGS) -o bin/day09 src/day09.c
	@bin/day09 < input/day09
	@$(CC) $(CARGS) -o bin/day09 src/day09part2.c
	@bin/day09 < input/day09

day10:
	@mkdir -p bin
	@$(OC) $(OARGS) -o bin/day10 src/day10.ml
	@bin/day10 < input/day10
	@rm -f src/*.cm* src/*.o

day11:
	@mkdir -p bin
	@$(RC) $(RARGS) -o bin/day11 src/day11.rs
	@bin/day11 < input/day11
	@$(RC) $(RARGS) -o bin/day11 src/day11part2.rs
	@bin/day11 < input/day11

day12:
	@mkdir -p bin
	@$(CC) -g $(CARGS) -o bin/day12 src/day12.c
	@bin/day12 < input/day12

day13:
	@mkdir -p bin
	@fasm src/day13.asm 1> /dev/null
	@mv src/day13 bin
	@bin/day13 < input/day13

day14:
	@mkdir -p bin
	@$(RC) $(RARGS) -o bin/day14 src/day14.rs
	@bin/day14 < input/day14

clean:
	rm -f -rf bin
