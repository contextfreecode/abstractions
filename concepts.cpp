#include <cmath>
#include <concepts>
#include <iostream>
#include <type_traits>
#include <vector>

template<class Vec>
using Scalar = std::decay<decltype(Vec()[0])>::type;

template<class Vec>
concept FloatVec =
    std::floating_point<Scalar<Vec>> &&
    requires(Vec vec) {
        { vec.size() } -> std::integral;
    };

template<FloatVec Vec>
auto norm(const Vec& vec) -> Scalar<Vec> {
    using Index = decltype(vec.size());
    // Check empty first to avoid adding 0 and achieve zero cost.
    if (vec.size() == 0) {
        return 0;
    }
    // Non-empty case.
    Scalar<Vec> result = vec[0] * vec[0];
    for (Index i = 1; i < vec.size(); i += 1) {
        result += vec[i] * vec[i];
    }
    return std::sqrt(result);
}

struct Point2 {
    float x = 0;
    float y = 0;

    auto size() const -> int {
        return 2;
    }

    auto operator[](int i) const -> float {
        return i == 0 ? x : y;
    }
};

float norm2(float x, float y) {
    // return std::sqrt(x * x + y * y);
    return norm(Point2{x, y});
}

double norm_nd(const std::vector<double>& a) {
    return norm(a);
}

int main() {
    std::cout << "norm: " << norm_nd({1, 2, 3}) << std::endl;
    std::cout << "norm: " << norm2(3, 4) << std::endl;
}
