#include <cctype>
#include <iostream>
#include <vector>

using namespace std;

template <typename T>
class StackAlloc
{
public:
    using value_type = T;

    constexpr StackAlloc() = default;

    T* allocate(size_t n)
    {
        return pool;
    }

    void deallocate(T* p, size_t n)
    {}

    size_t operator()(const T& n) const
    {
        return static_cast<size_t>(n);
    }

private:
    T pool[8];
};

struct coord
{
    int row, col;
    coord(int r, int c) : row(r), col(c) {}
};

vector<int> nums;
vector<tuple<const coord, const size_t>> coord_to_num;
vector<tuple<const coord, const char>> symbols;

void parse()
{
    char c;
    int row = 0, col = 0;

    bool in_number = false;

    while ((c = cin.get()) > 0) {
        if (isdigit(c)) {
            if (!in_number)
                nums.push_back(0);
            in_number = true;

            int& num = nums.back();
            size_t i = nums.size() - 1;
            coord_to_num.emplace_back(coord(row, col), i);
            num = 10 * num + (c - '0');
        }
        else {
            if (c != '.' && c != '\n')
                symbols.emplace_back(coord(row, col), c);
            in_number = false;
        }

        if (c == '\n') {
            col = 0;
            row++;
        }
        else {
            col++;
        }
    }
}

bool neighbor(const coord& a, const coord& b)
{
    return (abs(a.row - b.row) + abs(a.col - b.col) == 1)
        || (abs(a.row - b.row) == 1 && abs(a.col - b.col) == 1);
}

