#include <algorithm>
#include <iostream>
#include "day03common.cpp"

using namespace std;

int main()
{
    parse();
    int sum = 0;

    for (const auto& [scoord, _] : symbols) {
        vector<size_t, StackAlloc<size_t>> adjacent;
        for (const auto& [ncoord, i] : coord_to_num) {
            if (find(adjacent.begin(), adjacent.end(), i) != adjacent.end())
                continue;
            if (neighbor(scoord, ncoord)) {
                adjacent.push_back(i);
                sum += nums[i];
            }
        }
    }
    
    cout << sum << '\n';
}
