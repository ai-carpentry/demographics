# 중앙선거관리위원회 코드정보 -----------------------

# 0. 팩키지 ------------------
library(tidyverse)
library(rvest)
library(httr)

## 데이터 정제
library(jsonlite)


# 1. 데이터 가져오기 ------------------
election_code <- endpoint <- glue::glue("http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList?",
                                        "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                        "&pageNo=1",
                                        "&resultType=json",
                                        "&resultType=xml",
                                        "&numOfRows=10000")


election_code_resp <- GET(election_code)

election_code_json <- content(election_code_resp)

# 2. 데이터 정제작업 ------------------

election_code_list <- jsonlite::fromJSON(election_code_json)


election_code <- election_code_list$getCommonSgCodeList$item %>%
  as_tibble() %>%
  janitor::clean_names()

# 3. 데이터 내보내기 ------------------

usethis::use_data(election_code, overwrite = TRUE)

# 4. 문서화 ---------------------------

# election_code_meta_raw <- '{"name":"중앙선거관리위원회 코드정보","description":"선거ID와 선거종류코드, 선거명, 선거구등 선거에 관련된 기초코드를 조회할 수 있는 기능을 제공하는 조회서비스","url":"https://www.data.go.kr/data/15000897/openapi.do","keywords":["중앙선거관리위원회,코드,선거"],"license":"https://data.go.kr/ugs/selectPortalPolicyView.do","dateCreated":"2018-05-08","dateModified":"2022-02-04","datePublished":"2018-05-08","creator":{"name":"중앙선거관리위원회","contactPoint":{"contactType":"정보운영과","telephone":"+82-0232941153","@type":"ContactPoint"},"@type":"Organization"},"distribution":[{"encodingFormat":"XML","contentUrl":"https://www.data.go.kr/data/15000897/openapi.do","@type":"DataDownload"}],"@context":"https://schema.org","@type":"Dataset"}'
#
# election_code_meta <- jsonlite::fromJSON(election_code_meta_raw)
#
# listviewer::jsonedit(election_code_meta)
