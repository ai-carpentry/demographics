# 중앙선거관리위원회 선거인수현황 정보 조회 -----------------------
# 제20대 대통령선거 - 공공데이터포털
# 0. 팩키지 ------------------
library(tidyverse)
library(rvest)
library(httr)

## 데이터 정제
library(jsonlite)


# 1.시도 -----------------------------------------------------------
## 1.1. 데이터 가져오기 ------------------
voters_2022_sido <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getCtpvElcntInfoInqire?",
                              "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                              "&pageNo=1",
                              "&resultType=json",
                              "&sgTypecode=0",
                              "&sgId=20220309",
                              "&numOfRows=10000")


voters_2022_sido_resp <- GET(voters_2022_sido)

voters_2022_sido_json <- content(voters_2022_sido_resp)

## 1.2. 데이터 정제작업 ------------------

voters_2022_sido_list <- jsonlite::fromJSON(voters_2022_sido_json)

voter_sido_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx", sheet = 'getCtpvElcntInfoInqire', skip = 2)


voters_2022_sido_tbl <- voters_2022_sido_list$getCtpvElcntInfoInqire$item %>%
  as_tibble() %>%
  set_names(voter_sido_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE) %>%
  filter(시도명 != "합계")

## 1.3. 데이터 내보내기 ------------------

usethis::use_data(voters_2022_sido_tbl, overwrite = TRUE)


# 2. 구시군별 -----------------------------------------------------------
## 2.1. 데이터 가져오기 ------------------
voters_2022_gusigun <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getGsigElcntInfoInqire?",
                                           "&pageNo=1",
                                           "&resultType=json",
                                           "&sgTypecode=0",
                                           "&sgId=20220309",
                                           "&sdName={URLencode('서울특별시')}",
                                           "&numOfRows=100",
                                           "&serviceKey={Sys.getenv('DATA_APIKEY')}")

voters_2022_gusigun_resp <- GET(voters_2022_gusigun)

voters_2022_gusigun_json <- content(voters_2022_gusigun_resp)

## 2.2. 데이터 정제작업 ------------------

voters_2022_gusigun_list <- jsonlite::fromJSON(voters_2022_gusigun_json)


voters_2022_gusigun_tbl <- voters_2022_gusigun_list$getGsigElcntInfoInqire$item %>%
  as_tibble()
  set_names(voter_sido_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

## 2.3. 데이터 내보내기 ------------------

usethis::use_data(voters_2022_sido_tbl, overwrite = TRUE)

# 2. [함수] 구시군별 ---------------------------------------------------------------

## 2.1 [함수] -------

get_2022_voter_sido <- function(sido_name="강원도") {

  cat("\n----------------------------", sido_name, "\n")

  voters_2022_gusigun <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getGsigElcntInfoInqire?",
                                    "&pageNo=1",
                                    "&resultType=json",
                                    "&sgTypecode=0",
                                    "&sgId=20220309",
                                    "&sdName={URLencode(sido_name)}",
                                    "&numOfRows=1000",
                                    "&serviceKey={Sys.getenv('DATA_APIKEY')}")

  voters_2022_gusigun_resp <- GET(voters_2022_gusigun)

  voters_2022_gusigun_json <- content(voters_2022_gusigun_resp)

  ## 2.2. 데이터 정제작업 ------------------

  voters_2022_gusigun_list <- jsonlite::fromJSON(voters_2022_gusigun_json)


  voters_2022_gusigun_tbl <- voters_2022_gusigun_list$getGsigElcntInfoInqire$item %>%
    as_tibble()

  voters_2022_gusigun_tbl
}

# sido_name <- setdiff(voters_2022_sido_tbl$시도명, "합계")

get_2022_voter_sido()

## 2.2 [함수] 크롤링 반복 -------------------

voters_2022_gusigun_code_table <- tibble(시도명 = c("서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시",
                                                 "대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도", "충청북도",
                                                 "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주특별자치도"))

