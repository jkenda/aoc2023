CARGS=-Os -s
RARGS=-C opt-level=z -C debuginfo=0 -C codegen-units=1 -C strip=symbols -C panic=abort
OARGS=-O3

selection:
	g++ $(CARGS) -o bin/selection selection.cpp

day1:
	@mkdir -p bin
	@gcc $(CARGS) -o bin/day1 src/day1.c
	@bin/day1 < input/day1
	@gcc $(CARGS) -o bin/day1 src/day1part2.c
	@bin/day1 < input/day1

day2:
	@mkdir -p bin
	@ocaml src/day2.ml < input/day2
	@ocaml src/day2part2.ml < input/day2

day3:
	@mkdir -p bin
	@g++ $(CARGS) -o bin/day3 src/day3.cpp
	@bin/day3 < input/day3
	@g++ $(CARGS) -o bin/day3 src/day3part2.cpp
	@bin/day3 < input/day3

day4:
	@mkdir -p bin
	@fasm src/day4.asm 1> /dev/null
	@mv src/day4 bin
	@bin/day4 < input/day4

day5:
	@mkdir -p bin
	@rustc $(RARGS) -o bin/day5 src/day5.rs
	@bin/day5 < input/day5
	@rustc $(RARGS) -o bin/day5 src/day5part2.rs
	@bin/day5 < input/day5

day6:
	@mkdir -p bin
	@fasm src/day6.asm 1> /dev/null
	@mv src/day6 bin
	@bin/day6 < input/day6

day7:
	@mkdir -p bin
	@g++ $(CARGS) -o bin/day7 src/day7.cpp
	@bin/day7 < input/day7
	@g++ $(CARGS) -o bin/day7 src/day7part2.cpp
	@bin/day7 < input/day7

day8:
	@mkdir -p bin
	@ocamlopt $(OARGS) -o bin/day8 src/day8.ml
	@bin/day8 < input/day8
	@rm src/*.cm* src/*.o
	@strip bin/day8

day9:
	@mkdir -p bin
	@gcc $(CARGS) -o bin/day9 src/day9.c
	@bin/day9 < input/day9
	@gcc $(CARGS) -o bin/day9 src/day9part2.c
	@bin/day9 < input/day9

day10:
	@mkdir -p bin
	@ocamlopt $(OARGS) -o bin/day10 src/day10.ml
	@bin/day10 < input/day10
	@rm src/*.cm* src/*.o
	@strip bin/day10

clean:
	rm -rf bin
