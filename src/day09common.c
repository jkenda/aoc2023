#include <stdlib.h>

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
