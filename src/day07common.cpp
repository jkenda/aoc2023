#include <cstdint>

using namespace std;

template <typename T>
class StackAlloc
{
public:
    using value_type = T;

    constexpr StackAlloc() = default;

    T* allocate(size_t)
    {
        return pool;
    }

    void deallocate(T*, size_t)
    {}

    size_t operator()(const T& n) const
    {
        return static_cast<size_t>(n);
    }

private:
    T pool[6];
};

enum class Kind : uint8_t {
    FiveOfAKind,
    FourOfAKind,
    FullHouse,
    ThreeOfAKind,
    TwoPair,
    OnePair,
    HighCard
};
