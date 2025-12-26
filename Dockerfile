FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader

# Create SQLite database
RUN touch /app/database/database.sqlite

# Run migrations and seed
RUN php artisan migrate:fresh --seed --force

# Expose port
EXPOSE 8080

# Start server - generate swagger docs at runtime when env vars are available
CMD php artisan l5-swagger:generate && php artisan serve --host=0.0.0.0 --port=${PORT:-8080}