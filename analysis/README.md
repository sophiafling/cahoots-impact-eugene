## Analysis
This folder contains the script used to analyze the cleaned CAD and MCSLC data and answer the research questions about changes in call volume and distribution after the CAHOOTS shutdown.

## Purpose
The goal of this stage is to:
- Analyze changes in call volumes and call type distributions following the CAHOOTS shutdown
- Compare trends in Eugene before and after the shutdown
- Compare Eugene and Springfield using Difference-in-Differences analysis
- Evaluate whether MCSLC filled the gap left by CAHOOTS
- Visualize changes in response patterns across call types

## Files
analysis.R: Main analysis script. Loads the cleaned Eugene and MCSLC dataset and generates descriptive statistics and visualizations related to changes in call volume, response type, and call type distributions.
analysis_gap.R: Difference-in-Differences analysis script. Uses Eugene and Springfield call data to estimate how call volumes changed in Eugene following the CAHOOTS shutdown relative to a comparison city.

## Input Data
- combined_calls_data.csv
  - Created in the data cleaning step (data_prep.ipynb)
  - Contains cleaned and standardized variables, including:
    - call_time
    - raw_call_type
    - call_type
    - response
    - year
    - month
    - period
- combined_springfield_data.csv
  - Created in the data cleaning step (data_prep.ipynb)
  - Contains cleaned and standardized Eugene and Springfield data, including:
    - call_time
    - raw_call_type
    - call_type
    - response
    - city
    - year
    - month
    - period

## Methods
The analyses are completed in R.

Gap Analysis
Key steps include:
- Loading and inspecting the cleaned dataset
- Converting call_time to a datetime format
- Creating weekly and monthly time variables
- Calculating call volumes over time
- Comparing call volumes and proportions by response type
- Examining changes in call type distributions
- Comparing CAHOOTS and MCSLC call patterns before and after the shutdown
- Evaluating whether MCSLC expanded services in areas previously handled by CAHOOTS
- Creating visualizations to display trends and potential service gaps

Difference-in-Differences Analysis
Key steps include:
- Combining Eugene and Springfield call data
- Creating treatment and post-shutdown indicators
- Aggregating calls by week and call type
- Comparing trends between Eugene and Springfield
- Estimating Difference-in-Differences models using: calls ~ post * treated
- Testing for changes in:
  - Mental Health calls
  - Welfare Check calls
  - Public/Social Assistance calls
  - Conflict/Dispute calls

## Output
The analysis scripts primarily produce visualizations and statistical results displayed in RStudio, including:
- Time-series plots
- Response-type trend plots
- Call-type trend plots
- Gap analysis visualizations
- Heatmaps of call volume by call type
- Difference-in-Differences figures
- Difference-in-Differences model results
- 
## Libraries Used 
- tidyverse (dplyr, ggplot2, readr, tidyr)
- lubridate

## How to Run
1. Make sure the following files are in the working directory:
  - combined_calls_data.csv
  - combined_springfield_data.csv
2. Open the desired analysis script in RStudio:
  - analysis.R
  - springfield_analysis.R
3. Install required packages if needed:
  - install.packages("tidyverse")
  - install.packages("lubridate")
4. Run the script from top to bottom.

## Notes
- The CAHOOTS shutdown date is defined as April 8, 2025.
- Rows with missing or invalid timestamps may be excluded from analyses requiring time variables.
- Springfield is used as a comparison city for Difference-in-Differences analyses.
- Gap analyses are intended to evaluate whether MCSLC absorbed calls previously handled by CAHOOTS.
- Difference-in-Differences analyses are used to estimate changes associated with the shutdown while accounting for broader trends occurring in both cities.
