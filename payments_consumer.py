from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    "payments",
    bootstrap_servers=["kafka:9092"],
    group_id="payments-consumer-group",      # 👈 unique group ID
    auto_offset_reset="earliest",
    value_deserializer=lambda v: json.loads(v.decode("utf-8"))
)

for msg in consumer:
    print("Payments Consumer received:", msg.value)
