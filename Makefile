CARGS=-O3

selection:
	g++ $(CARGS) -o bin/selection selection.cpp

day1:
	@mkdir -p bin
	@gcc $(CARGS) -o bin/day1 src/day1.c
	@bin/day1 < input/day1
	@gcc $(CARGS) -o bin/day1 src/day1part2.c
	@bin/day1 < input/day1

day2:
	@ocaml src/day2.ml < input/day2
	@ocaml src/day2part2.ml < input/day2

day3:
	@mkdir -p bin
	@g++ $(CARGS) -o bin/day3 src/day3.cpp
	@bin/day3 < input/day3

clean:
	rm -rf bin
