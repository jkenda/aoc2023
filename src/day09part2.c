#include <stdio.h>
#include <stdbool.h>
#include "day09common.c"

int predict(const int *num, size_t nums)
{
    int diff[nums - 1];
    size_t len = 0;

    bool all_zero = true;
    for (size_t i = 1; i < nums; i++) {
        int d = num[i] - num[i - 1];
        all_zero &= (d == 0);
        diff[len++] = d;
    }

    int first = num[0];
    if (all_zero)
        return first;
    else
        return first - predict(diff, len);
}

int main()
{
    vec numbers = vec_make(100);
    int sum = 0;

    while (true) {
        int number;
        char c = '\n';

        size_t n = scanf("%d%c", &number, &c);
        if (n == EOF) break;

        vec_push(&numbers, number);
        if (c != '\n') continue;

        sum += predict(numbers.data, numbers.len);
        numbers.len = 0;
    }

    printf("%d\n", sum);
}
