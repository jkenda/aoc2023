#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct
{
    char *begin, *end;
    size_t len;
}
Range;

Range make_range(char *begin, size_t len)
{
    return (Range) {
        .begin = begin,
        .end = begin + len,
        .len = len
    };
}

// get the next arrangement
void next_arr(Range *range, size_t n)
{
    if (n == 0) return;

    Range *prev  = range - 1;
    Range *next  = range + 1;

    // range++
    range->begin++;
    range->end++;

    // overflow -> carry
    if (range->end + 1 >= next->begin) {
        next_arr(range - 1, n - 1);
        range->begin = prev->end + 1;
        range->end = range->begin + range->len;
    }
}

// check if the arrangement is valid
bool arr_valid(char springs[], size_t slen, Range ranges[], size_t rlen)
{
    for (size_t i = 0; i < rlen; i++) {
        char *before = (i > 0) ? ranges[i - 1].end : springs;

        // check that the space before the range
        // is clear of known damaged springs
        for (char *c = before; c < ranges[i].begin; c++)
            if (*c == '#') return false;

        for (char *c = ranges[i].begin; c < ranges[i].end; c++)
            if (*c == '.') return false;
    }

    // check that the space after all the ranges
    // is clear of known damaged springs
    for (char *c = ranges[rlen - 1].end; c < springs + slen; c++)
        if (*c == '#') return false;

    return true;
}

// sum up all valid arrangements
size_t arrangements(char sbegin[], size_t slen, uint64_t groups[], size_t glen)
{
    size_t sum = 0;

    // create initial ranges -
    // the last one is imaginary and marks the end
    Range ranges[glen + 1];
    ranges[0] = make_range(sbegin, groups[0]);
    ranges[glen] = make_range(sbegin + slen + 2, 0);

    for (size_t i = 1; i < glen; i++) {
        ranges[i] = make_range(ranges[i - 1].end + 1, groups[i]);
    }

    // iterate over all possible arrangements,
    // increasing the sum if they are valid
    while (ranges[glen - 1].end + 1 < ranges[glen].begin) {
        if (arr_valid(sbegin, slen, ranges, glen)) sum++;
        next_arr(&ranges[glen - 1], glen);
    }

    return sum;
}


int main()
{
    size_t sum = 0;

    char *line = NULL;
    size_t len = 0;

    while ((getline(&line, &len, stdin)) != EOF) {
        char *springs = strtok(line, " ");
        char *grp_str = strtok(NULL, "\n");

        size_t groups[BUFSIZ], groups_len = 0;
        char *str = strtok(grp_str, ",\n");
        while (str != NULL) {
            groups[groups_len++] = strtoul(str, NULL, 10);
            str = strtok(NULL, ",\n");
        }

        sum += arrangements(springs, strlen(springs), groups, groups_len);
    }

    printf("%lu\n", sum);
    free(line);
}
