library(tidyverse)
library(lubridate)

calls <- read_csv("combined_calls_data.csv")

calls <- calls %>%
  mutate(
    call_time = ymd_hms(call_time),
    week_date = floor_date(call_time, "week")
  )

weekly_response <- calls %>%
  group_by(week_date, response) %>%
  summarize(
    calls = n(),
    .groups = "drop"
  )

shutdown_date <- as.Date("2025-04-05")

ggplot(
  weekly_response,
  aes(x = week_date,
      y = calls,
      color = response)
) +
  geom_line(linewidth = 1) +
  geom_vline(
    xintercept = shutdown_date,
    linetype = "dashed"
  ) +
  labs(
    title = "Changes in Response Types Over Time",
    subtitle = "CAHOOTS shutdown marked by dashed line",
    x = "Date",
    y = "Weekly Call Count",
    color = "Response Type"
  ) +
  theme_minimal()

ggsave(
  "response_types_over_time.png",
  width = 10,
  height = 6
)

# fill gap?

gap_data <- calls %>%
  group_by(response, period) %>%
  summarize(
    avg_calls = n() / n_distinct(floor_date(call_time, "week")),
    .groups = "drop"
  )

gap_change <- gap_data %>%
  pivot_wider(
    names_from = period,
    values_from = avg_calls
  ) %>%
  mutate(
    change = post - pre
  )

ggplot(
  gap_change,
  aes(x = response,
      y = change,
      fill = response)
) +
  geom_col() +
  geom_hline(yintercept = 0) +
  labs(
    title = "Change in Weekly Calls After CAHOOTS Shutdown",
    x = "Response Type",
    y = "Average Weekly Change"
  ) +
  theme_minimal()

ggsave(
  "mcslc_fill_gap.png",
  width = 8,
  height = 6
)
