#include <cassert>
#include <cstdlib>
#include <iostream>

// note that we swap rows and columns here because the original paper is in Fortran and 
// C++ is row major instead of column major.
class TSS {
    public:
    TSS(int cache_size, int cache_line_size, int row_length, int column_length) : 
        cache_size(cache_size), cache_line_size(cache_line_size), row_length(row_length), column_length(column_length) {}

    int get_working_set_size(int tile_row_size, int tile_column_size) {
        return tile_row_size * tile_column_size + tile_row_size + tile_column_size;
    }

    int get_cross_interference_rate(int tile_row_size, int tile_column_size) {
        return (2 * tile_row_size + tile_column_size) / (tile_row_size * tile_column_size);
    }

    int compute_columns(int row_size) {
        int rows_per_set = cache_size / row_length;
        int remainder1 = cache_size % row_length;
        int set_difference = row_length - remainder1;
        int rows_per_n = row_length / set_difference;
        // clarify what gap is here
        int gap = row_length % set_difference;

        if (row_size == row_length) {
            // rows per set
            return rows_per_set;
        }
        else if (row_size == remainder1 && row_size > set_difference) {
            // rows per set + 1
            return rows_per_set + 1;
        }
        else {
            int rows_per_set_diff = set_difference / row_size;
            int rows_per_gap = gap / row_size;
            return rows_per_set_diff * rows_per_n * rows_per_set 
                + rows_per_gap * rows_per_set 
                + rows_per_set_diff * (remainder1 / set_difference) + rows_per_gap;
        }
    }
    
    int run_tss() {
        int best_row = row_length, old_row = row_length;
        int best_column = cache_size / row_length, column_size = cache_size / row_length;
        int row_size = cache_size % row_length;

        while (row_size > cache_line_size && old_row % row_size != 0 && column_size < column_length) {
            column_size = compute_columns(row_size);
            int temp = column_size % cache_line_size == 0 ? column_size : (column_size / cache_line_size) * cache_line_size;
            if (   get_working_set_size(temp, column_size) > get_working_set_size(best_row, best_column)
                && get_working_set_size(temp, column_size) < cache_size
                && get_cross_interference_rate(temp, column_size) < get_cross_interference_rate(best_row, best_column)) {
                
                best_row = temp;
                best_column = column_size;
            }

            // euclidean algo
            temp = row_size;
            row_size = old_row % row_size;
            old_row = temp;
        }
        
        // adjust best col to meet working set size constraint --> ?
    }

    private:
    int cache_size;
    int cache_line_size;
    int row_length;
    int column_length;
};


int main(int argc, char* argv[]) {
    assert(argc == 5);

    int cache_size = atoi(argv[1]);
    int cache_line_size = atoi(argv[2]);
    int row_length = atoi(argv[3]);
    int column_length = atoi(argv[4]);
    
    TSS tss(cache_size, cache_line_size, row_length, column_length);
    std::cout << tss.run_tss() << std::endl;
    
}