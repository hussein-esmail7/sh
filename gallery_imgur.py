'''
imgur_gallery.py
Hussein Esmail
Created: 2021 06 09
Updated: 2021 06 20
Description: This program prints the individual Imgur image URLs from a Imgur Gallery link.
'''

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import sys          # To exit the program and get arguments
import platform     # To get the OS type
import os           # To check file paths

bravedriver_path_macos = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
chromedriver_path_macos = os.path.expanduser("~") + "/Documents/Coding/Random/chromedriver"
chromedriver_path_linux = os.path.expanduser("~") + "/Documents/Coding/Random/chromedriver"

def main():
    options = Options()
    options.add_argument("--headless")  # Run in background
    os_type = platform.system()
    if os_type == "Darwin":             # macOS
        options.binary_location = bravedriver_path_macos
        driver = webdriver.Chrome(options=options)
        # driver = webdriver.Chrome(chromedriver_path_macos, options=options)
    elif os_type == "Linux":
        driver = webdriver.Chrome(chromedriver_path_linux, options=options)
    else:                               # Windows
        chromedriver_path_windows = input("Path of chromedriver for Windows: ")
        if os.path.exists(chromedriver_path_windows):
            driver = webdriver.Chrome(chromedriver_path_windows, options=options)
        else:
            print("Path not valid.")
            sys.exit()

    driver.get(sys.argv[-1])            # Open the target URL
    pic_list = driver.find_element_by_class_name("Gallery-ContentWrapper").find_elements_by_tag_name("img")
    pic_urls = []
    for pic in pic_list:
        pic_url = pic.get_attribute("src")
        if pic_url not in pic_urls:
            pic_urls.append(pic_url)        # Add formatted URL to aray
            # print(pic_url)
    print(" ".join(pic_urls))           # Print all URLs in one line
    driver.close()                      # Close the browser
    options.extensions.clear()          # Clear the options that were set
    sys.exit()                          # Exit the program

if __name__ == "__main__":
    main()
