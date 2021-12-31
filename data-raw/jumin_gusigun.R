# 0. 패키지 -------------

library(tidyverse)
library(httr)
library(rvest)
library(testthat)

# 1. 크롤링 함수 -------------

get_demographic_gusigun_data <- function(sido = "1100000000", demo_year = "2020") {

  cat("\n ------------------------- \n", sido, " : ", demo_year, "\n ------------------------- \n")

  url <- glue::glue("https://jumin.mois.go.kr/ageStatMonth.do?",
                    "tableChart=T&sltOrgType=2",
                    "&sltOrgLvl1={sido}",
                    "&sltOrgLvl2=A",
                    "&sltUndefType=",
                    "&nowYear=2021&searchYearMonth=year",
                    "&searchYearStart={demo_year}",
                    "&searchMonthStart=12",
                    "&searchYearEnd={demo_year}",
                    "&searchMonthEnd=12",
                    "&gender=gender",
                    "&sltOrderType=1",
                    "&sltOrderValue=ASC",
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
}

# get_demographic_sido_data("1100000000", "2019")

# 2. 크롤링 -------------

gusigun_demo_year_raw <- demographics::gusigun_code %>%
  filter(is.na(구시군명)) %>%
  mutate(year = paste0(seq(2012, 2020, by =1), collapse = ",")) %>%
  separate(year, into = paste0("x", c(2012:2020)), sep = ",") %>%
  select(-구분, -구시군명) %>%
  pivot_longer(cols = starts_with("x")) %>%
  mutate(data = map2(시도코드, value, get_demographic_gusigun_data))

# 3. 데이터 정제 -------------

gusigun_demo_year_tbl <- gusigun_demo_year_raw %>%
  select(-name) %>%
  unnest(data) %>%
  mutate(check = case_when(시도코드 == 행정기관코드 ~ TRUE,
                           TRUE ~ FALSE)) %>%
  filter(!check) %>%
  rename(연도 = value) %>%
  select(-check) %>%
  filter(! 행정기관 %in% c("수원시", "성남시", "안양시", "안산시", "고양시", "용인시"),
         ! 행정기관 %in% c("청주시"),
         ! 행정기관 %in% c("천안시"),
         ! 행정기관 %in% c("전주시"),
         ! 행정기관 %in% c("포항시"),
         ! 행정기관 %in% c("창원시"))

# 4. 데이터 저장 -------------

usethis::use_data(gusigun_demo_year_tbl, overwrite = TRUE)

# 5. 정합성 검증 -------------

test_that("행안부 인구통계 - 성별, 연령별, 구시군별", {

  gusigun_demo_summary_tbl <- gusigun_demo_year_tbl %>%
    pivot_longer(cols = starts_with("x")) %>%
    mutate(value = parse_number(value),
           연도 = as.integer(연도)) %>%
    group_by(시도명, 연도) %>%
    summarise(인구수 = sum(value)) %>%
    ungroup()  %>%
    filter(연도 >= 2016)  %>%
    rename(행정기관 = 시도명)

  sido_answer <- readxl::read_excel("data-raw/data/시도_201612_202012_연령별인구현황_연간.xlsx") %>%
    filter(행정기관 != "전국")

  check_row <- sido_answer %>%
    janitor::clean_names(ascii = FALSE) %>%
    pivot_longer(cols = starts_with("x"), names_to = "연도", values_to = "정답_인구수",
                 values_transform = list(정답_인구수 = parse_number)) %>%
    mutate(연도 = parse_number(연도)) %>%
    left_join(gusigun_demo_summary_tbl) %>%
    mutate(차이 = 정답_인구수 - 인구수) %>%
    filter(차이 != 0) %>%
    nrow()

  expect_that( check_row, equals(0))
})


# 읍면동 마스터 코드 --------------------------------------------------------------

gusigun_demo_year_raw %>%
  select(-name) %>%
  unnest(data) %>%
  mutate(check = case_when(시도코드 == 행정기관코드 ~ TRUE,
                               TRUE ~ FALSE)) %>%
  filter(!check) %>%
  rename(연도 = value) %>%
  select(-check) %>%
  select(시도코드, 시도명, 구시군코드 = 행정기관코드, 구시군명=행정기관) %>%
  write_csv("data-raw/sido_gusigun_code.csv")

