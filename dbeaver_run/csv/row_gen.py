import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta
from tqdm import tqdm

fake = Faker()

# Number of rows to generate (Config)
NUM_CUSTOMERS = 1000000
NUM_CATEGORIES = 1000000
NUM_PRODUCTS = 1000000
NUM_ORDERS = 1000000
NUM_ORDER_ITEMS = 1000000


categories = pd.DataFrame({
    "category_id": list(range(1, NUM_CATEGORIES + 1)),
    "category_name": [fake.word().capitalize() for _ in range(NUM_CATEGORIES)],
    "description": [fake.sentence() for _ in range(NUM_CATEGORIES)]
})
categories.to_csv("categories.csv", index=False)


customers = pd.DataFrame({
    "customer_id": list(range(1, NUM_CUSTOMERS + 1)),
    "first_name": [fake.first_name() for _ in range(NUM_CUSTOMERS)],
    "last_name": [fake.last_name() for _ in range(NUM_CUSTOMERS)],
    "email": [fake.email() for _ in range(NUM_CUSTOMERS)],
    "created_at": [fake.date_time_between(start_date="-3y", end_date="now") for _ in range(NUM_CUSTOMERS)]
})
customers.to_csv("customers.csv", index=False)


products = pd.DataFrame({
    "product_id": list(range(1, NUM_PRODUCTS + 1)),
    "category_id": [random.randint(1, NUM_CATEGORIES) for _ in range(NUM_PRODUCTS)],
    "product_name": [fake.word().capitalize() for _ in range(NUM_PRODUCTS)],
    "price": [round(random.uniform(5.0, 2000.0), 2) for _ in range(NUM_PRODUCTS)],
    "description": [fake.sentence() for _ in range(NUM_PRODUCTS)],
})
products.to_csv("products.csv", index=False)


orders = pd.DataFrame({
    "order_id": list(range(1, NUM_ORDERS + 1)),
    "customer_id": [random.randint(1, NUM_CUSTOMERS) for _ in range(NUM_ORDERS)],
    "order_date": [fake.date_time_between(start_date="-1y", end_date="now") for _ in range(NUM_ORDERS)],
    "status": [random.choice(["completed", "pending", "cancelled"]) for _ in range(NUM_ORDERS)],
    "total_amount": [0.0 for _ in range(NUM_ORDERS)], 
})
orders.to_csv("orders.csv", index=False)


order_items = []
for _ in tqdm(range(NUM_ORDER_ITEMS), desc="Generating order_items"):
    order_id = random.randint(1, NUM_ORDERS)
    product_id = random.randint(1, NUM_PRODUCTS)
    quantity = random.randint(1, 5)
    price = round(random.uniform(5.0, 2000.0), 2)
    order_items.append([order_id, product_id, quantity, price])

df_order_items = pd.DataFrame(order_items, columns=["order_id", "product_id", "quantity", "price"])
df_order_items.to_csv("order_items.csv", index=False)


print("Recomputing order totals...")
order_totals = df_order_items.groupby("order_id").apply(
    lambda x: round((x["quantity"] * x["price"]).sum(), 2)
)
orders.set_index("order_id", inplace=True)
orders["total_amount"] = order_totals
orders.reset_index().to_csv("orders.csv", index=False)