voters_2022_gusigun_raw <- voters_2022_gusigun_code_table %>%
  mutate(data = map(시도명, get_2022_voter_sido))

## 2.3 [함수] 데이터 정제 -------------------

voter_gusigun_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx", sheet = 'getGsigElcntInfoInqire', skip = 2)

voters_2022_gusigun_tbl <- voters_2022_gusigun_raw %>%
  mutate(data = map(data, ~.x %>% set_names(voter_gusigun_varname$국문변수명))) %>%
  select(-시도명) %>%
  unnest(data) %>%
  janitor::clean_names(ascii = FALSE) %>%
  filter(구시군명 != "합계")

voters_2022_gusigun_tbl

## 2.4 [함수] 내보내기 -------------------

usethis::use_data(voters_2022_gusigun_tbl, overwrite = TRUE)


# 3. 선거구별 -----------------------------------------------------------
# wiwCount	구시군수 <-- 스펙에 있으나 데이터는 존재하지 않음

## 3.1. 데이터 가져오기 ------------------
voters_2022_precinct <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getElpcElcntInfoInqire?",
                               "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                               "&pageNo=1",
                               "&resultType=json",
                               "&sgId=20220309",
                               "&sgTypecode=2",
                               "&sdName={URLencode('서울특별시')}",
                               "&wiwName={URLencode('종로구')}",
                               "&sgId=20220309",
                               "&numOfRows=10000")

voters_2022_precinct_resp <- GET(voters_2022_precinct)

voters_2022_precinct_json <- content(voters_2022_precinct_resp)

voters_2022_precinct_json

## 3.2. 데이터 정제작업 ------------------

voters_2022_precinct_list <- jsonlite::fromJSON(voters_2022_precinct_json)

voter_precinct_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx",
                                            sheet = 'getElpcElcntInfoInqire', skip = 2)


voters_2022_precinct_tbl <- voters_2022_precinct_list$getElpcElcntInfoInqire$item %>%
  as_tibble() %>%
  set_names(voter_precinct_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

voters_2022_precinct_tbl

## 3.3. 데이터 내보내기 ------------------

usethis::use_data(voters_2022_precinct_tbl, overwrite = TRUE)

# 3. [함수] 투표구별 ---------------------------------------------------------------

## 3.1 [함수] -------

get_2022_voter_precinct <- function(sido_name="서울특별시", gusigun = "종로구") {

  cat("\n----------------------------\n","시도명:", sido_name, "구시군명:", gusigun, "\n")

  voters_2022_precinct <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getElpcElcntInfoInqire?",
                                     "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                     "&pageNo=1",
                                     "&resultType=json",
                                     "&sgId=20220309",
                                     "&sgTypecode=2",
                                     "&sdName={URLencode(sido_name)}",
                                     "&wiwName={URLencode(gusigun)}",
                                     "&sgId=20220309",
                                     "&numOfRows=10000")

  voters_2022_precinct_resp <- GET(voters_2022_precinct)

  voters_2022_precinct_json <- content(voters_2022_precinct_resp)

  ## 3.2. 데이터 정제작업 ------------------

  voters_2022_precinct_list <- jsonlite::fromJSON(voters_2022_precinct_json)

  voters_2022_precinct_tbl <- voters_2022_precinct_list$getElpcElcntInfoInqire$item %>%
    as_tibble() %>%
    # set_names(voter_precinct_varname$한글변수명) %>%
    janitor::clean_names(ascii = FALSE)

  voters_2022_precinct_tbl

}

get_2022_voter_precinct()

## 3.2 [함수] 크롤링 반복 -------------------

voter_2022_precinct_code_table <- demographics::voters_2022_gusigun_tbl %>%
  select(시도명, 구시군명)

voters_2022_precicnt_raw <- voter_2022_precinct_code_table %>%
  mutate(data = map2(시도명, 구시군명, safely(get_2022_voter_precinct, otherwise = "error")) )

