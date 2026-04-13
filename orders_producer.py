from kafka import KafkaProducer
import json, time, random

producer = KafkaProducer(
    bootstrap_servers=["kafka:9092"],
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

while True:
    msg = {"order_id": random.randint(1000, 9999), "status": random.choice(["created","paid","shipped","delivered"])}
    producer.send("orders", msg)
    print("Sent:", msg)
    time.sleep(1)
