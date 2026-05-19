library(tidyverse)
library(lubridate)

calls <- read_csv("combined_calls_data.csv")

selected_types <- c(
  "Mental Health",
  "Welfare Check",
  "Public/Social Assistance",
  "Conflict/Dispute"
)

heatmap_data <- calls %>%
  mutate(
    call_time = ymd_hms(call_time),
    month_date = floor_date(call_time, "month")
  ) %>%
  filter(
    !is.na(call_time),
    call_type %in% selected_types,
    year(call_time) >= 2019
  ) %>%
  group_by(month_date, call_type) %>%
  summarize(
    calls = n(),
    .groups = "drop"
  ) %>%
  mutate(
    call_type = factor(
      call_type,
      levels = c(
        "Mental Health",
        "Welfare Check",
        "Public/Social Assistance",
        "Conflict/Dispute"
      )
    )
  )

shutdown_date <- as.Date("2025-04-05")

heatmap_plot <- ggplot(
  heatmap_data,
  aes(x = month_date, y = call_type, fill = calls)
) +
  geom_tile() +
  geom_vline(
    xintercept = shutdown_date,
    linetype = "dashed",
    linewidth = 1
  ) +
  scale_fill_gradient(
    low = "white",
    high = "darkred"
  ) +
  labs(
    title = "Monthly Call Volume by Call Type",
    subtitle = "CAHOOTS shutdown marked by dashed line",
    x = "Month",
    y = "Call Type",
    fill = "Call Count"
  ) +
  theme_minimal()

heatmap_plot

ggsave(
  "call_type_heatmap.png",
  plot = heatmap_plot,
  width = 11,
  height = 5
)
