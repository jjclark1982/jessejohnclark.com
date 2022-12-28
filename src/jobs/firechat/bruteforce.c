#include<stdio.h>

typedef long int bitmask;
typedef long int pop_t;

pop_t city_pops[] = {18897109, 12828837, 9461105, 6371773, 5965343, 5946800, 5582170, 5564635, 5268860, 4552402, 4335391, 4296250, 4224851, 4192887, 3439809, 3279833, 3095313, 2812896, 2783243, 2710489, 2543482, 2356285, 2226009, 2149127, 2142508, 2134411};
int num_cities = sizeof(city_pops)/sizeof(pop_t);
pop_t target_pop = 100000000;

void print_selected_cities(bitmask active_cities) {
    for (int i = 0; i < num_cities; i++) {
        bitmask cursor = 1 << i;
        if (active_cities & cursor) {
            printf("City %2d: %9ld people\n", i+1, city_pops[i]);
        }
    }
}

pop_t sum_city_pops(bitmask active_cities) {
    pop_t tally = 0;
    for (int i = 0; i < num_cities; i++) {
        bitmask cursor = 1 << i;
        if (active_cities & cursor) {
            // City i is contained in active_cities and has population city_pops[i]
            tally += city_pops[i];
        }
    }
    return tally;
}

int main() {
    int solutions_found = 0;
    for (bitmask active_cities = 0; active_cities < (1l<<num_cities); active_cities++) {

        pop_t total_pop = sum_city_pops(active_cities);
        if (total_pop == target_pop) {
            ++solutions_found;
            // printf("Solution %d\n", ++solutions_found);
            print_selected_cities(active_cities);
            printf("Total:   %9ld people\n", target_pop);
        }
    }
    printf("Solutions found: %d\n", solutions_found);
    return 0;
}
