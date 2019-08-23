FROM ruby:2.3.1
# To install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*
# Create application directory
RUN mkdir -p /app
# Copy content to application directory
COPY . /app/
# Change work directory
WORKDIR /app/
# Install dependencies
RUN bundle install
# Set default environment
ENV RAILS_ENV development
# Script to setup database
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

