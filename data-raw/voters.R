# 유권자 -----------------------
##
library(tidyverse)
library(rvest)
library(httr)


election_code <- endpoint <- glue::glue("http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList?",
                                        "&ServiceKey={Sys.getenv('DATA_APIKEY')}",
                                        "&pageNo=1",
                                        "&resultType=json",
                                        "&resultType=xml",
                                        "&numOfRows=10000")


election_code_resp <- GET(election_code)

election_code_json <- content(election_code_resp)


