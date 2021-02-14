import marshal
import subprocess
import sys

def p4(command_args):
    output = subprocess.check_output(['p4'] + command_args).decode('utf-8').splitlines()
    return output

def filter_client_files(lines):
    new_lines = []
    for line in lines:
        if line[4:4 + len('clientFile')] == 'clientFile':
            new_line = line[4 + len('clientFile') + 1:]
            new_lines.append(new_line)
    return new_lines

def main():
    files = filter_client_files(p4(['-ztag', 'opened'] + sys.argv[1:]))
    output = ' '.join(filter_client_files(p4(['fstat', '-Ro'] + files))).replace('\\', '/')
    print(output, end='\n')

    return 0


if __name__ == '__main__':
    exit(main())
