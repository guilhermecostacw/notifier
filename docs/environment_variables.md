# Configuration for environment variables

This file contains the configuration for environment variables used in the project. It includes sensitive information such as the secret key base, Twilio account SID, authentication token, and phone number.

- `secret_key_base`: The secret key base used for encryption and security purposes. This value should be kept confidential.

- `twilio.account_sid`: The account SID for the Twilio service. This is required for sending SMS messages.

- `twilio.auth_token`: The authentication token for the Twilio service. This is required for authenticating API requests.

- `twilio.phone_number`: The phone number associated with the Twilio account. This is the number from which SMS messages will be sent.

Please ensure that these values are properly configured and kept secure to protect the integrity and security of the application.

# Configuration for environment variables

secret_key_base: [REDACTED]

twilio:
account_sid: '[REDACTED]'
auth_token: '[REDACTED]'
phone_number: '+15513833605'
