#include <cstdint>
#include <iostream>
#include <ranges>
#include <unordered_set>
#include <vector>

using namespace std;
namespace rv = ranges::views;

enum Dir { UP, DOWN, LEFT, RIGHT };

struct Vec2d
{
    int64_t j, i;

    Vec2d operator+(const Vec2d& o) const { return {j + o.j, i + o.i}; }
    bool operator==(const Vec2d& o) const { return j == o.j && i == o.i; }
};

struct Vec2dHash
{
    size_t operator()(const Vec2d& v) const
    {
        return v.i * 1031 + v.j;
    }
};

struct State
{
    Vec2d pos;
    Dir dir;

    bool operator==(const State& o) const { return pos == o.pos && dir == o.dir; }
};

struct StateHash
{
    size_t operator()(const State& s) const
    {
        return s.pos.i * 1031 + s.pos.j * 101 + s.dir;
    }
};

vector<vector<char>> space;

Vec2d vec(Dir d)
{
    switch (d) {
        case UP:    return {0, -1};
        case DOWN:  return {0, 1};
        case LEFT:  return {-1, 0};
        case RIGHT: return {1, 0};
    }
    return {};
}

unordered_set<Dir> reflect(char c, Dir d)
{
    if (c == '.') return {d};

    switch (d) {
        case DOWN:
            switch (c) {
                case '/': return {LEFT};
                case '\\': return {RIGHT};
                case '|': return {DOWN};
                case '-': return {LEFT, RIGHT};
            }
        case UP:
            switch (c) {
                case '/': return {RIGHT};
                case '\\': return {LEFT};
                case '|': return {UP};
                case '-': return {LEFT, RIGHT};
            }
        case RIGHT:
            switch (c) {
                case '/': return {UP};
                case '\\': return {DOWN};
                case '|': return {UP, DOWN};
                case '-': return {RIGHT};
            }
        case LEFT:
            switch (c) {
                case '/': return {DOWN};
                case '\\': return {UP};
                case '|': return {UP, DOWN};
                case '-': return {LEFT};
            }
    };

    throw "invalid direction/space: "
        + to_string(d)
        + "/" + to_string(c);
}

bool valid(const Vec2d& pos)
{
    return pos.j >= 0
        && (size_t) pos.j < space[pos.i].size()
        && pos.i >= 0
        && (size_t) pos.i < space.size();
}

size_t energized(unordered_set<State, StateHash> states)
{
    unordered_set<State, StateHash> seen_states;

    while (!states.empty()) {
        seen_states.insert(states.begin(), states.end());

        unordered_set<State, StateHash> next;

        for (const auto& state : states) {
            auto next_state =
                reflect(space[state.pos.i][state.pos.j], state.dir)
                | rv::transform([&](const Dir d) { return State { state.pos + vec(d), d }; })
                | rv::filter([&](const State& s) { return valid(s.pos); })
                | rv::filter([&](const State& s) { return !seen_states.contains(s); });
            next.insert(next_state.begin(), next_state.end());
        }

        states = next;
    }

    unordered_set<Vec2d, Vec2dHash> seen_pos;
    for (const auto& state : seen_states) {
        seen_pos.insert(state.pos);
    }

    return seen_pos.size();
}

int main()
{
    char c;
    space.emplace_back();

    while (cin.get(c)) {
        if (c == '\n') {
            space.emplace_back();
        }
        else {
            space.back().push_back(c);
        }
    }

    if (space.back().empty())
        space.pop_back();

    cout << energized({ State { Vec2d {0, 0}, Dir::RIGHT }}) << '\n';
}
