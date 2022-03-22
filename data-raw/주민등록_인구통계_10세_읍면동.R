################################################################# ---
##               주민등록 인구통계 : 10세 단위 읍면동          ##
##                    개발자: 이광춘                           ##
##                최종수정일: 2022-03-22                       ##
################################################################# ---

# 0. 패키지 -------------

library(tidyverse)
library(httr)
library(rvest)
library(testthat)

# 1. 크롤링 함수 -------------

get_demographic_emd_by_ten <- function(sido = "1100000000", gusigun = "1111000000", demo_year = "2020") {

  cat("\n ------------------------- \n", sido, " : ", gusigun, " : ", demo_year, "\n ------------------------- \n")

  url <- glue::glue("https://jumin.mois.go.kr/ageStatMonth.do?",
                    "tableChart=T&sltOrgType=2",
                    "&sltOrgLvl1={sido}",
                    "&sltOrgLvl2={gusigun}",
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

get_demographic_emd_by_ten("1100000000", "1111000000", "2019")

get_demographic_emd_by_ten("4100000000", "4167000000", "2019")

safely_get_demographic_emd_by_ten <- safely(get_demographic_emd_by_ten, otherwise = "error")

# 2. 크롤링 -------------

gusigun_code <- read_csv("data-raw/sido_gusigun_code.csv", col_types = cols(.default = 'c'))


emd_demo_year_by_ten_raw <- demographics::sigungu_code %>%
  filter(!is.na(구시군명)) %>%
  rename(구시군코드 = 시도코드) %>%
  mutate(year = paste0(seq(2012, 2021, by =1), collapse = ",")) %>%
  separate(year, into = paste0("x", c(2012:2021)), sep = ",") %>%
  pivot_longer(cols = starts_with("x"), values_to = "연도") %>%
  mutate(시도코드 = glue::glue("{str_sub(구시군코드, 1,2)}00000000") ) %>%
  select(시도명, 시도코드, 구시군명, 구시군코드, 연도) %>%
  mutate(data = pmap(list(시도코드, 구시군코드, 연도), safely_get_demographic_emd_by_ten))


# 3. 데이터 정제 -------------


emd_demo_year_by_ten <- emd_demo_year_by_ten_raw %>%
  ### NULL 값 처리
  mutate(result = map(data, "result"),
         error  = map(data, "error")) %>%
  mutate(check = map_lgl(error, is.null)) %>%
  filter(check) %>%
  select(시도명, 시도코드, 구시군명, 구시군코드, 연도, result) %>%
  unnest(result) %>%
  filter(! str_detect(행정기관, "수원시|성남시|안양시|안산시|고양시|용인시"),
         ! str_detect(행정기관, "청주시|천안시|안양시|전주시|포항시|창원시") ) %>%
  select(시도명, 시도코드, 구시군명, 구시군코드, 연도, 행정기관코드, 행정기관, 성별, starts_with("x"))


# 4. 데이터 저장 -------------

usethis::use_data(emd_demo_year_by_ten, overwrite = TRUE)

# 5. 정합성 검증 -------------

# test_that("행안부 인구통계 - 성별, 연령별, 읍면동별", {
#
#   emd_demo_summary_tbl <- emd_demo_year_by_ten_tbl %>%
#     pivot_longer(cols = starts_with("x")) %>%
#     mutate(value = parse_number(value),
#            연도 = as.integer(연도)) %>%
#     filter(연도 >= 2013) %>%
#     group_by(시도명, 구시군명, 연도) %>%
#     summarise(인구수 = sum(value, na.rm = TRUE)) %>%
#     ungroup() %>%
#     mutate(연도 = as.character(연도))
#
#   emd_answer_tbl <- demographics::gusigun_demo_year_tbl %>%
#     pivot_longer(cols = starts_with("x"), names_to = "연령", values_to = "정답_인구수",
#                  values_transform = list(정답_인구수 = parse_number)) %>%
#     group_by(시도명, 구시군명 = 행정기관, 연도) %>%
#     summarise(정답_인구수 = sum(정답_인구수)) %>%
#     ungroup() %>%
#     filter(연도 >= 2012)
#
#   check_row <- emd_answer_tbl %>%
#     left_join(emd_demo_summary_tbl) %>%
#     mutate(차이 = 정답_인구수 - 인구수) %>%
#     filter(차이 !=0) %>%
#     nrow()
#
#   expect_that( check_row, equals(0))
# })
#
#
# emd_demo_year_tbl %>%
#   pivot_longer(cols = starts_with("x")) %>%
#   mutate(value = parse_number(value)) %>%
#   group_by(시도명, 연도) %>%
#   summarise(sum(value, na.rm = TRUE))
#



emd_demo_year_by_ten <- demographics::emd_demo_year_by_ten %>%
  filter(구시군명 !=행정기관)
  pivot_longer(cols = starts_with("x")) %>%
  mutate(value = parse_number(value),
         연도 = as.integer(연도)) %>%
  filter(연도 >= 2016, 연도 <= 2020) %>%
  group_by(시도명, 연도) %>%
  summarise(인구수 = sum(value, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(연도 = as.numeric(연도)) %>%
  arrange(시도명, 연도) %>%
  filter(str_detect(시도명, "경상남도"),
         연도 == 2020)






