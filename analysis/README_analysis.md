## Analysis
This folder contains the script used to analyze the cleaned CAD and MCSLC data and answer the research questions about changes in call volume and distribution after the CAHOOTS shutdown.

## Purpose
The goal of this stage is to:
- Analyze changes in total call volume before and after the CAHOOTS shutdown
- Compare how calls are distributed across response types (CAHOOTS, EPD, MCSLC)
- Examine differences by call type and priority
- Evaluate whether MCSLC filled the gap left by CAHOOTS
- Visualize trends and patterns in the data

## Files
analysis.R: Main analysis script. Loads the cleaned dataset, performs all calculations, and generates summary tables and visualizations.

## Input Data
- combined_calls_data.csv
  - Created in the data cleaning step (data_prep.ipynb)
  - Contains cleaned and standardized variables, including:
    - call_time
    - call_type
    - priority
    - response_agency
    - response_prime
    - period (pre/post CAHOOTS shutdown)

## Methods
The analysis is completed in analysis.R using R.

Key steps include:
- Loading and inspecting the dataset
- Converting call_time to a datetime format and removing invalid values
- Creating time-based variables (date, month, year)
- Calculating total call volumes over time
- Comparing call volumes and proportions by response type
- Breaking down results by call type and priority
- Comparing pre vs. post CAHOOTS shutdown patterns
- Evaluating changes in call volume to assess whether MCSLC filled the gap
- Creating visualizations (line plots and bar charts) to display results

## Output
analysis.R primarily produces visualizations displayed in RStudio, including:
- Time series plots
- Bar charts comparing pre/post call volumes
- Proportion plots showing distribution across response types

## Libraries Used 
- tidyverse (dplyr, ggplot2, readr, tidyr)
- lubridate

## How to Run
- Make sure combined_calls_data.csv is in the working directory
- Open analysis.R in RStudio
- Install required packages if needed:
  - install.packages("tidyverse")
  - install.packages("lubridate")
- Run the script from top to bottom

## Notes
- Rows with missing or invalid call_time values are removed before analysis because they cannot be assigned to a time period
- Both response_agency and response_prime are included in the dataset; this analysis primarily uses response_agency for comparison
