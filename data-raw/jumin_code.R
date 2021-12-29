library(tidyverse)
library(jsonlite)

gusigun_code_list <- jsonlite::read_json("https://jumin.mois.go.kr/selectHangkikcdListAjax.do",  simplifyVector = TRUE)

gusigun_code <-  gusigun_code_list$locations %>%
  set_names(c("시도명", "시도코드", "구분", "구시군명")) %>%
  as_tibble()

# gusigun_code

usethis::use_data(gusigun_code, overwrite = TRUE)

