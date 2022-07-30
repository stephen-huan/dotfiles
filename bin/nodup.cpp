// clang++ -O3 nodup.cpp -o nodup
#include <iostream>
#include <string>
#include <unordered_set>

int main(void) {
  std::ios::sync_with_stdio(false); std::cin.tie(NULL); // fast cin
  std::unordered_set<std::string> s;
  for (std::string line; getline(std::cin, line);) {
    if (not (s.find(line) != s.end())) {
      std::cout << line << std::endl;
      s.insert(line);
    }
  }

  return 0;
}
