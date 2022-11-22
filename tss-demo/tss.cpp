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
        return tile_row_size * tile_column_size + tile_row_size + cache_line_size;
    }

    float CIR(int tile_row_size, int tile_column_size) {
        return (static_cast<float>(2 * tile_row_size + tile_column_size)) / (tile_row_size * tile_column_size);
    }

    int update_with_CLS(int row_size){
        if (row_size % cache_line_size == 0 || row_size == row_length) {
            return row_size;
        } 
        else {
            return (row_size / cache_line_size) * cache_line_size;
        }
    }

    static int euclidean(int a, int b) {
        do {
            int r = a % b;
            if (r == 0) return b;
            a = b;
            b = r;
        } while (b > 0);

        return -1;
    }

    int compute_col_size(int row_size) {
        int cols_per_set = cache_size / row_length;
        int remainder1 = cache_size % row_length;
        int set_difference = row_length - remainder1;
        int cols_per_n = row_length / set_difference;
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
        int row_size = cache_size % row_length; // remainder
        bool fits_in_cache = get_working_set_size(best_row, best_column) <= cache_size;

        if (cache_size <= row_size) {
            best_row = update_with_CLS((cache_size-1)/2);
            best_column = 1;
        } 
        else {
            while (row_size > cache_line_size && old_row % row_size != 0 && column_size < column_length) {
                column_size = compute_col_size(row_size);
                int temp = update_with_CLS(row_size);
                int WS_size = get_working_set_size(temp, column_size);
                /*
                std::cout << "Row size: " << temp << "\n" << "Column size: " << column_size << "\n";
                std::cout << "WS size: " << WS_size << "\n";
                std::cout << "WS in cache: " << (WS_size < cache_size) << "\n";
                std::cout << "better WS: " << (WS_size > get_working_set_size(best_row, best_column)) << "\n";
                std::cout << "better CIR: " << (CIR(temp, column_size) < CIR(best_row, best_column)) << "\n";
                std::cout << "new_CIR oldCIR: ";
                std::cout << CIR(temp, column_size) << " ";
                std::cout << CIR(best_row, best_column) << "\n\n";
                */
                if (!fits_in_cache && WS_size < cache_size){
                    best_row = temp;
                    best_column = column_size; 
                    fits_in_cache = true;
                }
                else if (WS_size < cache_size
                         && WS_size > get_working_set_size(best_row, best_column)
                         && CIR(temp, column_size) < CIR(best_row, best_column)) {
                    best_row = temp;
                    best_column = column_size;
                }

                temp = row_size;
                row_size = old_row % row_size;
                old_row = temp;
            }

            if (!fits_in_cache){
                // maybe make more efficient?
                while(get_working_set_size(best_row, best_column) > cache_size){
                    best_row -= cache_line_size;
                }
            }
        }

        std::cout << "Best row size: " << best_row << std::endl;
        std::cout << "Best column size: " << best_column << std::endl;
        // to eliminate capacity misses, the WS should be <= the cache size
        std::cout << "Working set size: " << get_working_set_size(best_row, best_column) << std::endl;
        assert(get_working_set_size(best_row, best_column) <= cache_size); 
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

    // cache size should be multiple of cache line size.
    if (cache_line_size > cache_size || (cache_size % cache_line_size != 0)) {
        std::cout << "[ERROR] please check cache size and cache line size" << std::endl;
        exit(1);
    }

    int tmp = TSS::euclidean(cache_size, row_length);
    // std::cout << tmp << std::endl;
    TSS tss(cache_size, cache_line_size, row_length, column_length);
    tss.run_tss();
}