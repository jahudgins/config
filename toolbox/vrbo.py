import argparse
import json
import os
import re
import sys
import win32clipboard

from enum import Enum
from html.parser import HTMLParser

class State(Enum):
    URL = 0
    BASE = 1
    IDS = 2
    PRICE = 3


class MyHTMLParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.state = State.URL
        self.ids = []
        self.properties = []
        self.num_properties = 0
        self.percent_properties = -1
        self.properties_spec = ''
        self.sleeps = -1
        self.bedrooms = -1
        self.bathrooms = -1
        self.num_reviews = -1
        self.review = -1


    def handle_starttag(self, tag, attrs):
        if tag == 'img':
            for attr_tag, attr_data in attrs:
                if attr_tag == 'src':
                    m = re.match(r'https://images.trvl-media.com/lodging/(?P<id>[^?]*)?', attr_data)
                    if m:
                        self.ids.append(m["id"])

            # print(f'{tag=}, {attrs=}')
        pass # print("Encountered a start tag:", tag)

    def handle_endtag(self, tag):
        pass # print("Encountered an end tag :", tag)

    def handle_data(self, data):
        if self.state == State.URL:
            if re.match(r'Version', data):
                lines = data.split()
                for line in lines:
                    m = re.match(r'.*SourceURL:(?P<url>.*)', line)
                    if m:
                        url = m['url']
                        m = re.match(r'.*endDate=(?P<endDate>\d\d\d\d-\d\d-\d\d)', url)
                        self.end_date = m['endDate']
                        m = re.match(r'.*startDate=(?P<startDate>\d\d\d\d-\d\d-\d\d)', url)
                        self.start_date = m['startDate']
                        # print(f'{self.start_date=}, {self.end_date=}')
                self.state = State.BASE
                return

        m = re.match(r'(?P<num_properties>[0-9]*) properties$', data)
        if m:
            self.num_properties = int(m['num_properties'])
            #print(f'{self.num_properties=}')
            return

        m = re.match(r'Only (?P<percent_properties>[0-9]*)% of properties', data)
        if m:
            self.percent_properties = int(m['percent_properties'])
            #print(f'{self.percent_properties=}')
            return

        m = re.match(r'Sleeps (?P<sleeps>[0-9]*) . (?P<bedrooms>[0-9]*) bedrooms . (?P<bathrooms>[0-9]*) bathrooms', data)
        if m:
            self.sleeps = int(m['sleeps'])
            self.bedrooms = int(m['bedrooms'])
            self.bathrooms = int(m['bathrooms'])
            # print(f'{self.sleeps=}')
            return

        m = re.match(r'(?P<review>[0-9.]*) .* \((?P<num_reviews>[0-9]*) reviews\)$', data)
        if m:
            self.review = float(m['review'])
            self.num_reviews = int(m['num_reviews'])
            # print(f'{self.review=}')
            return

        m = re.match(r'The price is \$(?P<price>[,0-9]*)', data)
        if m:
            price = int(m['price'].replace(',', ''))
            self.properties_spec = '(price, ids, sleeps, bedrooms, bathrooms, review, num_reviews)'
            self.properties.append((price, self.ids, self.sleeps, self.bedrooms, self.bathrooms, self.review, self.num_reviews))
            # print(f'{self.properties[-1]=}')
            self.ids = []
            self.sleeps = -1
            self.bedrooms = -1
            self.bathrooms = -1
            self.num_reviews = -1
            self.review = -1
            return

        try:
            pass # print(f'{data=}')
        except:
            pass

    def to_dict(self):
        return {
            'start_date': self.start_date,
            'end_date': self.end_date,
            'num_properties': self.num_properties,
            'percent_properties': self.percent_properties,
            'properties_spec': self.properties_spec,
            'properties': self.properties
        }

 

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

def process_clipboard(output_directory):
    #src_to_file(read_clipboard())
    #src = src_from_file()
    src = read_clipboard()
    src_string = src.decode('utf-8')
    parser = MyHTMLParser()
    parser.feed(src_string)
    filename = os.path.join(output_directory, f'{parser.start_date}.json')
    with open(filename, 'wt') as f:
        json.dump(parser.to_dict(), f)

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
    parser.add_argument('--directory', '-d', help='Specify output file')
    args = parser.parse_args()

    process_clipboard(args.directory)


if __name__ == '__main__':
    sys.exit(main())