## 3.3 [함수] 데이터 정제 -------------------


voter_precinct_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx",
                                            sheet = 'getElpcElcntInfoInqire', skip = 2)

voters_2022_station_tbl <- voters_2022_precicnt_raw %>%
  mutate(data = map(data, ~.x %>% set_names(voter_station_varname$한글변수명))) %>%
  select(-시도명, -구시군명) %>%
  unnest(data) %>%
  janitor::clean_names(ascii = FALSE)  %>%
  filter(읍면동명 != "합계", 투표구명 != "합계")


voters_2022_precicnt_raw %>%
  mutate(error = map(data, "error")) %>%
  mutate(check = map_lgl(error, is.null)) %>% count(check)
  mutate(result = map(data, "result"))

## 5.4 [함수] 내보내기 -------------------

usethis::use_data(voters_2022_station_tbl, overwrite = TRUE)


# 4. 읍면동별 -----------------------------------------------------------
## 4.1. 데이터 가져오기 ------------------

voters_2022_emd_query <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getEmdElcntInfoInqire?",
                                     "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                     "&pageNo=1",
                                     "&resultType=json",
                                     "&sgId=20220309",
                                     "&sgTypecode=0",
                                     "&sdName={URLencode('서울특별시')}",
                                     "&wiwName={URLencode('종로구')}",
                                     "&sgId=20220309",
                                     "&numOfRows=10000")


voters_2022_emd_resp <- GET(voters_2022_emd_query)

voters_2022_emd_json <- content(voters_2022_emd_resp)

voters_2022_emd_json


## 4.2. 데이터 정제작업 ------------------

voter_emd_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx", sheet = 'getEmdElcntInfoInqire', skip = 2)


voters_2022_emd_list <- jsonlite::fromJSON(voters_2022_emd_json)

voters_2022_emd_tbl <- voters_2022_emd_list$getEmdElcntInfoInqire$item %>%
  as_tibble() %>%
  set_names(voter_emd_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

voters_2022_emd_tbl


# 4. [함수] 읍면동별 ---------------------------------------------------------------

## 4.1 [함수] -------

get_2022_voter_emd <- function(sido_name="서울특별시", gusigun = "종로구") {

  cat("\n----------------------------\n","시도명:", sido_name, "구시군명:", gusigun, "\n")

  voters_2022_emd_query <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getEmdElcntInfoInqire?",
                                      "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                      "&pageNo=1",
                                      "&resultType=json",
                                      "&sgId=20220309",
                                      "&sgTypecode=0",
                                      "&sdName={URLencode(sido_name)}",
                                      "&wiwName={URLencode(gusigun)}",
                                      "&sgId=20220309",
                                      "&numOfRows=10000")


  voters_2022_emd_resp <- GET(voters_2022_emd_query)

  voters_2022_emd_json <- content(voters_2022_emd_resp)


  ## 2.2. 데이터 정제작업 ------------------

  voters_2022_emd_list <- jsonlite::fromJSON(voters_2022_emd_json)

  voters_2022_emd_tbl <- voters_2022_emd_list$getEmdElcntInfoInqire$item %>%
    as_tibble() %>%
    # set_names(voter_emd_varname$한글변수명) %>%
    janitor::clean_names(ascii = FALSE)

  voters_2022_emd_tbl

}


get_2022_voter_emd()

## 4.2 [함수] 크롤링 반복 -------------------

voter_2022_emd_code_table <- demographics::voters_2022_gusigun_tbl %>%
  select(시도명, 구시군명)

voters_2022_emd_raw <- voter_2022_emd_code_table %>%
  mutate(data = map2(시도명, 구시군명, get_2022_voter_emd))

## 4.3 [함수] 데이터 정제 -------------------


voter_emd_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx",
                                        sheet = 'getEmdElcntInfoInqire', skip = 2)

