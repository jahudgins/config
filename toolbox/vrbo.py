import argparse
#import pywin32
import re
import win32clipboard
import sys

from enum import Enum
from html.parser import HTMLParser

class State(Enum):
    URL = 0
    IDS = 1
    PRICE = 2


class MyHTMLParser(HTMLParser):
    def __init__(self):
        self.state = State.URL
        self.ids = []
        self.properties = []

    def handle_starttag(self, tag, attrs):
        if tag == 'img':
            print(f'{tag:}, {attrs:}')
        pass # print("Encountered a start tag:", tag)

    def handle_endtag(self, tag):
        pass # print("Encountered an end tag :", tag)

    def handle_data(self, data):
        try:
            if self.state == State.URL:
                m = re.match(r'.*SourceURL:.*endDate=(?P<endDate>\d\d\d\d-\d\d-\d\d).*startDate=(?P<startDate>\d\d\d\d-\d\d-\d\d)', data)
                if m:
                    self.start_date = m['startDate']
                    self.end_date = m['endDate']
                    self.state = State.BASE
                    print(f'{self.start_date:}, {self.end_date:}')
                return

            m = re.match(r'The price is $(?P<price>[0-9,]*)', data)
            if m:
                price = m['price'].replace(',', '')
                self.properties.append((price, self.ids))
                self.ids = []
                print(f'{price:}')
        except:
            pass



# https://code.activestate.com/recipes/474121-getting-html-from-the-windows-clipboard/
def get_available_formats():
    """
    Return a possibly empty list of formats available on the clipboard
    """
    formats = []
    try:
        win32clipboard.OpenClipboard(0)
        cf = win32clipboard.EnumClipboardFormats(0)
        while (cf != 0):
            formats.append(cf)
            cf = win32clipboard.EnumClipboardFormats(cf)
    finally:
        win32clipboard.CloseClipboard()

    return formats

def read_clipboard():
    html_format = win32clipboard.RegisterClipboardFormat("HTML Format")
    win32clipboard.OpenClipboard(0)
    src = win32clipboard.GetClipboardData(html_format)
    return src

def src_to_file(src):
    with open("c:/work/vrbo.html", "wb") as outfile:
        outfile.write(src)

def src_from_file():
    with open("c:/work/vrbo.html", "rb") as infile:
        return infile.read()

def process_clipboard(output_file):
    #src_to_file(read_clipboard())
    import pdb; pdb.set_trace()
    src = src_from_file()
    src_string = src.decode('utf-8')
    parser = MyHTMLParser()
    parser.feed(src_string)

"""
def process_file(input_file, output_file):
    with open(input_file, 'rt') as input_handle:
        lines = input_handle.readlines()

    for line in lines:
        if re.match(r'^Dates(?P<start_date>[^-]*) - (?P<end_date>)')
"""



def main():
    parser = argparse.ArgumentParser(description='Analyze vrbo file copied from search.')
    # parser.add_argument('--input', '-i', help='Specify file to process')
    parser.add_argument('--output', '-o', help='Specify output file')
    args = parser.parse_args()

    process_clipboard(args.output)


if __name__ == '__main__':
    sys.exit(main())
