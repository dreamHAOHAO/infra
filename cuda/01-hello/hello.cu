#include <cstdio>
#include <cuda_runtime.h>

__global__ void helloGPU() {
    printf("Hello CUDA! Thread: %d\n", threadIdx.x);
}

int main() {
    helloGPU<<<1, 4>>>();

    cudaError_t err = cudaDeviceSynchronize();

    if (err != cudaSuccess) {
        printf("CUDA Error: %s\n", cudaGetErrorString(err));
        return 1;
    }

    return 0;
}
