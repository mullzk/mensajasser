# Mensajasser Application Specifications
This specification describe the current version of this app. There are multiple changes planned.

## Overview
Mensajasser is a Ruby on Rails web application designed to track and analyze statistics for the Swiss card game "Jass" (specifically "Offener Differenzler") among a group of friends. The application records game results, calculates statistics, and provides various ranking and visualization features.

## Core Functionality

### 1. User Management
- **Authentication System**: Basic username/password authentication with SHA1 hashing
- **User Roles**: 
  - Regular users (privilege = 1): Can view all data
  - Administrators (privilege > 1): Can create/edit data
- **User Operations**:
  - Login/logout functionality
  - Password change capability for authenticated users
  - User creation and management (admin only)

### 2. Player (Jasser) Management
- **Player Registration**: Add new players to the system
- **Player Status**: Active/inactive status management
- **Player Attributes**:
  - Name and email
  - Disqualification status
  - Active status (default: true)

### 3. Game Round Management
- **Round Creation**: 
  - authenticated users only
  - Each round represents a game session (tableau/ris)
  - Must have exactly 4 players
  - Includes date, creator, and optional comment
  - Validates that all players are unique in a round
- **Round Editing**: Modify existing rounds (authenticated users only)
- **Round Deletion**: Remove rounds (authenticated users only)

### 4. Game Results Tracking
Each result within a round tracks:
- **Basic Statistics**:
  - `spiele`: Number of games played
  - `differenz`: Score difference
  - `schnitt`: Average score (differenz/spiele)
  - `max`: Maximum score in a single game
- **Special Events**:
  - `roesi`: Special event called 'Rösi'
  - `droesi`: Special event called '2xRösi'
  - `versenkt`: Special event called 'Versenkt'
  - `gematcht`: Special event called 'Match'
  - `huebimatch`: Special event called 'Huebi-Match' or shortened 'H.Match' 
  - `chimiris`: Special event called 'Dähler-Ris'

### 5. Statistics and Rankings

#### 5.1 Main Rankings (Time-Based)
All main rankings share the same column structure but calculate statistics over different time periods:

##### Common Columns for All Main Rankings:
- **Rang**: Player's ranking position (1 = best)
- **Jasser**: Player's name (clickable link to player-specific statistics)
- **Spiele**: Total number of games played (`sum(spiele)`)
- **Differenz**: Total score difference (`sum(differenz)`) - lower is better
- **Schnitt**: Average score per game (`sum(differenz)/sum(spiele)`) - primary ranking metric
- **Max**: Highest single game score (`max(max)`)
- **Rösi**: Total single penalty events (`sum(roesi)`)
- **2xRösi**: Total double penalty events (`sum(droesi)`)
- **Versenkt**: Total "sunk" games (`sum(versenkt)`)
- **Match**: Total matched games (`sum(gematcht)`)
- **H.Match**: Total "Huebi-Match" events (`sum(huebimatch)`)
- **Dähler-Ris**: Total special rounds (`sum(chimiris)`)

##### Sorting Behavior:
- Default sort: Ascending by Differenz (lowest score wins)
- All columns are sortable by clicking headers
- Multiple clicks reverse sort order
- Default sort orders by column:
  - Ascending: Jasser (alphabetical), Differenz, Schnitt
  - Descending: All event counts (Spiele, Rösi, etc.)

##### Time-Based Ranking Types:
- **Yearly Rankings** (`/ranking/year`): Statistics for a specific year (default: current year)
- **Monthly Rankings** (`/ranking/month`): Statistics for a specific month
- **Eternal Rankings** (`/ranking/ewig`): All-time statistics from 1980-01-01 to today
- **Last 12 Months** (`/ranking/last_12_months`): Rolling 12-month window from specified date
- **Last 3 Months** (`/ranking/last_3_months`): Rolling 3-month window from specified date
- **Daily Rankings** (`/ranking/day`): Statistics for a specific day, includes rank change analysis

#### 5.2 Specialized Statistics

##### Versenker und Rösis (`/ranking/versenker_und_roesis`)
Focuses on penalty events and rates for current year:
- **Columns**:
  - **Spiele**: Total games played
  - **Versenkt**: Total "sunk" games
  - **Versenker p.Spiel**: Sunk rate (`versenkt/spiele`) - higher indicates more sinking
  - **Rösi**: Total single penalty events
  - **Rösi p.Spiel**: Single penalty rate (`roesi/spiele`)
  - **2xRösi**: Total double penalty events
  - **2xRösi p.Spiel**: Double penalty rate (`droesi/spiele`)
  - **Rösi-Quote**: Ratio of double to single penalties (`droesi/roesi`) - higher indicates more severe penalties
- **Default Sort**: By `versenkt_pro_spiel` (descending)

##### Berseker Statistics (`/ranking/berseker`)
Analyzes how a player's performance affects their opponents for current year:
- **Columns**:
  - **Spiele**: Total games played
  - **Eigener Schnitt**: Player's own average score (`eigene_differenz/spiele`)
  - **Gegner Schnitt**: Opponents' average score when playing against this player (`gegner_differenz/spiele/3`)
  - **Schaedling**: Schaedling index (`gegner_schnitt/eigener_schnitt`) - measures relative impact
