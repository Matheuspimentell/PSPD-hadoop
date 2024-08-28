
import random
import requests

word_site = "https://www.mit.edu/~ecprice/wordlist.10000"

response = requests.get(word_site)
WORDS = response.text.splitlines()

file = open("/tmp/run_volume/words.txt", "w+")
for _ in range(50000000):
	file.write(random.choice(WORDS) + "\n")
