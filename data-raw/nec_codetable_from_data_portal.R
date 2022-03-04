# 중앙선거관리위원회 코드정보 -----------------------
# 0. 팩키지 ------------------
library(tidyverse)
library(rvest)
library(httr)

## 데이터 정제
library(jsonlite)

# 1. 선거코드(election_code) -----------------------------------------
## 1. 데이터 가져오기 ------------------
election_code_url <- glue::glue("http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList?",
                                "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                "&pageNo=1",
                                "&resultType=json",
                                "&resultType=xml",
                                "&numOfRows=10000")

election_code_resp <- GET(election_code_url)

election_code_json <- content(election_code_resp)

## 1.2. 데이터 정제작업 ------------------

election_code_list <- jsonlite::fromJSON(election_code_json)


election_code <- election_code_list$getCommonSgCodeList$item %>%
  as_tibble() %>%
  janitor::clean_names()

## 1.3. 데이터 내보내기 ------------------

usethis::use_data(election_code, overwrite = TRUE)

## 1.4. 문서화 ---------------------------

# election_code_meta_raw <- '{"name":"중앙선거관리위원회 코드정보","description":"선거ID와 선거종류코드, 선거명, 선거구등 선거에 관련된 기초코드를 조회할 수 있는 기능을 제공하는 조회서비스","url":"https://www.data.go.kr/data/15000897/openapi.do","keywords":["중앙선거관리위원회,코드,선거"],"license":"https://data.go.kr/ugs/selectPortalPolicyView.do","dateCreated":"2018-05-08","dateModified":"2022-02-04","datePublished":"2018-05-08","creator":{"name":"중앙선거관리위원회","contactPoint":{"contactType":"정보운영과","telephone":"+82-0232941153","@type":"ContactPoint"},"@type":"Organization"},"distribution":[{"encodingFormat":"XML","contentUrl":"https://www.data.go.kr/data/15000897/openapi.do","@type":"DataDownload"}],"@context":"https://schema.org","@type":"Dataset"}'
#
# election_code_meta <- jsonlite::fromJSON(election_code_meta_raw)
#
# listviewer::jsonedit(election_code_meta)


# 2. 제20대 대선 구시군코드 -----------------------------------------
## 2.1. 스크립트 ----------------------------
### 2.1.1. 데이터 가져오기 ------------------
gusigun_code_url <- glue::glue("http://apis.data.go.kr/9760000/CommonCodeService/getCommonGusigunCodeList?",
                               "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                               "&pageNo=1",
                               "&numOfRows=10000",
                               "&resultType=json",
                               "&sgId=20220309",
                               "&sdName={URLencode('서울특별시')}")


gusigun_code_resp <- GET(gusigun_code_url)

gusigun_code_json <- content(gusigun_code_resp)

### 2.1.2. 데이터 정제작업 ------------------

gusigun_code_list <- jsonlite::fromJSON(gusigun_code_json)

gusigun_code <- gusigun_code_list$getCommonGusigunCodeList$item %>%
  as_tibble() %>%
  janitor::clean_names()

## 2.2. 함수 ----------------------------

get_gusigun_code <- function(election_code = "20220309", sido_name = "서울특별시") {

  cat("\n--------------------------\n      ", sido_name, "\n\n")

  gusigun_code_url <- glue::glue("http://apis.data.go.kr/9760000/CommonCodeService/getCommonGusigunCodeList?",
                                 "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                 "&pageNo=1",
                                 "&numOfRows=10000",
                                 "&resultType=json",
                                 "&sgId={election_code}",
                                 "&sdName={URLencode(sido_name)}")

  gusigun_code_resp <- GET(gusigun_code_url)

  gusigun_code_json <- content(gusigun_code_resp)

  ### 2.1.2. 데이터 정제작업 ------------------

  gusigun_code_list <- jsonlite::fromJSON(gusigun_code_json)

  gusigun_code <- gusigun_code_list$getCommonGusigunCodeList$item %>%
    as_tibble() %>%
    janitor::clean_names()

  gusigun_code

}

get_gusigun_code("서울특별시")

## 2.3. 전체 가져오기 & 데이터 정제 ----------------------------

## 시도명 마스터
gusigun_sido <- tibble(시도명 = c("강원도", "경기도", "경상남도", "경상북도", "광주광역시", "대구광역시",
                                 "대전광역시", "부산광역시", "서울특별시", "세종특별자치시", "울산광역시",
                                 "인천광역시", "전라남도", "전라북도", "제주특별자치도", "충청남도", "충청북도"))

## 영문 변수명 --> 국문 변수명
early_voting_varname <- readxl::read_excel("data-raw/공공데이터포털_선거인수현황.xlsx", sheet = 'getCommonGusigunCodeList', skip = 2)

gusigun_20220309_raw <- gusigun_sido %>%
  mutate(선거코드 = "20220309") %>%
  mutate(data = map2(선거코드, 시도명, get_gusigun_code) )

gusigun_20220309 <- gusigun_20220309_raw %>%
  select(-선거코드, -시도명) %>%
  mutate(data = map(data, ~.x %>% set_names(early_voting_varname$한글변수명))) %>%
  unnest(data)


## 2.4. 데이터 내보내기 ------------------

usethis::use_data(gusigun_20220309, overwrite = TRUE)


# 3. 제19대 대선 구시군코드 -----------------------------------------

gusigun_20170509_raw <- gusigun_sido %>%
  mutate(선거코드 = "20170509") %>%
  mutate(data = map2(선거코드, 시도명, get_gusigun_code) )

gusigun_20170509 <- gusigun_20170509_raw %>%
  select(-선거코드, -시도명) %>%
  mutate(data = map(data, ~.x %>% set_names(early_voting_varname$한글변수명))) %>%
  unnest(data)


## 2.4. 데이터 내보내기 ------------------

usethis::use_data(gusigun_20170509, overwrite = TRUE)
