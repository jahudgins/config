import sys
import tempfile

from P4 import P4, P4Exception

p4 = P4()                        # Create the P4 instance

try:                             # Catch exceptions with try/except
    p4.connect()
    describe = p4.run('describe', *sys.argv[1:])
    change = int(describe['change'])
    depot_files = describe['depotFile']
    directory = tempfile.mkdtemp()
    print(describe)
    # p4.run( "edit", "file.txt" )
    p4.disconnect()
except P4Exception:
    for e in p4.errors:
        print(e)
