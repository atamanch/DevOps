# Goal: Extract the link count and link which is at the top of the page of the below website

import requests
from bs4 import BeautifulSoup

# Query website, store the result as a variable and soupify it
result = requests.get("<enter your URL here>")
src = result.content
soup = BeautifulSoup(src, 'lxml')

# Initialize variables for pulling out article count and article URL from website
total_count = ""

# Iterate through the result-info div tag and find the heading4 text for Total Count
for div_tag in soup.find_all("div", class_="result-info"):
    h_tag = div_tag.find('h4')
    total_count = h_tag.text + "\n"

# Loop through each div tag with the "item high-line" class and add the a href URL to the urls variable
urls = ""

for div_tag in soup.find_all("div", class_="item high-line"):
    a_tag = div_tag.find('a')
    urls = a_tag.attrs['href']

# Print out the variables
print(total_count)
print(urls)

try:
    state_file = open("StateFile.txt", "r", encoding="utf-8")
    lines = state_file.readlines()
    old_total_count = lines[0]
    old_urls = lines[2]

    if (total_count != old_total_count) or (urls != old_urls):
        print("\nCurrent state does not match saved state, something changed on the site")
        print("\nWriting current state to StateFile.txt")

        state_file = open("StateFile.txt", "w", encoding="utf-8")
        state_file.write(total_count+"\n")
        state_file.write(urls)

        #TODO
        # Email function for sending emails when changes are detected
    else:
        print("\nNo changes in state detected")
except:
    print("\nNo state file exists, creating one called StateFile.txt")
    state_file = open("StateFile.txt", "w", encoding="utf-8")
    state_file.write(total_count+"\n")
    state_file.write(urls)

finally:
    state_file.close()
