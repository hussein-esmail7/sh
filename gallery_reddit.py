'''
reddit_gallery.py
Hussein Esmail
Created: 2021 06 09
Updated: 2021 06 20
Description: This program prints the individual Reddit image URLs from a Reddit Gallery link.
'''

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service # Used to set Chrome location
from selenium.webdriver.chrome.options import Options # Used to add aditional settings (ex. run in background)
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By # Used to determine type to search for (normally By.XPATH)
import sys          # To exit the program and get arguments
import platform     # To get the OS type
import os           # To check file paths
import validators

# ========= COLOR CODES =========
color_end               = '\033[0m'
color_darkgrey          = '\033[90m'
color_red               = '\033[91m'
color_green             = '\033[92m'
color_yellow            = '\033[93m'
color_blue              = '\033[94m'
color_pink              = '\033[95m'
color_cyan              = '\033[96m'
color_white             = '\033[97m'
color_grey              = '\033[98m'

# ========= COLORED STRINGS =========
str_prefix_q            = f"[{color_pink}Q{color_end}]"
str_prefix_y_n          = f"[{color_pink}y/n{color_end}]"
str_prefix_ques         = f"{str_prefix_q}\t "
str_prefix_err          = f"[{color_red}ERROR{color_end}]\t "
str_prefix_done         = f"[{color_green}DONE{color_end}]\t "
str_prefix_info         = f"[{color_cyan}INFO{color_end}]\t "

def main():
    options = Options()
    options.add_argument("--headless")  # Run in background
    os_type = platform.system()
    service = Service(ChromeDriverManager(log_level=0).install())
    driver = webdriver.Chrome(service=service, options=options)
    url_to_open = sys.argv[-1]
    if not validators.url(url_to_open):
        print(str_prefix_err + "Not a URL: '" + url_to_open + "'")
        sys.exit(1)
    driver.get(url_to_open)            # Open the target URL

    pic_list = driver.find_element(By.XPATH, "//ul").find_elements(By.XPATH, ".//a")
    pic_urls = []
    for pic in pic_list:
        pic_url = pic.get_attribute("href").split('?')[0]
        if pic_url.endswith('.jpg') or pic_url.endswith('.png'):
            pic_url = pic_url.replace('preview.', 'i.')
        else:                           # Unknown exceptions
            print("Video or non-JPG, not done.")
            print(pic_url)
        pic_urls.append(pic_url)        # Add formatted URL to array
    print(" ".join(pic_urls))           # Print all URLs in one line
    driver.close()                      # Close the browser
    options.extensions.clear()          # Clear the options that were set
    sys.exit()                          # Exit the program

if __name__ == "__main__":
    main()
