#' 주민등록 인구통계 행정안전부
#'
#' 행정안전부 연령별 인구현황 통계표 기반 코드표
#'
#' @name gusigun_code
#' @format 18개 관측점과 2개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{시도명}{문자형, 시도명 전체 명칭}
#'   \item{시도코드}{문자형, 숫자 10자리}
#'   \item{구분}{문자, 1:시도명, 2:구시군명}
#'   \item{구시군명}{문자, 구시군명}
#' }
#' @source \url{https://jumin.mois.go.kr/}
"gusigun_code"
