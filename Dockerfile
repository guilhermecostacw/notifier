FROM ruby:2.7.5

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Install the correct version of Bundler
RUN gem install bundler:2.4.21

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the working directory
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install the gems specified in the Gemfile
RUN bundle install

# Copy the rest of the application code into the working directory
COPY . /app

# Expose port 3000 to the Docker host
EXPOSE 3000

# Set environment variables for the Rails environment and the database URL
ENV RAILS_ENV=development
ENV DATABASE_URL=postgres://postgres:postgres@db:5432/notifier_development

# Run the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]