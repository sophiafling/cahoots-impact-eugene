## Data Cleaning
This folder contains scripts for cleaning the CAD and MCSLC data and preparing a unified dataset for analysis.

## Purpose
The goal of this stage is to:
- Clean and standardize raw CAD and MCSLC data  
- Align variables across datasets (call time, call type, response variables)
- Standardize call types into shared categories to allow comparison between CAD and MCSLC data  
- Combine datasets into a single file for analysis  
- Create time variables and a pre/post CAHOOTS shutdown indicator  
- Account for differences in how CAHOOTS is recorded before and after 2021  

## Folder Contents
- 'data_prep.ipynb': Loads raw CAD and MCSLC data, cleans and standardizes variables, and outputs a combined dataset ready for analysis  

## Input Files
Located in the project folder:
- 'MCSLC.xlsx'  
- 'Eugene_CAD_data_noloc/':
  - 'EugeneCAD2015noloc.csv'
  - 'EugeneCAD2016noloc.csv'
  - ...
  - 'EugeneCAD2025noloc.csv'

## Output Files

- 'combined_calls_data.csv': Cleaned and merged dataset used for analysis  

This dataset includes:
- 'call_time' (datetime)  
- 'call_type'  
- 'priority'  
- 'response_prime' (primary responder: CAHOOTS, EPD, MCSLC)  
- 'response_agency' (agency involved: CAHOOTS, EPD, MCSLC)  
- 'year', 'month'  
- 'period' (pre/post CAHOOTS shutdown)  

## Key Processing Steps

- CAD data is combined across years and standardized  
- Timestamps are converted to datetime format and used to create year and month variables  
- MCSLC data is filtered to Eugene and aligned to match CAD variables
- Call types are recoded into shared categories to ensure consistency across CAD and MCSLC data  
- Both datasets are merged into a single combined dataset

## Standardizing Call Types

The CAD and MCSLC datasets use different naming conventions for call types (nature in CAD and “reason for dispatch” in MCSLC), which makes direct comparison difficult.
To address this: 
- The most frequent call types in each dataset were examined using frequency counts
- Differences in terminology between CAD and MCSLC were identified
- A set of broader, shared call categories was created (e.g., Mental Health, Welfare Check, Traffic, Property/Crime, etc.)
- A custom recoding function was applied to both datasets to map original call types into these shared categories
This step ensures that call types are comparable across datasets


### Handling CAHOOTS Identification

The CAD dataset records CAHOOTS differently across time:

- **Before 2021**: CAHOOTS is identified using the 'primeunit' field (e.g., '_CAHOT'), representing the primary responding unit  
- **2021 and after**: CAHOOTS is identified both by 'primeunit' and using the 'agency' field ('CAHE'), representing agency involvement  

To account for this, two response variables are created:

- 'response_prime': identifies the **primary responder** (based on 'primeunit')  
- 'response_agency': identifies **agency involvement** (based on 'agency')  

This allows for:
- consistent comparison of who handled calls ('response_prime')  
- analysis of broader system involvement ('response_agency')  

## How to Run
Run the notebook:

1. Open 'data_prep.ipynb'  
2. Run all cells from top to bottom  

This will:
- load and combine CAD data across years  
- clean and standardize variables  
- clean MCSLC data  
- merge both datasets  
- generate the final cleaned dataset  

## Data Availability

Due to file size constraints, the raw CAD data and MCSLC dataset are not included in this repository.

To reproduce the cleaned dataset:
1. Place all CAD files in a folder named 'Eugene_CAD_data_noloc/'
2. Place the MCSLC dataset (`MCSLC.xlsx`) in the main project directory
3. Run 'data_prep.ipynb'

This will generate the cleaned dataset (`combined_calls_data.csv`) used for analysis.

## Dependencies
This project uses the following Python packages:
- pandas  
- numpy  

To install dependencies:
pip install pandas 
pip install numpy

## Notes
- The CAD dataset uses the code **"CAHE"** to represent CAHOOTS in the agency field starting from 2021 
- The 'primeunit' field is used to identify CAHOOTS as the primary responder ('_CAHOT')  
- Two response variables are used to avoid inconsistencies across years
- Because CAD and MCSLC use different terminology, call types are grouped into broader categories to enable meaningful comparison across datasets  
- Rows with missing timestamps are retained, but may be excluded in later analysis steps depending on context  
