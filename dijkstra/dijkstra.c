#include "devscc.h"
#include "sf-types.h"
#include "sh7708.h"
#include "e-types.h"

#define INF 99999
#define NODES 20

void dijkstra(int graph[NODES][NODES], int src, int dist[NODES], int prev[NODES]) {
    int visited[NODES];
    for (int i = 0; i < NODES; i++) {
        dist[i] = INF;
        prev[i] = -1;
        visited[i] = 0;
    }
    dist[src] = 0;

    for (int i = 0; i < NODES - 1; i++) {
        int minDist = INF, minIndex = -1;
        for (int v = 0; v < NODES; v++) {
            if (!visited[v] && dist[v] < minDist) {
                minDist = dist[v];
                minIndex = v;
            }
        }

        int u = minIndex;
        visited[u] = 1;

        for (int v = 0; v < NODES; v++) {
            if (!visited[v] && graph[u][v] && dist[u] != INF && dist[u] + graph[u][v] < dist[v]) {
                dist[v] = dist[u] + graph[u][v];
                prev[v] = u;
            }
        }
    }
}

int main(void) {
    int graph[NODES][NODES] = {
        {0, 10, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {10, 0, 20, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, 20, 0, 5, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, 5, 0, 10, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, 10, 0, 5, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, 5, 0, 10, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, 10, 0, 5, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, 5, 0, 10, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, 10, 0, 5, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, 5, 0, 10, INF, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, 10, 0, 5, INF, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 5, 0, 10, INF, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 10, 0, 5, INF, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 5, 0, 10, INF, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 10, 0, 5, INF, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 5, 0, 10, INF, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 10, 0, 5, INF, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 5, 0, 10, INF},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 10, 0, 5},
        {INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 5, 0}
    };

    int dist[NODES];
    int prev[NODES];
    int source = 0;

    volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;

    *gDebugLedsMemoryMappedRegister = 0xFFFFFFFF;
    
    dijkstra(graph, source, dist, prev);

    // Output the distance array to the LEDs or a similar indicator
    for (int i = 0; i < NODES; i++) {
        *gDebugLedsMemoryMappedRegister = dist[i];  // This will depend on how you want to indicate the distance
    }

    return 0;
}

    