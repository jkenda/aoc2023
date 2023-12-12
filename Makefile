CARGS=-Os -s
CPPARGS=-std=c++20 -Os -s
RARGS=-C opt-level=2 -C debuginfo=0 -C codegen-units=1 -C strip=symbols -C panic=abort
OARGS=-O3

all: selection day01 day02 day03 day04 day05 day06 day07 day08 day09 day10 day11

selection:
	@mkdir -p bin
	g++ $(CPPARGS) -o bin/selection selection.cpp

day01:
	@mkdir -p bin
	@gcc $(CARGS) -o bin/day01 src/day01.c
	@bin/day01 < input/day01
	@gcc $(CARGS) -o bin/day01 src/day01part2.c
	@bin/day01 < input/day01

day02:
	@mkdir -p bin
	@ocamlopt $(OARGS) -o bin/day02 -I src src/day02common.ml src/day02.ml
	@bin/day02 < input/day02
	@ocamlopt $(OARGS) -o bin/day02 -I src src/day02common.ml src/day02part2.ml
	@bin/day02 < input/day02
	@rm src/*.cm* src/*.o
	@strip bin/day02

day03:
	@mkdir -p bin
	@g++ $(CPPARGS) -o bin/day03 src/day03.cpp
	@bin/day03 < input/day03
	@g++ $(CPPARGS) -o bin/day03 src/day03part2.cpp
	@bin/day03 < input/day03

day04:
	@mkdir -p bin
	@fasm src/day04.asm 1> /dev/null
	@mv src/day04 bin
	@bin/day04 < input/day04

day05:
	@mkdir -p bin
	@rustc $(RARGS) -o bin/day05 src/day05.rs
	@bin/day05 < input/day05
	@rustc $(RARGS) -o bin/day05 src/day05part2.rs
	@bin/day05 < input/day05

day06:
	@mkdir -p bin
	@fasm src/day06.asm 1> /dev/null
	@mv src/day06 bin
	@bin/day06 < input/day06

day07:
	@mkdir -p bin
	@g++ $(CPPARGS) -o bin/day07 src/day07.cpp
	@bin/day07 < input/day07
	@g++ $(CPPARGS) -o bin/day07 src/day07part2.cpp
	@bin/day07 < input/day07

day08:
	@mkdir -p bin
	@ocamlopt $(OARGS) -o bin/day08 src/day08.ml
	@bin/day08 < input/day08
	@rm src/*.cm* src/*.o
	@strip bin/day08

day09:
	@mkdir -p bin
	@gcc $(CARGS) -o bin/day09 src/day09.c
	@bin/day09 < input/day09
	@gcc $(CARGS) -o bin/day09 src/day09part2.c
	@bin/day09 < input/day09

day10:
	@mkdir -p bin
	@ocamlopt $(OARGS) -o bin/day10 src/day10.ml
	@bin/day10 < input/day10
	@rm src/*.cm* src/*.o
	@strip bin/day10

day11:
	@mkdir -p bin
	@rustc $(RARGS) -o bin/day11 src/day11.rs
	@bin/day11 < input/day11
	@rustc $(RARGS) -o bin/day11 src/day11part2.rs
	@bin/day11 < input/day11
	@strip bin/day11

clean:
	rm -rf bin
