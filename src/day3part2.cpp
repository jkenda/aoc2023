#include <algorithm>
#include <iostream>
#include <istream>
#include <sstream>
#include <vector>
#include <string>

struct coord
{
    int row, col, val;
    coord(int r, int c, int v) : row(r), col(c), val(v) {}
};

using namespace std;

vector<int> numbers;
vector<pair<const coord, int*>> coord_to_num;
vector<coord> symbols;

void parse(istream& in)
{
    char c;
    int row = 0, col = 0;

    int n = 0;
    bool in_number = false;

    while ((c = in.get()) > 0) {
        if (isdigit(c)) {
            if (!in_number) {
                numbers.push_back(0);
                in_number = true;
            }
            int& num = numbers.back();
            coord_to_num.emplace_back(coord(row, col, 0), &num);
            num = 10 * num + (c - '0');
        }
        else {
            if (in_number) {
                in_number = false;
                n = 0;
            }
            if (c != '.' && !isspace(c)) {
                symbols.emplace_back(row, col, c);
            }
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

int dist(const coord& a, const coord& b)
{
    return abs(a.row - b.row) + abs(a.col - b.col);
}

bool diagonal(const coord& a, const coord& b)
{
    return abs(a.row - b.row) == 1 && abs(a.col - b.col) == 1;
}

int main()
{
    string str(istreambuf_iterator<char>(cin), {});
    istringstream stream(str);
    numbers.reserve(str.size());

    parse(stream);
    int sum = 0;

    for (const coord& sym : symbols) {
        if (sym.val != '*') continue;

        vector<int*> adjacent;
        for (const auto& [coord, num] : coord_to_num) {
            if (find(adjacent.begin(), adjacent.end(), num) != adjacent.end()) continue;
            if (dist(sym, coord) == 1 || diagonal(sym, coord)) {
                adjacent.push_back(num);
            }
        }

        if (adjacent.size() == 2) {
            sum += *adjacent[0] * *adjacent[1];
        }
    }
    
    cout << sum << '\n';
}
