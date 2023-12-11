#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct
{
    int *data;
    size_t cap;
    size_t len;
} vec;

vec vec_make(size_t cap)
{
    vec v = {
        .data = malloc(cap * sizeof(int)),
        .cap = cap, .len = 0
    };
    return v;
}

int vec_push(vec *vec, int n)
{
    if (vec->len >= vec->cap) {
        vec->cap *= 2;
        vec->data = realloc(vec->data, vec->cap * sizeof(int));
    }
    vec->data[vec->len++] = n;
    return n;
}


int predict(const int *num, const size_t nums)
{
    int diff[nums - 1];
    size_t len = 0;

    bool all_zero = true;
    for (size_t i = 1; i < nums; i++) {
        int d = num[i] - num[i - 1];
        all_zero &= (d == 0);
        diff[len++] = d;
    }

    int last = num[nums - 1];
    if (all_zero)
        return last;
    else
        return last + predict(diff, len);
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
