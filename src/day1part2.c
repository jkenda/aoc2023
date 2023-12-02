#include <stddef.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

void set_numbers(bool *new_line, int *first, int *last, int number)
{
    if (*new_line) {
        *first = number;
        *last = number;
        *new_line = false;
    }
    else {
        *last = number;
    }
}

bool starts_with(const char *prefix, const char *str)
{
    for (size_t i = 0; i < strlen(prefix); i++) {
        if (str[i] == '\0' || prefix[i] != str[i])
            return false;
    }
    return true;
}

int main() {
    char line[BUFSIZ];
    size_t n;

    int first, last;
    bool new_line = true;
    int sum = 0;

    while ((n = fread(&line, 1, sizeof(line), stdin)) > 0) {
        for (char *c = line; c < line + n; c++) {
            if (*c == '\n') {
                sum += 10 * first + last;
                new_line = true;
            }
            else if (*c >= '0' && *c <= '9')
                set_numbers(&new_line, &first, &last, *c - '0');
            else if (starts_with("one", c))
                set_numbers(&new_line, &first, &last, 1);
            else if (starts_with("two", c))
                set_numbers(&new_line, &first, &last, 2);
            else if (starts_with("three", c))
                set_numbers(&new_line, &first, &last, 3);
            else if (starts_with("four", c))
                set_numbers(&new_line, &first, &last, 4);
            else if (starts_with("five", c))
                set_numbers(&new_line, &first, &last, 5);
            else if (starts_with("six", c))
                set_numbers(&new_line, &first, &last, 6);
            else if (starts_with("seven", c))
                set_numbers(&new_line, &first, &last, 7);
            else if (starts_with("eight", c))
                set_numbers(&new_line, &first, &last, 8);
            else if (starts_with("nine", c))
                set_numbers(&new_line, &first, &last, 9);
        }
    }

    printf("%d\n", sum);
}
