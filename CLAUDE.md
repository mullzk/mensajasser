## Project Overview

Mensajasser is a Ruby on Rails application for tracking statistics for a group of friends playing the Swiss card game "Jass" (specifically "Offener Differenzler"). The application tracks game rounds, players (Jassers), and their results to generate various statistics and rankings.

## Architecture

### Core Models
- **Round**: Represents a game round/tableau with 4 players and their results
- **Jasser**: Represents a player in the game
- **Result**: Links a Jasser to a Round with their game statistics (spiele, differenz)
- **User**: Handles authentication and user management

### Controllers
- **RankingController**: Displays various statistics and rankings (yearly, monthly, eternal, etc.)
- **GraphController**: Generates charts and visualizations
- **RoundsController**: Manages game round creation and editing
- **JassersController**: Manages player information
- **UsersController**: Handles authentication and user management

### Key Features
- Multiple ranking views (yearly, monthly, eternal, last 3/12 months)
- Statistics like "Berseker", "Angstgegner", and "Schädling"
- Graph visualizations for player performance over time
- Authentication system with basic user roles
- Mobile-friendly responsive design

### Database
- Uses MariaDB (via the Trilogy adapter) in all environments
- Database schema includes rounds, jassers, results, and users tables
- Complex statistical calculations are performed via model methods and SQL queries

### Frontend
- Propshaft asset pipeline with importmap-rails (no bundler/transpiler)
- Hotwire (Turbo + Stimulus) for JavaScript behavior
- Plain CSS, with a vendored, compiled Bootstrap 5 stylesheet for responsive design

## Development Notes

### Testing
- Uses Rails' built-in testing framework
- FactoryBot for test data generation
- Capybara and Selenium for system tests
- Test coverage focuses on models and controllers

### Dependencies
- Rails 8.0
- Ruby 3.3.5
- Bootstrap 5 (vendored compiled CSS) for styling
- Hotwire (Turbo + Stimulus) for JavaScript
- Will_paginate for pagination

### Deployment
- Designed for Heroku deployment
- Uses separate dev and production branches
- Maintenance workflow documented in README.md