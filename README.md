# Notifier

A Rails application for managing customers and sending SMS messages using Twilio, with support for customizable message templates.

## Features

- **Customers**: Full CRUD operations for managing customer information.
- **Message Templates**: Create, update, delete, and list message templates with placeholders for customer data, supporting multiple languages (primary and English).
- **Messages**: Send SMS messages using Twilio, with support for templates, recent message checks, and language selection based on customer phone number.
- **Credentials Management**: Secure storage and retrieval of sensitive information using Rails encrypted credentials.
- **Prometheus Instrumentation**: Monitor application metrics with Prometheus for enhanced observability and performance tracking.
- **Test Coverage**: Includes a suite of tests to ensure the correctness and reliability of its features.

## Getting Started

### Prerequisites

- Docker
- master.key file (ask Guilherme C. for it)

  
### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/guilhermecostacw/notifier.git
   cd notifier
   ```

2. Build and run the the Docker Containers:
```sh
   docker compose up --build
```

2. Access the application at `http://localhost:3000`.

### Running Tests

Run the test suite using RSpec:

```sh
docker compose exec web bundle exec rspec
```

## API Endpoints

### Customers

- `GET /customers`: List all customers.
- `GET /customers/:id`: Show a specific customer.
- `POST /customers`: Create a new customer.
- `PUT /customers/:id`: Update a customer.
- `DELETE /customers/:id`: Delete a customer.

### Message Templates

- `GET /message_templates`: List all message templates.
- `GET /message_templates/:id`: Show a specific message template.
- `POST /message_templates`: Create a new message template.
- `PUT /message_templates/:id`: Update a message template.
- `DELETE /message_templates/:id`: Delete a message template.

### Messages

- `GET /messages`: List all messages.
- `POST /messages`: Create and send a new message.

### Ex

Create Customer
```json
   {
  "customer": {
    "name": "John Doe",
    "phone": "+15555555555",
    "email": "john.doe@example.com"
  }
}
```

Create Template
```json
   {
  "message_template": {
    "name": "Welcome",
    "content": "Olá {{name}}",
    "content_en": "Hello {{name}} in English"
  }
}
```

Create Message

```json
   {
  "message": {
    "customer_id": 1,
    "content": "Content será enviado quando não tiver o template definido",
    "message_template_id": 1,
    "bypass_check": true
  }
}
```

### Prometheus Instrumentation
#### Running Prometheus
Prometheus is included as a service in the Docker Compose setup. It is configured to scrape metrics from the Rails application and itself.

To access the Prometheus dashboard, navigate to http://localhost:9090.

#### Custom Metrics
The application is instrumented to expose custom metrics using the prometheus_exporter gem. These metrics include:

HTTP Request Metrics: Metrics related to the HTTP requests, such as response times and statuses.
Database Metrics: Metrics related to database queries and their performance.
Custom Application Metrics: Any other custom metrics defined in the application code.

#### Accessing Metrics
Metrics can be accessed at the /metrics endpoint of the application. This endpoint is exposed on the Prometheus exporter port (default: 9394).

To see the metrics, navigate to http://localhost:9394/metrics.

Usage
Once Prometheus is up and running, you can use it to create dashboards, set up alerts, and analyze the performance of your Rails application.



## Environment Variables

The following environment variables must be set for the application to function correctly:

### Twilio

- `twilio.account_sid`: Your Twilio Account SID.
- `twilio.auth_token`: Your Twilio Auth Token.
- `twilio.phone_number`: The Twilio phone number used for sending messages.
