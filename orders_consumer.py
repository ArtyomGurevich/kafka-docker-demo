from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    "orders",
    bootstrap_servers=["kafka:9092"],
    group_id="orders-consumer-group",        # 👈 unique group ID
    auto_offset_reset="earliest",            # 👈 start from earliest messages
    value_deserializer=lambda v: json.loads(v.decode("utf-8"))
)

for msg in consumer:
    print("Orders Consumer received:", msg.value)
