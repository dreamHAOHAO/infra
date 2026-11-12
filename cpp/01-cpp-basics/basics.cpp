
#include <iostream>
#include <vector>

int main() {
    const int N = 8;
    
    std::vector<int> A(N);
    std::vector<int> B(N);
    std::vector<int> C(N);


    for (int i=0; i<N;i++){
        A[i] = i;
        B[i] = i*3;
        C[i] = A[i]+B[i];
    }

    int x = 10;
    int& ref = x;

    ref = 99;
    std::cout<<"x="<< x << '\n';

    for (int i = 0 ; i<N; i++){
        std::cout
            << A[i]<<"+"
            << B[i]<<"="
            << C[i]<<"\n";
    }

    return 0;
}