voters_2022_emd_tbl <- voters_2022_emd_raw %>%
  mutate(data = map(data, ~.x %>% set_names(voter_emd_varname$한글변수명))) %>%
  select(-시도명, -구시군명) %>%
  unnest(data) %>%
  janitor::clean_names(ascii = FALSE)  %>%
  filter(읍면동명 != "합계")


## 4.4 [함수] 내보내기 -------------------

usethis::use_data(voters_2022_emd_tbl, overwrite = TRUE)


# 5. 투표구별 -----------------------------------------------------------
## 5.1. 데이터 가져오기 ------------------

voters_2022_station_query <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getVtdsElcntInfoInqire?",
                                    "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                    "&pageNo=1",
                                    "&resultType=json",
                                    "&sgId=20220309",
                                    "&sgTypecode=0",
                                    "&sdName={URLencode('서울특별시')}",
                                    "&wiwName={URLencode('종로구')}",
                                    "&sgId=20220309",
                                    "&numOfRows=10000")


voters_2022_station_resp <- GET(voters_2022_station_query)

voters_2022_station_json <- content(voters_2022_station_resp)

voters_2022_station_json


## 4.2. 데이터 정제작업 ------------------

voter_emd_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx",
                                        sheet = 'getVtdsElcntInfoInqire', skip = 2)


voters_2022_station_list <- jsonlite::fromJSON(voters_2022_station_json)

voters_2022_station_tbl <- voters_2022_station_list$getVtdsElcntInfoInqire$item %>%
  as_tibble() %>%
  set_names(voter_emd_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

voters_2022_station_tbl


# 5. [함수] 투표구별 ---------------------------------------------------------------

## 5.1 [함수] -------

get_2022_voter_station <- function(sido_name="서울특별시", gusigun = "종로구") {

  cat("\n----------------------------\n","시도명:", sido_name, "구시군명:", gusigun, "\n")

  voters_2022_station_query <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getVtdsElcntInfoInqire?",
                                      "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                      "&pageNo=1",
                                      "&resultType=json",
                                      "&sgId=20220309",
                                      "&sgTypecode=0",
                                      "&sdName={URLencode(sido_name)}",
                                      "&wiwName={URLencode(gusigun)}",
                                      "&sgId=20220309",
                                      "&numOfRows=10000")


  voters_2022_station_resp <- GET(voters_2022_station_query)

  voters_2022_station_json <- content(voters_2022_station_resp)


  ## 2.2. 데이터 정제작업 ------------------

  voters_2022_station_list <- jsonlite::fromJSON(voters_2022_station_json)

  voters_2022_station_tbl <- voters_2022_station_list$getVtdsElcntInfoInqire$item %>%
    as_tibble() %>%
    # set_names(voter_emd_varname$한글변수명) %>%
    janitor::clean_names(ascii = FALSE)

  voters_2022_station_tbl

}


get_2022_voter_station()

## 5.2 [함수] 크롤링 반복 -------------------

voter_2022_station_code_table <- demographics::voters_2022_gusigun_tbl %>%
  select(시도명, 구시군명)

voters_2022_station_raw <- voter_2022_station_code_table %>%
  mutate(data = map2(시도명, 구시군명, get_2022_voter_station))

## 5.3 [함수] 데이터 정제 -------------------


voter_station_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx",
                                        sheet = 'getVtdsElcntInfoInqire', skip = 2)

voters_2022_station_tbl <- voters_2022_station_raw %>%
  mutate(data = map(data, ~.x %>% set_names(voter_station_varname$한글변수명))) %>%
  select(-시도명, -구시군명) %>%
  unnest(data) %>%
  janitor::clean_names(ascii = FALSE)  %>%
  filter(읍면동명 != "합계", 투표구명 != "합계")


## 5.4 [함수] 내보내기 -------------------

usethis::use_data(voters_2022_station_tbl, overwrite = TRUE)

