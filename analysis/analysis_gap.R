library(tidyverse)
library(lubridate)

# load data
calls <- read_csv("combined_calls_data.csv")

# clean dates
calls <- calls %>%
  mutate(
    call_time = ymd_hms(call_time),
    week_date = floor_date(call_time, "week"),
    raw_call_type = as.character(raw_call_type)
  )

shutdown_date <- as.Date("2025-04-08")

# one year before and after shutdown
calls_gap <- calls %>%
  filter(
    !is.na(call_time),
    call_time >= shutdown_date - years(1),
    call_time <= shutdown_date + years(1)
  ) %>%
  filter(!(response == "CAHOOTS" & period == "post"))

# create focused gap categories
# main grouped categories
main_gap <- calls_gap %>%
  filter(
    call_type %in% c(
      "Mental Health",
      "Welfare Check",
      "Public Assistance"
    ),
    !is.na(response),
    !is.na(period)
  ) %>%
  mutate(group = call_type)

# suicidal subject category
suicidal_gap <- calls_gap %>%
  filter(
    str_detect(
      raw_call_type,
      regex("suicidal subject|suicidal|suicide", ignore_case = TRUE)
    ),
    !is.na(response),
    !is.na(period)
  ) %>%
  mutate(group = "Suicidal Subject")

# combine
gap_data <- bind_rows(main_gap, suicidal_gap) %>%
  group_by(group, response, period) %>%
  summarize(
    avg_calls = n() / n_distinct(week_date),
    .groups = "drop"
  ) %>%
  mutate(
    avg_calls = ifelse(period == "pre", -avg_calls, avg_calls),
    period = factor(period, levels = c("pre", "post")),
    group = factor(
      group,
      levels = c(
        "Suicidal Subject",
        "Mental Health",
        "Welfare Check",
        "Public Assistance"
      )
    )
  )

# check data
print(gap_data)

# graph
ggplot(
  gap_data,
  aes(
    x = group,
    y = avg_calls,
    fill = response
  )
) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  geom_hline(yintercept = 0, linewidth = 1) +
  scale_y_continuous(labels = abs) +
  scale_fill_manual(
    values = c(
      "CAHOOTS" = "#F8766D",
      "EPD" = "#00BA38",
      "MCSLC" = "#619CFF"
    )
  ) +
  labs(
    title = "Average Weekly Calls Before and After CAHOOTS Shutdown",
    subtitle = "One year before and after shutdown",
    x = "Call Type",
    y = "Average Weekly Calls",
    fill = "Response Type"
  ) +
  theme_minimal() +
  coord_flip()

ggsave(
  "gap_analysis.png",
  width = 10,
  height = 6
)

