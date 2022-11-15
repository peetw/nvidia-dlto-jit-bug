#include <iostream>
#include <cuda_runtime_api.h>

__device__ int d_result;
__global__ void kernel(const int n)
{
	d_result = n;
}

int main()
{
    const int n = rand();
    kernel<<<1, 1>>>(n);
    const cudaError cuda_status = cudaGetLastError();
    if (cuda_status != cudaSuccess)
    {
        std::cout << "FAIL: " << cudaGetErrorString(cuda_status) << std::endl;
        return 1;
    }

    std::cout << "PASS";
    return 0;
}
