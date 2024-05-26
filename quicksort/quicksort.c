#include "devscc.h"
#include "sf-types.h"
#include "sh7708.h"

#include "e-types.h"

// Function to swap two elements
void swap(uchar *a, uchar *b) {
    uchar temp = *a;
    *a = *b;
    *b = temp;
}

// The partition function
int partition(uchar arr[], int low, int high) {
    uchar pivot = arr[high]; // pivot
    int i = (low - 1); // Index of smaller element

    for (int j = low; j <= high - 1; j++) {
        // If current element is smaller than or equal to pivot
        if (arr[j] <= pivot) {
            i++; // increment index of smaller element
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return (i + 1);
}

// QuickSort function
void quickSort(uchar arr[], int low, int high) {
    if (low < high) {
        // pi is partitioning index, arr[pi] is now at right place
        int pi = partition(arr, low, high);

        // Separately sort elements before
        // partition and after partition
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

int main(void) {
    uchar qsort_input[] = {
        0x53, 0x69, 0x6e, 0x67, 0x20, 0x74, 0x6f, 0x20, 0x6d, 0x65, 0x20, 0x6f, 0x66, 0x20, 0x74, 0x68, 0x65, 0x20, 0x6d, 0x61, 0x6e, 0x2c, 0x20, 0x4d, 0x75, 0x73, 0x65, 0x2c, 0x20, 0x74, 0x68, 0x65, 0x20, 0x6d, 0x61, 0x6e, 0x20, 0x6f, 0x66, 0x20, 0x74, 0x77, 0x69, 0x73, 0x74, 0x73, 0x20, 0x61, 0x6e, 0x64, 0x20, 0x74, 0x75, 0x72, 0x6e, 0x73, 0x2e, 0x2e, 0x2e
    };

    const int qsort_input_len = sizeof(qsort_input) / sizeof(qsort_input[0]);

    volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;

    *gDebugLedsMemoryMappedRegister = 0xFFFFFFFF; // Indicating start of the sort
    quickSort(qsort_input, 0, qsort_input_len - 1);
    *gDebugLedsMemoryMappedRegister = 0x0; // Indicating end of the sort

    // //This is a dummy wait for visual inspection
    // for (int i = 0; i < 10000000; i++) {
    //   // do nothing
    // }
    return 0;
}
