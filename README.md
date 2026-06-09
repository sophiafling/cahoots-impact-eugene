# CAHOOTS Impact in Eugene

## Overview

This project examines how emergency service call volumes and call distributions changed following the suspension of CAHOOTS services in Eugene, Oregon. The analysis focuses on overall call volume, changes across call types, and the extent to which Mobile Crisis Services of Lane County (MCSLC) filled the gap left by CAHOOTS.

## Repository Structure

### data_cleaning

Contains the scripts used to clean, standardize, and combine raw data sources into analysis-ready datasets.

**Main File**

* `data_prep.ipynb`

**Purpose**

* Clean and standardize Eugene CAD, Springfield CAD, and MCSLC data
* Recode call types into broader categories
* Identify response agencies
* Create final datasets used for analysis

**Outputs**

* `combined_calls_data.csv`
* `combined_springfield_data.csv`

### analysis

Contains the scripts used to analyze the cleaned data and answer the project's research questions.

**Main File**

* `analysis.R`
* `analysis_gap.R`

**Purpose**

* Analyze changes in call volume before and after the CAHOOTS shutdown
* Compare call patterns between Eugene and Springfield
* Examine changes across call types
* Evaluate whether MCSLC filled the gap left by CAHOOTS
* Generate tables and visualizations

## Data Sources

* Eugene Computer-Aided Dispatch (CAD) data
* Springfield Police Department Calls for Service data
* Mobile Crisis Services of Lane County (MCSLC) data

## Research Questions

1. How did call volumes and proportions change when CAHOOTS stopped services in Eugene?
2. To what degree did MCSLC fill the gap left by CAHOOTS?

## Methods

* Data cleaning and standardization
* Call type recategorization
* Descriptive statistics
* Difference-in-Differences (DiD) analysis
* Data visualization

## Software

### Python

* pandas
* numpy
* Jupyter Notebook

### R

* tidyverse
* lubridate
* ggplot2
