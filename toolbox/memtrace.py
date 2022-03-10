import argparse
import json
import sys

RECORD_ALLOC = 0
RECORD_FREE = 1
RECORD_LAST = 2

def process_file(filename):
    allocations_by_name = {}
    deallocations_by_name = {}
    current_allocations = {}
    current_size = {}
    highwater_size = {}
    total_allocated = 0
    found_deallocations = 0
    missing_deallocations = 0
    missing_deallocations_by_name = {}
    count = 0

    with open(filename, 'rt') as file_handle:
        line = file_handle.readline()
        while line:
            if line[0:2] == '[\n' or line[0] == ']':
                line = file_handle.readline()
                continue

            try:
                record_type, name, size, location = json.loads(line[:-2])
            except:
                break

            if record_type == 0:
                allocations_by_name[name] = allocations_by_name.get(name, 0) + size
                current_size[name] = current_size.get(name, 0) + size
                highwater_size[name] = max(highwater_size.get(name, 0), current_size[name])
                total_allocated += size
                current_allocations[location] = (size, name)

            elif record_type == 1:
                if location in current_allocations:
                    alloc_size, alloc_name = current_allocations[location]
                    allocations_by_name[alloc_name] -= alloc_size
                    found_deallocations += 1
                    if name not in deallocations_by_name:
                        deallocations_by_name[name] = alloc_size
                    else:
                        deallocations_by_name[name] += alloc_size
                else:
                    missing_deallocations += 1
                    missing_deallocations_by_name[name] = missing_deallocations_by_name.get(name, 0) + 1 
                current_allocations.pop(location, None)

            elif record_type == 2:
                pass

            count += 1
            if count % 100000 == 0:
                print(f'count:{count}, found_deallocations:{found_deallocations}, missing_deallocations:{missing_deallocations}, total_allocated:{total_allocated/1024/1024:.1f} MB')
                break


            line = file_handle.readline()

    print(f'count:{count}, found_deallocations:{found_deallocations}, missing_deallocations:{missing_deallocations}, total_allocated:{total_allocated/1024/1024:.1f} MB')
    print()

    print_top("Total Allocations", allocations_by_name, 10)
    print_top("Highwater", highwater_size, 10)
    print_top("Missing Deallocations", missing_deallocations_by_name, 10, counts=True)

def print_top(heading, allocations, number, counts=False):
    allocations_list = [(size, name) for name, size in allocations.items()]
    allocations_list.sort()
    print(f'** {heading} **')
    for allocation in allocations_list[-number:]:
        if counts:
            print(f'{allocation[0]} : {allocation[1]}')
        else:
            print(f'{allocation[0]/1024/1024:.1f} MB : {allocation[1]}')
    print()

def main():
    parser = argparse.ArgumentParser(description='Analyze memtrace file produced by memtrace.cpp.')
    parser.add_argument('--file', '-f', help='Specify file to process')
    args = parser.parse_args()

    process_file(args.file)

    return 0


if __name__ == '__main__':
    sys.exit(main())
