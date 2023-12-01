#include <iostream>
#include <random>

const char *languages[] = {
    "C",
    "C++",
    "Rust",
    "FASM",
    "OCaml",
};

int main()
{
    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_int_distribution<int> dist(0, 4);

    std::cout << "Today's language is " << languages[dist(mt)] << std::endl;
}
