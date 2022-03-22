
################################################################# ---
##               주민등록 인구통계 코드 마스터                 ##
##                    개발자: 이광춘                           ##
##                최종수정일: 2022-03-22                       ##
################################################################# ---
## 데이터 출처: https://jumin.mois.go.kr/
## 시도명, 시도코드, 구분, 구시군명

# 주민등록 인구통계 코드 마스터 -------------------------------

library(tidyverse)
library(jsonlite)

sigungu_code_list <- jsonlite::read_json("https://jumin.mois.go.kr/selectHangkikcdListAjax.do",  simplifyVector = TRUE)

sigungu_code <-  sigungu_code_list$locations %>%
  set_names(c("시도명", "시도코드", "구분", "구시군명")) %>%
  as_tibble()

# 데이터 내보내기 -------------------------------

usethis::use_data(sigungu_code, overwrite = TRUE)

