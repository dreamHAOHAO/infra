
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define CHECK(call) do {                         \
    cudaError_t err = (call);                   \
    if (err != cudaSuccess) {                   \
        fprintf(stderr, "CUDA Error: %s\n",     \
                cudaGetErrorString(err));       \
        exit(1);                                \
    }                                           \
} while (0)


// GPU 上运行的函数
__global__ void vectorAdd(
    const int *A,
    const int *B,
    int *C,
    int N
) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < N) {
        C[i] = A[i] + B[i];
    }
}

int main() {
    const int N = 13;

    // CPU 数组
    int h_A[N], h_B[N], h_C[N];

    for (int i = 0; i < N; i++) {
        h_A[i] = i + 10;
        h_B[i] = i * 3;
    }

    // GPU 指针
    int *d_A, *d_B, *d_C;

    size_t bytes = N * sizeof(int);

    // 申请 GPU 显存
    CHECK(cudaMalloc((void**)&d_A, bytes));
    CHECK(cudaMalloc((void**)&d_B, bytes));
    CHECK(cudaMalloc((void**)&d_C, bytes));

    // CPU -> GPU
    CHECK(cudaMemcpy(d_A, h_A, bytes,
                     cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B, h_B, bytes,
                     cudaMemcpyHostToDevice));

    // 每个 Block 4 个线程
    int threads = 4;
    int blocks = (N + threads - 1) / threads;
    
    printf("N=%d, Blocks=%d, Threads=%d\n",
       N, blocks, blocks * threads);

    // 启动 GPU 计算
    vectorAdd<<<blocks, threads>>>(d_A, d_B, d_C, N);

    CHECK(cudaGetLastError());
    CHECK(cudaDeviceSynchronize());

    // GPU -> CPU
    CHECK(cudaMemcpy(h_C, d_C, bytes,
                     cudaMemcpyDeviceToHost));

    // 输出结果
    for (int i = 0; i < N; i++) {
        printf("%d + %d = %d\n",
               h_A[i], h_B[i], h_C[i]);

        if (h_C[i] != h_A[i] + h_B[i]) {
            fprintf(stderr, "Result mismatch!\n");
            return 1;
        }
    }

    // 释放 GPU 显存
    CHECK(cudaFree(d_A));
    CHECK(cudaFree(d_B));
    CHECK(cudaFree(d_C));

    return 0;
}