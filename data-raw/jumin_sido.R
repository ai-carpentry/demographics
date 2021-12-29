library(tidyverse)
library(httr)
library(rvest)

demographics::gusigun_code

url <- glue::glue("https://jumin.mois.go.kr/ageStatMonth.do?",
                  "tableChart=T&sltOrgType=2",
                  "&sltOrgLvl1=1100000000",
                  "&sltOrgLvl2=A&sltUndefType=",
                  "&nowYear=2021&searchYearMonth=year",
                  "&searchYearStart=2020",
                  "&searchMonthStart=12&searchYearEnd=2020&searchMonthEnd=12",
                  "&gender=gender&sltOrderType=1&sltOrderValue=ASC",
                  "&sltArgTypes=10",
                  "&sltArgTypeA=0&sltArgTypeB=100")


Sys.setlocale("LC_ALL", "C")
raw_data <- GET(url)

data_content <- content(raw_data)

data_raw <- data_content %>%
  html_nodes('#contextTable') %>%
  html_table() %>%
  .[[1]]

Sys.setlocale("LC_ALL", "Korean")

ncol(data_raw)

data_male_raw <- data_raw %>%
  janitor::clean_names(ascii=FALSE) %>%
  select(1:(13+2)) %>%
  pivot_longer(cols = starts_with("x")) %>%
  filter(value != "남") %>%
  pivot_wider(names_from = name, values_from = value)

data_female_raw <- data_raw %>%
  janitor::clean_names(ascii=FALSE) %>%
  select(1:2, 16:ncol(data_raw)) %>%
  pivot_longer(cols = starts_with("x")) %>%
  filter(value != "여") %>%
  pivot_wider(names_from = name, values_from = value)

mois_colnames <- data_male_raw %>%
  slice(1) %>%
  pivot_longer(cols = everything()) %>%
  pull(value)

data_male_tbl <- data_male_raw %>%
  set_names(mois_colnames) %>%
  slice(2:n()) %>%
  janitor::clean_names(ascii = FALSE) %>%
  mutate(성별 = "남") %>%
  relocate(성별, .after = "행정기관") %>%
  select(행정기관코드, 행정기관, 성별, starts_with("x"))

data_female_tbl <- data_female_raw %>%
  set_names(mois_colnames) %>%
  slice(2:n()) %>%
  janitor::clean_names(ascii = FALSE) %>%
  mutate(성별 = "여") %>%
  relocate(성별, .after = "행정기관") %>%
  select(행정기관코드, 행정기관, 성별, starts_with("x"))

data_tbl <- bind_rows(data_male_tbl, data_female_tbl)

data_tbl
