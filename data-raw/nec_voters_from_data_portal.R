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


voters_2022_sido_tbl <- voters_2022_sido_list$getCtpvElcntInfoInqire$item %>%
  as_tibble() %>%
  set_names(voter_sido_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

## 1.3. 데이터 내보내기 ------------------

usethis::use_data(voters_2022_sido_tbl, overwrite = TRUE)

## 1.4. 문서화 ---------------------------

voter_sido_varname <- tribble(~"영문변수명", ~"한글변수명",
                              "num", "결과순서",
                              "sgId", "선거ID",
                              "sdName", "시도명",
                              "wiwCount", "구시군수",
                              "emdCount", "읍면동수",
                              "tpgCount", "투표구수",
                              "ppltCnt", "인구수",
                              "ntabPpltCnt", "인구수(재외국민)",
                              "frgnrPpltCnt", "인구수(외국인)",
                              "cfmtnElcnt", "확정선거인수(계)",
                              "cfmtnRacnt", "확정선거인수(계_재외국민)",
                              "cfmtnFrgnrCnt", "확정선거인수(계_외국인)",
                              "cfmtnManElcnt", "확정선거인수(남)",
                              "cfmtnManRacnt", "확정선거인수(남_재외국민)",
                              "cfmtnManFrgnrCnt", "확정선거인수(남_외국인)",
                              "cfmtnFmlElcnt", "확정선거인수(여)",
                              "cfmtnFmlRacnt", "확정선거인수(여_재외국민)",
                              "cfmtnFmlFrgnrCnt", "확정선거인수(여_외국인)",
                              "cfmtnRdvtDccnt", "거소투표 신고인명부 등재자수(계)",
                              "cfmtnNtabRdvtDccnt", "거소투표 신고인명부 등재자수(계_재외국민)",
                              "cfmtnRdvtManDccnt", "거소투표 신고인명부 등재자수(남)",
                              "cfmtnNtabRdvtManDccnt", "거소투표 신고인명부 등재자수(남_재외국민)",
                              "cfmtnRdvtFmlDccnt", "거소투표 신고인명부 등재자수(여)",
                              "cfmtnNtabRdvtFmlDccnt", "거소투표 신고인명부 등재자수(여_재외국민)")


# 2. 구시군별 -----------------------------------------------------------
## 2.1. 데이터 가져오기 ------------------
voters_2022_gusigun <- glue::glue("http://apis.data.go.kr/9760000/ElcntInfoInqireService/getGsigElcntInfoInqire?",
                                           "&pageNo=1",
                                           "&resultType=json",
                                           "&sgTypecode=0",
                                           "&sgId=20220309",
                                           "&sdName=서울특별시",
                                           "&numOfRows=100",
                                           "&serviceKey={Sys.getenv('DATA_APIKEY')}")

voters_2022_gusigun_resp <- GET(voters_2022_gusigun)

voters_2022_gusigun_json <- content(voters_2022_gusigun_resp)

## 1.2. 데이터 정제작업 ------------------

voters_2022_gusigun_list <- jsonlite::fromJSON(voters_2022_gusigun_json)


voters_2022_gusigun_tbl <- voters_2022_gusigun_list$getCtpvElcntInfoInqire$item %>%
  as_tibble()
  set_names(voter_sido_varname$한글변수명) %>%
  janitor::clean_names(ascii = FALSE)

## 1.3. 데이터 내보내기 ------------------

usethis::use_data(voters_2022_sido_tbl, overwrite = TRUE)

## 1.4. 문서화 ---------------------------

voter_sido_varname <- tribble(~"영문변수명", ~"한글변수명",
                              "num", "결과순서",
                              "sgId", "선거ID",
                              "sdName", "시도명",
                              "wiwCount", "구시군수",
                              "emdCount", "읍면동수",
                              "tpgCount", "투표구수",
                              "ppltCnt", "인구수",
                              "ntabPpltCnt", "인구수(재외국민)",
                              "frgnrPpltCnt", "인구수(외국인)",
                              "cfmtnElcnt", "확정선거인수(계)",
                              "cfmtnRacnt", "확정선거인수(계_재외국민)",
                              "cfmtnFrgnrCnt", "확정선거인수(계_외국인)",
                              "cfmtnManElcnt", "확정선거인수(남)",
                              "cfmtnManRacnt", "확정선거인수(남_재외국민)",
                              "cfmtnManFrgnrCnt", "확정선거인수(남_외국인)",
                              "cfmtnFmlElcnt", "확정선거인수(여)",
                              "cfmtnFmlRacnt", "확정선거인수(여_재외국민)",
                              "cfmtnFmlFrgnrCnt", "확정선거인수(여_외국인)",
                              "cfmtnRdvtDccnt", "거소투표 신고인명부 등재자수(계)",
                              "cfmtnNtabRdvtDccnt", "거소투표 신고인명부 등재자수(계_재외국민)",
                              "cfmtnRdvtManDccnt", "거소투표 신고인명부 등재자수(남)",
                              "cfmtnNtabRdvtManDccnt", "거소투표 신고인명부 등재자수(남_재외국민)",
                              "cfmtnRdvtFmlDccnt", "거소투표 신고인명부 등재자수(여)",
                              "cfmtnNtabRdvtFmlDccnt", "거소투표 신고인명부 등재자수(여_재외국민)")
