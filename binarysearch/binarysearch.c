#include "devscc.h"
#include "sf-types.h"
#include "sh7708.h"
#include "e-types.h"

int binary_search(int arr[], int size, int key) {
    int left = 0;
    int right = size - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;

        // Use LED to indicate the current middle value (for visualization purposes)
        volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
        *gDebugLedsMemoryMappedRegister = arr[mid];

        if (arr[mid] == key) {
            return mid;
        }
        if (arr[mid] < key) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;  // Key not found
}

int main(void) {
    // Larger array for more comprehensive testing
    int arr[] = {
        2, 3, 4, 10, 40, 44, 55, 67, 89, 123, 456, 789, 1024, 2048,
        2050, 2060, 2070, 2080, 2090, 2100, 2110, 2120, 2130, 2140,
        2150, 2160, 2170, 2180, 2190, 2200, 2210, 2220, 2230, 2240,
        2250, 2260, 2270, 2280, 2290, 2300, 2310, 2320, 2330, 2340,
        2350, 2360, 2370, 2380, 2390, 2400, 2410, 2420, 2430, 2440,
        2450, 2460, 2470, 2480, 2490, 2500, 2510, 2520, 2530, 2540,
        2550, 2560, 2570, 2580, 2590, 2600, 2610, 2620, 2630, 2640,
        2650, 2660, 2670, 2680, 2690, 2700, 2710, 2720, 2730, 2740,
        2750, 2760, 2770, 2780, 2790, 2800, 2810, 2820, 2830, 2840,
        2850, 2860, 2870, 2880, 2890, 2900, 2910, 2920, 2930, 2940,
        2950, 2960, 2970, 2980, 2990, 3000
    };
    int size = sizeof(arr) / sizeof(arr[0]);
    int key = 123;

    int result = binary_search(arr, size, key);

    // Use LED to indicate the result
    volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
    if (result != -1) {
        *gDebugLedsMemoryMappedRegister = 0xFFFFFFFF;  // Key found
    } else {
        *gDebugLedsMemoryMappedRegister = 0x0;  // Key not found
    }

    return 0;
}
