import zlib
import sys

with open(sys.argv[1], 'rb') as f:
    read_data = f.read()

write_data = zlib.decompress(read_data)
with open(sys.argv[2], 'wb') as f:
    f.write(write_data)
