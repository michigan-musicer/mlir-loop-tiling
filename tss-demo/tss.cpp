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
        int WSS = tile_row_size * tile_column_size + tile_row_size + tile_column_size;
        return (WSS > cache_size) ? 0 : WSS;
    }

    int get_cross_interference_rate(int tile_row_size, int tile_column_size) {
        return (2 * tile_row_size + tile_column_size) / (tile_row_size * tile_column_size);
    }

    static int euclidean(int a, int b) {
        do {
            int r = a % b;
            if (r == 0) {
                return a;
            }
            a = b;
            b = r;
        } while (b > 0);

        return -1;
    }

    int compute_rows(int row_size) {
        int cols_per_set = cache_size / row_length;
        int remainder1 = cache_size % row_length;
        int set_difference = row_length - remainder1;
        int cols_per_n = row_length / set_difference;
        // clarify what gap is here
        int gap = row_length % set_difference;

        if (row_size == row_length) {
            // rows per set
            return cols_per_set;
        }
        else if (row_size == remainder1 && row_size > set_difference) {
            // rows per set + 1
            return cols_per_set + 1;
        }
        else {
            int cols_per_set_diff = set_difference / row_size;
            int cols_per_gap = gap / row_size;
            return cols_per_set_diff * cols_per_n * cols_per_set 
                + cols_per_gap * cols_per_set 
                + cols_per_set_diff * (remainder1 / set_difference) + cols_per_gap;
        }
    }
    
    void run_tss() {
        int best_row = row_length, old_row = row_length;
        int best_column = cache_size / row_length, column_size = cache_size / row_length;
        int row_size = cache_size % row_length;

        while (row_size > cache_line_size && old_row % row_size != 0 && column_size < column_length) {
            column_size = compute_rows(row_size);
            int temp = (row_size % cache_line_size == 0 || row_size == row_length) ? row_size : (row_size / cache_line_size) * cache_line_size;
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
        
        // TODO: adjust best col to meet working set size constraint --> ?
        if (get_working_set_size(best_row, best_column) == 0){
            while(get_working_set_size(best_row, best_column) == 0){
                best_row -= cache_line_size;
            }
        }
    
        std::cout << "Best row size: " << best_row << std::endl;
        std::cout << "Best column size: " << best_column << std::endl;
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
    
    if ((cache_line_size > cache_size) || (cache_size % cache_line_size != 0)) {
        std::cout << "Error" << std::endl;
        exit(1);
    }

    int tmp = TSS::euclidean(1024, 200);
    std::cout << tmp << std::endl;
    TSS tss(cache_size, cache_line_size, row_length, column_length);
    tss.run_tss();
}