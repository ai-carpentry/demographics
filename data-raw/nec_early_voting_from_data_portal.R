# 중앙선거관리위원회 사전투표 정보 조회 -----------------------
# 0. 팩키지 ------------------
library(tidyverse)
library(rvest)
library(httr)

## 데이터 정제
library(jsonlite)

demographics::election_code %>%
  filter(str_detect(sg_name, "대통령"))

# 1. 스크립트 -----------------------------------------------------------

early_voters_2017_url <- glue::glue("http://apis.data.go.kr/9760000/ErVotingSttusInfoInqireService/getErVotingSttusInfoInqire?",
                              "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                              "&pageNo=1",
                              "&numOfRows=1000",
                              "&resultType=json",
                              "&erVotingDiv=0",
                              # "&sgId=20220309",
                              "&sgId=20170509",
                              "&sdName={URLencode('서울특별시')}",
                              "&wiwName={URLencode('종로구')}")



early_voters_2017_resp <- GET(early_voters_2017_url)

early_voters_2017_json <- content(early_voters_2017_resp)

## 1.2. 데이터 정제작업 ------------------

early_voters_2017_list <- jsonlite::fromJSON(early_voters_2017_json)
early_voters_2017_list

early_voting_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx", sheet = 'ErVotingSttusInfoInqireService', skip = 2)

early_voting_2017_tbl <- early_voters_2017_list$getErVotingSttusInfoInqire$item %>%
  as_tibble() %>%
  set_names(early_voting_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

early_voting_2017_tbl

## 1.3. 데이터 내보내기 ------------------

# usethis::use_data(voters_2022_sido_tbl, overwrite = TRUE)

# 2. [함수] -----------------------------------------------------------
## 2.1 [함수] -------

get_2017_voter_sido <- function(sido_name="서울특별시", gusigun_name="종로구") {

  cat("\n----------------------------", sido_name, ":", gusigun_name, "\n")

  early_voters_url <- glue::glue("http://apis.data.go.kr/9760000/ErVotingSttusInfoInqireService/getErVotingSttusInfoInqire?",
                                  "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                  "&pageNo=1",
                                  "&numOfRows=1000",
                                  "&resultType=json",
                                  "&erVotingDiv=0",
                                  "&sgId=20170509",
                                  "&sdName={URLencode(sido_name)}",
                                  "&wiwName={URLencode(gusigun_name)}")


  early_voters_resp <- GET(early_voters_url)

  early_voters_json <- content(early_voters_resp)

  ## 1.2. 데이터 정제작업 ------------------

  early_voters_list <- jsonlite::fromJSON(early_voters_json)
  early_voters_list

  early_voting_tbl <- early_voters_list$getErVotingSttusInfoInqire$item %>%
    as_tibble() %>%
    janitor::clean_names(ascii = FALSE)

  early_voting_tbl

}

get_2017_voter_sido()

## 2.2 [함수] 크롤링 반복 -------------------
## 영문 변수명 --> 국문 변수명
early_voting_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx", sheet = 'ErVotingSttusInfoInqireService', skip = 2)

early_voting_2017_raw <- demographics::gusigun_20170509 %>%
  mutate(data = map2(상위시도명, 구시군명, get_2017_voter_sido))


early_voting_2017_tbl <- early_voting_2017_raw %>%
  mutate(data = map(data, ~.x %>% set_names(early_voting_varname$한글변수명)))


early_voting_2017_raw$data[[1]]
early_voting_2017_tbl$data[[1]]


early_voting_2017 <- early_voting_2017_tbl %>%
  select(data) %>%
  unnest(data)

## 2.3. 데이터 내보내기 ------------------

usethis::use_data(early_voting_2017, overwrite = TRUE)


