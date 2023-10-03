import logging
import re
import time
import pandas as pd
import requests
from bs4 import BeautifulSoup
from .utils import save_to_csv_s3

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def get_products(categories: list[str]):
    product_list = []

    for category in categories:
        url =f"https://tonaton.com/{category}"
        page = 1

        logging.info(f"fetching category: {category}")
        while page <= 3:
            logging.info(f"fetching page {page}")
            resp = requests.get(url+f"?page={page}")
            content = BeautifulSoup(resp.content, "html.parser")
            for product in content.select("div.product__content"):

                try:
                    title = product.select("span.product__title")[0].get_text().strip()
                    location = product.select("p.product__location")[0].get_text().strip()
                    description = product.select("p.product__description")[0].get_text().strip()
                    condition = product.select("div.product__tags span")[0].get_text().strip()
                    data = {
                        "title": title,
                        "location": location,
                        "description": description,
                        "condition": condition
                    }
                except IndexError:
                    continue  
                product_list.append(data)        
            time.sleep(1)
            page += 1
            
    return product_list

# categories to scrape
categories = ["c_vehicles", "c_mobile-phones-tablets", "c_fashion-and-beauty"]

def run():
    object_key = "src/product_list.csv"
    product_list = get_products(categories)
    save_to_csv_s3(object_key, product_list)

