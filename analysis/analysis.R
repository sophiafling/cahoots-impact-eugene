library(tidyverse)
library(lubridate)

calls <- read_csv("combined_springfield_data.csv")

calls <- calls %>%
  mutate(
    call_time = ymd_hms(call_time),
    date = as.Date(call_time),
    post = if_else(period == "post", 1, 0),
    treated = if_else(city == "Eugene", 1, 0)
  ) %>%
  filter(!is.na(call_time))

weekly_calls <- calls %>%
  filter(
    call_time >= as.Date("2020-01-06"),
    call_time <= as.Date("2025-12-28")
  ) %>%
  mutate(
    week_date = floor_date(call_time, "week")
  ) %>%
  group_by(week_date, city, post, treated) %>%
  summarize(
    calls = n(),
    .groups = "drop"
  ) %>%
  filter(
    week_date > min(week_date),
    week_date < max(week_date)
  )

shutdown_date <- as.Date("2025-04-08")

p <- ggplot(weekly_calls,
            aes(x = week_date,
                y = calls,
                color = city)) +
  geom_line() +
  geom_vline(xintercept = shutdown_date,
             linetype = "dashed") +
  labs(
    title = "Difference-in-Differences Visualization",
    x = "Date",
    y = "Weekly Call Count"
  ) +
  theme_minimal()

print(p)

ggsave(
  filename = "did_total.png",
  plot = p,
  width = 10,
  height = 6
)
did_model <- lm(calls ~ post * treated, data = weekly_calls)

summary(did_model)

pre_calls <- weekly_calls %>%
  filter(post == 0) %>%
  mutate(time = row_number())

parallel_model <- lm(calls ~ time * treated, data = pre_calls)

summary(parallel_model)


# By call types

selected_types <- c(
  "Welfare Check",
  "Mental Health",
  "Dispute",
  "Public Assistance"
)

for(type in selected_types) {
  
  type_calls <- calls %>%
    filter(call_type == type)
  
  weekly_type_calls <- type_calls %>%
    filter(
      call_time >= as.Date("2020-01-06"),
      call_time <= as.Date("2025-12-28")
    ) %>%
    mutate(
      week_date = floor_date(call_time, "week")
    ) %>%
    group_by(week_date, city, post, treated) %>%
    summarize(
      calls = n(),
      .groups = "drop"
    ) %>%
    filter(
      week_date > min(week_date),
      week_date < max(week_date)
    )
  
  # remove weird visual outliers only for graphing
  weekly_type_calls_graph <- weekly_type_calls %>%
    mutate(
      calls = case_when(
        
        # Welfare Check: Eugene weird dip
        type == "Welfare Check" & city == "Eugene" & 
          week_date >= as.Date("2023-01-01") & 
          week_date <= as.Date("2023-03-01") ~ NA_real_,
        
        # Welfare Check: Springfield weird spike
        type == "Welfare Check" & city == "Springfield" & 
          week_date >= as.Date("2024-01-01") & 
          week_date <= as.Date("2024-03-01") ~ NA_real_,
        
        # Public Assistance: Eugene weird dip
        type == "Public Assistance" & city == "Eugene" &
          week_date >= as.Date("2023-01-01") &
          week_date <= as.Date("2023-03-01") ~ NA_real_,
        
        TRUE ~ calls
      )
    )
  
  # DiD model still uses original data
  did_model <- lm(calls ~ post * treated,
                  data = weekly_type_calls)
  
  cat("CALL TYPE:", type, "\n")
  print(summary(did_model))
  
  # graph uses cleaned visual version
  p <- ggplot(
    weekly_type_calls_graph,
    aes(
      x = week_date,
      y = calls,
      color = city
    )
  ) +
    geom_line(na.rm = TRUE) +
    geom_vline(
      xintercept = shutdown_date,
      linetype = "dashed"
    ) +
    labs(
      title = paste("DiD:", type),
      x = "Date",
      y = "Weekly Call Count"
    ) +
    theme_minimal()
  
  print(p)
  
  ggsave(
    filename = paste0("did_", gsub("/", "_", type), ".png"),
    plot = p,
    width = 10,
    height = 6
  )
}

