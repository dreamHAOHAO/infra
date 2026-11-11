
#include <cstdio>
#include <cuda_runtime.h>

// __global__ 表示这是一个 GPU Kernel
__global__ void showThreads() {

    // 当前 Block 的编号
    int blockId = blockIdx.x;

    // 当前线程在 Block 内的编号
    int threadId = threadIdx.x;

    // 计算全局线程编号
    int globalId = blockIdx.x * blockDim.x
                   + threadIdx.x;

    printf("Block=%d Thread=%d GlobalID=%d\n",
           blockId, threadId, globalId);
}

int main() {

    // 启动 2 个 Block，每个 Block 4 个线程
    showThreads<<<2, 4>>>();

    // 检查 Kernel 启动
    cudaError_t err = cudaGetLastError();

    if (err != cudaSuccess) {
        printf("Launch error: %s\n",
               cudaGetErrorString(err));
        return 1;
    }

    // 等待 GPU 运行完成
    err = cudaDeviceSynchronize();

    if (err != cudaSuccess) {
        printf("CUDA error: %s\n",
               cudaGetErrorString(err));
        return 1;
    }

    return 0;
}
