from kafka import KafkaProducer
import json, time, random

producer = KafkaProducer(
    bootstrap_servers=["kafka:9092"],
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

while True:
    msg = {"user_id": random.randint(1, 100), "message": random.choice(["welcome","discount","alert","reminder"])}
    producer.send("notifications", msg)
    print("Sent:", msg)
    time.sleep(3)
