#include <stdio.h>
#include <stdbool.h>

int main() {
    char c;
    int first, last;
    bool new_line = true;
    int sum = 0;

    while ((c = getchar()) != EOF) {
        if (c >= '0' && c <= '9') {
            if (new_line) {
                first = c - '0';
                last = first;
                new_line = false;
            }
            else {
                last = c - '0';
            }
        }

        if (c == '\n') {
            sum += 10 * first + last;
            new_line = true;
        }
    }

    printf("%d\n", sum);
}