- **Calculation Logic**:
  - For each round, tracks player's score and total table score
  - `gegner_differenz` = total table score - player's score
  - `gegner_schnitt` = average opponent performance across all games
  - Higher Schaedling index means player makes opponents perform worse relative to their own performance
- **Default Sort**: By `schaedling_index` (descending)

##### Angstgegner (Nemesis) Analysis (`/ranking/angstgegner/:id`)
Player vs. player performance analysis for a specific player over the last year:
- **Purpose**: Shows how other players perform when playing against the specified player
- **Columns**:
  - **Spiele**: Games played against the target player
  - **Eigener Schnitt**: How well each player performs against the target (`eigene_differenz/spiele`)
  - **Gegner Schnitt**: How well the target player performs against each opponent
  - **Schaedling**: Comparative index (`eigener_schnitt/gegner_schnitt`)
- **Interpretation**: 
  - Higher "Eigener Schnitt" means the player performs worse against the target
  - Higher "Schaedling" means the player is more negatively affected by the target player
- **Default Sort**: By `schaedling_index` (descending)

##### Worst Games Analysis (`/ranking/schlimmstespiele`)
Identifies rounds with particularly poor performance:
- **Worst Average Rounds**: Rounds where the average player performance was poorest
  - Filters: Only rounds with >15 total games
  - Metric: `sum(differenz)/sum(spiele)` per round
  - Shows top 20 worst-performing rounds
