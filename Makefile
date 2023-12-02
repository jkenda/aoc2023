CARGS=-O3

selection:
	g++ $(CARGS) -o bin/selection selection.cpp

day1:
	@mkdir -p bin
	@gcc $(CARGS) -o bin/day1 src/day1.c
	@bin/day1 < input/day1
	@gcc $(CARGS) -o bin/day1 src/day1part2.c
	@bin/day1 < input/day1

clean:
	rm -rf bin
