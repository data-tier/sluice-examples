# Sluice Examples

Working examples for [Sluice](https://data-tier.com/sluice.html) with Kafka and Pub/Sub running locally via Docker Compose.

## Kafka

Start Kafka and Sluice:

```bash
docker compose --profile kafka up
```

This starts:
- Kafka broker (bitnami/kafka) on port 9092
- Creates topics: user-events, page-views, system-metrics
- Sluice gateway on port 8080

Publish some messages:

```bash
./kafka/publish.sh
```

The script sends valid messages, a message with a missing required field (gets 400), and a message to an unknown topic (gets 404).

Stop:

```bash
docker compose --profile kafka down
```

## Pub/Sub

Start the Pub/Sub emulator and Sluice:

```bash
docker compose --profile pubsub up
```

This starts:
- Pub/Sub emulator on port 8085
- Creates topics: user-events, page-views, system-metrics
- Sluice gateway on port 8080

Publish some messages:

```bash
./pubsub/publish.sh
```

Stop:

```bash
docker compose --profile pubsub down
```

## What's in each example

Both examples use the same topic setup:

- **user-events**: JSON validation (requires user_id, event_type), ordering by x-user-id header
- **page-views**: JSON validation (requires url, session_id), no ordering
- **system-metrics**: no validation, no ordering

Schemas are loaded from local files via `schema_override`. See `kafka/sluice.yaml` and `pubsub/sluice.yaml` for the gateway config.

## Docs

- [Sluice product page](https://data-tier.com/sluice.html)
- [Kafka setup guide](https://data-tier.com/sluice/kafka.html)
- [Pub/Sub setup guide](https://data-tier.com/sluice/pubsub.html)
- [Topic configuration](https://data-tier.com/sluice/topics.html)
