## Data Cleaning
This folder contains scripts for cleaning the CAD and MCSLC data and preparing a unified dataset for analysis.

## Purpose
The goal of this stage is to:
- Clean and standardize raw CAD, MCSLC, and Springfield call data
- Create consistent variables across datasets
- Standardize call types into shared categories
- Identify CAHOOTS responses consistently across years
- Generate datasets for both Eugene-only and Difference-in-Differences analyses
- Create time variables and pre/post shutdown indicators  

## Folder Contents
- 'data_prep.ipynb': Loads, cleans, and combines all datasets and generates the final analysis files  

## Input Files
Located in the project folder:
- 'Eugene_CAD_data_noloc/':
  - 'EugeneCAD2015noloc.csv'
  - 'EugeneCAD2016noloc.csv'
  - ...
  - 'EugeneCAD2025noloc.csv'
- '2015-2025 SPD Calls for Service.xlsx'
- 'MCSLC.xlsx'  

## Output Files

- 'combined_calls_data.csv': Combined Eugene CAD and MCSLC dataset used for descriptive analyses of changes following the CAHOOTS shutdown.  

This dataset includes:
- 'call_time' (datetime)  
- 'call_type'
- 'raw_call_type'  
- 'response' (primary responder: CAHOOTS, EPD, MCSLC)   
- 'year'
- 'month'  
- 'period' (pre/post CAHOOTS shutdown)  

- 'combined_springfield_data.csv': Combined Eugene and Springfield dataset used for Difference-in-Differences analyses.

This dataset includes:
- 'call_time'
- 'call_type'
- 'raw_call_type'  
- 'response'
- 'city' 
- 'year'
- 'month'  
- 'period'

## Key Processing Steps
Eugene CAD Data
- CAD files are combined across all years (2015–2025)
- Timestamps are converted to datetime format
- Raw call descriptions (nature) are retained as raw_call_type
- Calls are grouped into broader call type categories
- CAHOOTS responses are identified using primeunit
- Non-CAHOOTS calls are classified as EPD responses
MCSLC Data
- Records are filtered to Eugene only
- Dispatch timestamps are standardized
- Reason for Dispatch values are retained as raw_call_type
- Call types are recoded into the same categories used for CAD data
- All responses are coded as MCSLC
Springfield Data
- Calls from all years are combined
- Call descriptions are retained as raw_call_type
- Call types are recoded using the same grouping system
- Responses are coded as SPD
- A city identifier is added for Difference-in-Differences analyses

## Standardizing Call Types

The CAD, MCSLC, and Springfield datasets use different naming conventions for call descriptions. To allow comparison across agencies, raw call descriptions are grouped into shared categories.

The final categories are:
- Mental Health
- Welfare Check
- Dispute
- Public Assistance
- Other

Call type groupings were developed by examining the most common raw call descriptions in each dataset and creating a shared classification system.


### Handling CAHOOTS Identification

CAHOOTS is not recorded consistently across years in the CAD data.

To maintain consistency, CAHOOTS responses are identified using the primeunit field across all years.

Examples of CAHOOTS identifiers include:
- 1J77
- 3J78
- 3J79
- 4J79
- CAHOT
- CAHOOT

Calls matching these identifiers are classified as CAHOOTS; all remaining CAD calls are classified as EPD.

## How to Run
1. Open 'data_prep.ipynb'  
2. Run all cells from top to bottom  

This will:
- Load Eugene CAD data
- Clean and standardize CAD variables
- Clean and standardize MCSLC data
- Clean and standardize Springfield data
- Generate combined_calls_data.csv
- Generate combined_springfield_data.csv

## Data Availability

To reproduce the cleaned dataset:
1. Place all CAD files in Eugene_CAD_data_noloc/
2. Place MCSLC.xlsx in the project directory
3. Place 2015-2025 SPD Calls for Service.xlsx in the project directory
4. Run data_prep.ipynb

## Dependencies
This project uses the following Python packages:
- pandas  
- numpy  

To install dependencies:
pip install pandas 
pip install numpy

## Notes
- Raw call descriptions are retained as raw_call_type
- Grouped call categories are stored in call_type
- CAHOOTS is identified using primeunit across all years for consistency
- Springfield data is used as a comparison city in Difference-in-Differences analyses
- Rows with invalid timestamps are retained during cleaning but may be excluded in later analyses
