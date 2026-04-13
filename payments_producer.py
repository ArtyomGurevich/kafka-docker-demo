from kafka import KafkaProducer
import json, time, random

producer = KafkaProducer(
    bootstrap_servers=["kafka:9092"],
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

while True:
    msg = {"payment_id": random.randint(1000, 9999), "amount": random.randint(10, 500), "method": random.choice(["card","paypal","crypto"])}
    producer.send("payments", msg)
    print("Sent:", msg)
    time.sleep(2)
