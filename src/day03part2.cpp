#include <algorithm>
#include <iostream>
#include "day03common.cpp"

using namespace std;

int main()
{
    parse();
    int sum = 0;

    for (const auto& [scoord, sym] : symbols) {
        if (sym != '*') continue;

        vector<size_t, StackAlloc<size_t>> adjacent;
        for (const auto& [ncoord, i] : coord_to_num) {
            if (find(adjacent.begin(), adjacent.end(), i) != adjacent.end())
                continue;
            if (neighbor(scoord, ncoord))
                adjacent.push_back(i);
        }

        if (adjacent.size() == 2) {
            sum += nums[adjacent[0]] * nums[adjacent[1]];
        }
    }
    
    cout << sum << '\n';
}
