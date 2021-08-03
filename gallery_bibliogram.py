'''
gallery_bibliogram.py
Hussein Esmail
Created: 2021 08 02
Updated: 2021 08 02
Description: This program prints the individual Bibliogram image URLs from a Bibliogram Gallery link.
'''

import sys
from lxml import html as ht
import requests

def main():
    html = ht.fromstring(requests.get(sys.argv[-1]).content)    # Get HTML
    if "error-page" not in html.xpath('//body')[0].classes:
        links = [f"{link.get('src')}" for link in html.xpath('//img[@class="sized-image"]')]
        print(" ".join([f"https://bibliogram.snopyta.org{link}" for link in links]))
    sys.exit()

if __name__ == "__main__":
    main()