- **Worst Leader Performance**: Rounds where even the best player performed poorly
  - Metric: `min(differenz)/min(spiele)` per round (best player's performance)
  - Shows rounds where the winner still had a poor score
- **Best Average Rounds**: Rounds with exceptional overall performance
  - Same filter as worst average but sorted ascending
  - Shows top 20 best-performing rounds

#### 5.3 Advanced Statistics and Calculations

##### Rate Calculations (Per-Game Metrics):
- **versenkt_pro_spiel**: Sinking rate = `versenkt / spiele`
- **roesi_pro_spiel**: Single penalty rate = `roesi / spiele`
- **droesi_pro_spiel**: Double penalty rate = `droesi / spiele`
- **roesi_quote**: Penalty severity ratio = `droesi / roesi`

##### Ranking Mechanics:
- **Rank Assignment**: Sequential ranking (1, 2, 3, ...) based on sort order
- **Tied Scores**: Players with identical values receive consecutive ranks
- **Disqualified Players**: Excluded from all rankings (`disqualifiziert = false`)
- **Minimum Games**: Some statistics require minimum game thresholds

##### Aggregate Statistics:
- **Totals Row**: Sum of all numeric columns across all players
- **Averages Row**: Mean values calculated as `total / number_of_players`
- **Special Handling**: Max values use maximum across all players, not sum

##### Range Shift Analysis (Daily Rankings):
- **Purpose**: Shows how rankings changed after a specific day's games
- **Calculation**: Compares year-to-date rankings before and after the selected day
- **Metrics**:
  - Previous rank vs. current rank
  - Rank change (positive = improvement, negative = decline)
  - "Grüner Tisch" indicator: Shows if rank changed without playing
- **Labels**: 
  - "(Feigling)" for players who improved rank without playing
  - "(Ätsch)" for players who declined rank without playing

### 6. Data Visualization

#### 6.1 Graph Types and Functionality

##### Yearly Progression Charts (`/graph/year`)
- **Purpose**: Shows all active players' performance progression throughout a specific year
- **Data**: Daily cumulative averages (Schnitt) from beginning of year to selected date
- **Players**: All players who played at least one game during the year
- **Calculation**: Running average = `cumulative_differenz / cumulative_spiele`
- **Interaction**: Multiple player lines on the same chart for comparison
- **Navigation**: Date selector to view different years

##### Individual Player Running Average (`/graph/running/:id`)
- **Purpose**: Shows a specific player's performance over a rolling 365-day window
- **Window**: 365-day rolling average that updates daily
- **Calculation**: For each day, includes games from that day and previous 364 days
- **Timeline**: From player's first game to present day
- **Smoothing**: Provides a smoothed view of long-term performance trends
- **Navigation**: Player-specific, accessed via player name links

##### Individual Player Eternal Progression (`/graph/ewig/:id`)
- **Purpose**: Shows a player's complete performance history from first game to present
- **Timeline**: From player's first recorded game to today
- **Calculation**: Cumulative running average across entire playing career
- **Data Points**: Daily updates showing progressive performance development
- **Long-term View**: Ideal for seeing overall improvement or decline patterns

##### Overall System Average (`/graph/overall`)
- **Purpose**: Shows the collective performance of all players over time
- **Calculation**: Daily average of all games played system-wide
- **Rolling Window**: 365-day rolling average of entire system
- **Metric**: `sum(all_differenz) / sum(all_spiele)` across all players
- **Interpretation**: Shows whether the group as a whole is improving or declining

#### 6.2 Technical Implementation
- **Technology**: Plotly.js for interactive, responsive charts
- **Data Format**: Time series data with date/value pairs
- **Interactivity**: 
  - Zoom and pan functionality
  - Hover tooltips showing exact values
  - Legend toggle to show/hide specific players
- **Responsive Design**: Charts adapt to mobile and desktop screen sizes
- **Performance**: Efficient data loading and rendering for large datasets

#### 6.3 Chart Features
- **Time Series Display**: Line charts showing performance progression over time
- **Multiple Players**: Yearly charts display all relevant players simultaneously
- **Date Range Selection**: Navigate between different time periods
- **Visual Indicators**: Clear axis labels and value formatting
- **Color Coding**: Consistent color schemes for player identification

### 7. Navigation and UI Features
- **Responsive Design**: Mobile-friendly Bootstrap-based layout
- **Date Navigation**: Easy navigation between different time periods
- **Player Links**: Direct access to player-specific statistics
- **Ranking Tables**: Sortable tables with multiple column options
- **Range Shift Display**: Shows ranking changes after new rounds

## Technical Specifications

### Data Model
```
User (Authentication)
├── username, hashed_password, salt, privilege

Jasser (Player)
├── name, email, disqualifiziert, active
├── has_many :results
└── has_many :rounds (through results)

Round (Game Session)
├── day, creator, comment
├── has_many :results
├── has_many :jassers (through results)
└── validates uniqueness of jassers per round

Result (Individual Performance)
├── round_id, jasser_id
├── spiele, differenz, max
├── roesi, droesi, versenkt, gematcht, huebimatch, chimiris
├── belongs_to :round
└── belongs_to :jasser
```

### Business Rules
1. **Round Validation**: Each round must have exactly 4 unique players
2. **Player Uniqueness**: No player can appear twice in the same round
3. **Required Fields**: Spiele and differenz are mandatory for all results
4. **Disqualification**: Disqualified players are excluded from rankings
5. **Active Status**: Only active players appear in new round forms
6. **Authentication**: Only authenticated users can create/modify data

### Statistics Calculations

#### Core Metrics
- **Schnitt (Average)**: Primary performance metric = `differenz / spiele`
  - Lower values indicate better performance
  - Calculated as floating-point for precision
  - Used as default sort criterion for most rankings

#### Rate Calculations
- **versenkt_pro_spiel**: Sinking frequency = `versenkt / spiele`
- **roesi_pro_spiel**: Single penalty frequency = `roesi / spiele`  
- **droesi_pro_spiel**: Double penalty frequency = `droesi / spiele`
- **roesi_quote**: Penalty severity ratio = `droesi / roesi`

#### Advanced Performance Indices

##### Berseker Index (Table Impact Analysis)
- **Purpose**: Measures how a player's presence affects overall table performance
- **Calculation**:
  - `eigener_schnitt` = player's own average (`eigene_differenz / spiele`)
  - `tisch_schnitt` = table average (`tisch_differenz / 4 / spiele`)
  - `gegner_schnitt` = opponents' average (`gegner_differenz / 3 / spiele`)
  - `schaedling_index` = `gegner_schnitt / eigener_schnitt`
- **Interpretation**: Higher values indicate the player makes opponents perform worse relative to their own performance

##### Schaedling Index (Nemesis Analysis)
- **Purpose**: Comparative performance analysis between specific players
- **Calculation**: `eigener_schnitt / gegner_schnitt`
- **Context**: Used in Angstgegner analysis to identify which players struggle against specific opponents
- **Interpretation**: Higher values indicate greater negative impact from the target player

#### Time Series Calculations
- **Rolling Averages**: Moving window calculations (365-day for running averages)
- **Cumulative Statistics**: Progressive totals from start date to current date
- **Daily Aggregation**: Combines multiple rounds from same day for smooth progression
- **Clearing Period**: For rolling averages, removes data outside the window

### User Interface Requirements
- **Mobile Responsive**: All views must work on mobile devices
- **Sortable Tables**: All ranking tables support column sorting
- **Date Selection**: Easy navigation between different time periods
- **Visual Feedback**: Clear indication of rankings and changes
- **Interactive Charts**: Visualizations of time series with line charts

## Security Considerations
- **Authentication Required**: Data modification requires user authentication
- **Password Security**: Uses salted SHA1 hashing (legacy implementation)
- **Input Validation**: All user inputs are validated and sanitized
- **SQL Injection Prevention**: Uses Rails parameter binding
- **XSS Protection**: Rails' built-in protections enabled

## Performance Considerations
- **Database Indexing**: Proper indexing on frequently queried columns
- **Pagination**: Large result sets are paginated using will_paginate
- **Caching**: Asset pipeline caching for static resources
- **Query Optimization**: Efficient SQL queries with proper joins and scopes

## Integration Points
- **Heroku Deployment**: Configured for Heroku hosting
- **Asset Pipeline**: Rails asset pipeline for CSS/JS management
- **Database**: SQLite for development, PostgreSQL for production
- **Email Integration**: Basic email field capture for players