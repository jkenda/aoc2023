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


int predict(const vec *num)
{
    vec diff = vec_make(num->len - 1);

    for (size_t i = 1; i < num->len; i++) {
        int d = num->data[i] - num->data[i - 1];
        vec_push(&diff, d);
    }

    bool all_zero = true;
    for (size_t i = 0; i < diff.len; i++) {
        if (diff.data[i] != 0) {
            all_zero = false;
            break;
        }
    }

    int first = num->data[0];
    if (all_zero)
        return first;
    else
        return first - predict(&diff);
}

int main()
{
    vec numbers = vec_make(100);
    int sum = 0;

    while (1) {
        int number;
        char c = '\n';

        size_t n = scanf("%d%c", &number, &c);
        if (n == EOF) break;

        vec_push(&numbers, number);
        if (c != '\n') continue;

        sum += predict(&numbers);
        numbers.len = 0;
    }

    printf("%d\n", sum);
}
