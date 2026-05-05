# load libraries
library(tidyverse)
library(lubridate)

# load data
calls <- read_csv("combined_calls_data.csv")

# check variables
glimpse(calls)
names(calls)
summary(calls)

# Make sure call_time is read as a datetime
calls <- calls %>%
  mutate(
    call_time = ymd_hms(call_time),
    date = as.Date(call_time),
    month_date = floor_date(call_time, "month"),
    year = year(call_time),
    month = month(call_time)
  )
calls <- calls %>%
  filter(!is.na(call_time))

# total call volume over time
monthly_volume <- calls %>%
  count(month_date)

ggplot(monthly_volume, aes(x = month_date, y = n)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Total Monthly Call Volume",
    x = "Month",
    y = "Number of Calls"
  ) +
  theme_minimal()

# call volume by response agency over time
monthly_by_agency <- calls %>%
  count(month_date, response_agency)

ggplot(monthly_by_agency, aes(x = month_date, y = n, color = response_agency)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Monthly Call Volume by Response Agency",
    x = "Month",
    y = "Number of Calls",
    color = "Response Agency"
  ) +
  theme_minimal()

# pre/post call volume by response agency

pre_post_agency <- calls %>%
  count(period, response_agency)

pre_post_agency

ggplot(pre_post_agency, aes(x = period, y = n, fill = response_agency)) +
  geom_col(position = "dodge") +
  labs(
    title = "Pre/Post Call Volume by Response Agency",
    x = "Period",
    y = "Number of Calls",
    fill = "Response Agency"
  ) +
  theme_minimal()

# proportions by response agency

agency_proportions <- calls %>%
  count(period, response_agency) %>%
  group_by(period) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

ggplot(agency_proportions, aes(x = period, y = prop, fill = response_agency)) +
  geom_col(position = "fill") +
  labs(
    title = "Proportion of Calls by Response Agency",
    x = "Period",
    y = "Proportion of Calls",
    fill = "Response Agency"
  ) +
  theme_minimal()

# top call types

top_call_types <- calls %>%
  count(call_type, sort = TRUE) %>%
  slice_head(n = 10)

top_type_names <- top_call_types$call_type

call_type_counts <- calls %>%
  filter(call_type %in% top_type_names) %>%
  count(period, call_type, response_agency)

ggplot(call_type_counts, aes(x = call_type, y = n, fill = response_agency)) +
  geom_col(position = "dodge") +
  facet_wrap(~ period) +
  labs(
    title = "Top Call Types by Period and Response Agency",
    x = "Call Type",
    y = "Number of Calls",
    fill = "Response Agency"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# priority breakdown

priority_counts <- calls %>%
  count(period, priority, response_agency)

ggplot(priority_counts, aes(x = priority, y = n, fill = response_agency)) +
  geom_col(position = "dodge") +
  facet_wrap(~ period) +
  labs(
    title = "Call Volume by Priority and Response Agency",
    x = "Priority",
    y = "Number of Calls",
    fill = "Response Agency"
  ) +
  theme_minimal()

# gap filled by MCSLC

gap_comparison <- calls %>%
  count(period, response_agency) %>%
  pivot_wider(
    names_from = period,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(change = post - pre)

ggplot(gap_comparison, aes(x = response_agency, y = change, fill = response_agency)) +
  geom_col() +
  labs(
    title = "Change in Call Volume After CAHOOTS Shutdown",
    x = "Response Agency",
    y = "Change in Number of Calls"
  ) +
  theme_minimal()

