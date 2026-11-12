#include <iostream>
#include <vector>
#include <stdexcept>

int main() {
    // 创建一个 vector
    std::vector<int> nums = {};

    // 增加一个元素
    // nums.push_back(10);
    // nums.push_back(20);

    std::cout << "size = " << nums.size() << '\n';

    // 空数组检查
    if (nums.empty()) {
        std::cout << "Vector is empty\n";
    } else {
        long long sum = 0;
        int min_value = nums[0];
        int max_value = nums[0];

        // 遍历所有元素
        for (int value : nums) {
            sum += value;

            if (value < min_value) {
                min_value = value;
            }

            if (value > max_value) {
                max_value = value;
            }
        }

        std::cout << "sum = " << sum << '\n';
        std::cout << "min = " << min_value << '\n';
        std::cout << "max = " << max_value << '\n';
    }

    // 故意测试越界访问
    try {
        std::cout << nums.at(nums.size()) << '\n';
    } catch (const std::out_of_range&) {
        std::cout << "Caught out_of_range\n";
    }

    return 0;
}
