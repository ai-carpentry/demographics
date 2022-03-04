#' 시도, 구시군별 주민등록 인구통계 행정안전부
#'
#' 행정안전부 성별, 연령별 시도, 구시군별 인구현황
#' 2012년 ~ 2021년
#'
#' @name gusigun_demo_year_tbl
#' @format 4,520개 관측점과  18개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{시도명}{문자형, 시도명 전체 명칭}
#'   \item{시도코드}{문자형, 숫자 10자리}
#'   \item{연도}{문자형, 숫자 4자리, 2012 ~ 2020}
#'   \item{행정기관코드}{행정기관코드, 숫자 10 자리코드}
#'   \item{행정기관}{문자형, 행정기관명, 구시군명}
#'   \item{성별}{문자형, 남/여}
#'   \item{x0_9세}{문자형, 0~9세 인구수}
#'   \item{...}{문자형, ...세 인구수}
#'   \item{x100세_이상}{문자형, 100세 이상 인구수}
#' }
#' @export gusigun_demo_year_tbl
#' @source \url{https://jumin.mois.go.kr/}
"gusigun_demo_year_tbl"

#' 시도, 구시군별 주민등록 인구통계 행정안전부
#'
#' 행정안전부 성별, 연령별 시도, 구시군별 인구현황
#' 2012년 ~ 2021년
#' 연령 구분 단위: 5 세#'
#'
#' @name emd_demo_year_by_five_tbl
#' @format 71,454개 관측점과  29개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{시도명}{문자형, 시도명 전체 명칭}
#'   \item{시도코드}{문자형, 숫자 10자리}
#'   \item{구시군명}{문자형, 구시군명 전체 명칭}
#'   \item{구시군코드}{문자형, 숫자 10자리}
#'   \item{연도}{문자형, 숫자 4자리, 2012 ~ 2020}
#'   \item{행정기관코드}{행정기관코드, 숫자 10 자리코드}
#'   \item{행정기관}{문자형, 행정기관명, 구시군명}
#'   \item{성별}{문자형, 남/여}
#'   \item{x0_9세}{문자형, 0~9세 인구수}
#'   \item{...}{문자형, ...세 인구수}
#'   \item{x100세_이상}{문자형, 100세 이상 인구수}
#' }
#' @export emd_demo_year_by_five_tbl
#' @source \url{https://jumin.mois.go.kr/}
"emd_demo_year_by_five_tbl"


#' 시도, 구시군별 주민등록 인구통계 행정안전부
#'
#' 행정안전부 성별, 연령별 시도, 구시군별 인구현황
#' 2012년 ~ 2021년
#' 연령 구분 단위: 10 세
#'
#' @name emd_demo_year_by_ten_tbl
#' @format 64,308개 관측점과  19개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{시도명}{문자형, 시도명 전체 명칭}
#'   \item{시도코드}{문자형, 숫자 10자리}
#'   \item{구시군명}{문자형, 구시군명 전체 명칭}
#'   \item{구시군코드}{문자형, 숫자 10자리}
#'   \item{연도}{문자형, 숫자 4자리, 2012 ~ 2020}
#'   \item{행정기관코드}{행정기관코드, 숫자 10 자리코드}
#'   \item{행정기관}{문자형, 행정기관명, 구시군명}
#'   \item{성별}{문자형, 남/여}
#'   \item{x0_9세}{문자형, 0~9세 인구수}
#'   \item{...}{문자형, ...세 인구수}
#'   \item{x100세_이상}{문자형, 100세 이상 인구수}
#' }
#' @export emd_demo_year_by_ten_tbl
#' @source \url{https://jumin.mois.go.kr/}
"emd_demo_year_by_ten_tbl"


#' 중앙선거관리위원회 코드정보
#'
#' 선거ID와 선거종류코드, 선거명, 선거구등 선거에 관련된 기초코드
#' OpenAPI활용가이드(코드정보)_v3.6.hwp
#'
#' @name election_code
#' @format 79개 관측점과 5개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{num}{문자형, 번호}
#'   \item{sg_id}{문자형, 선거코드(선거일)}
#'   \item{sg_name}{문자, 선거명}
#'   \item{sg_typecode}{문자, 선거종류코드}
#' }
#' @export election_code
#' @source \url{https://www.data.go.kr/}
"election_code"


#' 선관위 제20대 대통령선거 구시군 코드정보
#'
#' 선관위 구시군코드 (제20대 대통령선거, 20220309)
#' OpenAPI활용가이드(코드정보)_v3.6.hwp
#'
#' @name gusigun_20220309
#' @format 250개 관측점과 5개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{num}{문자형, 번호}
#'   \item{선거ID}{문자형, 선거코드(선거일)}
#'   \item{구시군명}{문자, 구시군명}
#'   \item{순서}{문자, 순서}
#'   \item{상위시도명}{문자, 시도명}
#' }
#' @export gusigun_20220309
#' @source \url{https://www.data.go.kr/}
"gusigun_20220309"


#' 선관위 제19대 대통령선거 구시군 코드정보
#'
#' 선관위 구시군코드 (제19대 대통령선거, 20170509)
#' OpenAPI활용가이드(코드정보)_v3.6.hwp
#'
#' @name gusigun_20170509
#' @format 250개 관측점과 5개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{num}{문자형, 번호}
#'   \item{선거ID}{문자형, 선거코드(선거일)}
#'   \item{구시군명}{문자, 구시군명}
#'   \item{순서}{문자, 순서}
#'   \item{상위시도명}{문자, 시도명}
#' }
#' @export gusigun_20170509
#' @source \url{https://www.data.go.kr/}
"gusigun_20170509"


#' NEC 제20대 대통령선거 유권자
#' 17개 시도별
#'
#' 17개 시도별 선거인수
#'
#' @name voters_2022_sido_tbl
#' @format 17개 관측점과 24개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{결과순서}{문자형, 번호}
#'   \item{선거_id}{문자형, 선거코드(선거일)}
#'   \item{시도명}{문자, 시도명}
#'   \item{...}{문자, ...}
#' }
#' @export voters_2022_sido_tbl
#' @source \url{https://www.data.go.kr/}
"voters_2022_sido_tbl"


#' NEC 제20대 대통령선거 유권자
#' 250개 구시군별 유권자 현황
#'
#' 18개 시도 250개 구시군별 유권자 남여, 재외국민, 남녀, 거소투표
#'
#' @name voters_2022_gusigun_tbl
#' @format 250개 관측점과 24개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{결과순서}{문자형, 번호}
#'   \item{선거_id}{문자형, 선거코드(선거일)}
#'   \item{시도명}{문자, 시도명}
#'   \item{구시군명}{문자, 구시군명}
#'   \item{...}{문자, ...}
#' }
#' @export voters_2022_gusigun_tbl
#' @source \url{https://www.data.go.kr/}
"voters_2022_gusigun_tbl"


#' NEC 제20대 대통령선거 유권자
#' 3,510개 읍면동별 유권자 현황
#'
#' 18개 시도, 250개 구시군별, 3,510개 읍면동별 유권자 남여, 재외국민, 남녀, 거소투표
#'
#' @name voters_2022_emd_tbl
#' @format 250개 관측점과 24개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{결과순서}{문자형, 번호}
#'   \item{선거_id}{문자형, 선거코드(선거일)}
#'   \item{시도명}{문자, 시도명}
#'   \item{구시군명}{문자, 구시군명}
#'   \item{읍면동명}{문자, 읍면동명}
#'   \item{...}{문자, ...}
#' }
#' @export voters_2022_emd_tbl
#' @source \url{https://www.data.go.kr/}
"voters_2022_emd_tbl"

#' NEC 제20대 대통령선거 유권자
#' 14,464개 투표소별 유권자 현황
#'
#' 18개 시도, 250개 구시군별, 3,510개 읍면동별,
#' 14,464개 투표소별 유권자 남여, 재외국민, 남녀, 거소투표
#'
#' @name voters_2022_station_tbl
#' @format 250개 관측점과 24개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{결과순서}{문자형, 번호}
#'   \item{선거_id}{문자형, 선거코드(선거일)}
#'   \item{시도명}{문자, 시도명}
#'   \item{구시군명}{문자, 구시군명}
#'   \item{읍면동명}{문자, 읍면동명}
#'   \item{투표구명}{문자, 투표구명}
#'   \item{...}{문자, ...}
#' }
#' @export voters_2022_station_tbl
#' @source \url{https://www.data.go.kr/}
"voters_2022_station_tbl"

#' NEC 제19대 대통령선거 구시군별 사전투표율
#' 250개 구시군별 전체(0)
#'
#' 18개 시도, 250개 구시군별, 3,510개 읍면동별,
#' 14,464개 투표소별 유권자 남여, 재외국민, 남녀, 거소투표
#'
#' @name early_voting_2017
#' @format 250개 관측점과 9개 변수를 갖는 데이터프레임
#' \describe{
#'   \item{결과순서}{문자형, 번호}
#'   \item{선거_id}{문자형, 선거코드(선거일)}
#'   \item{사전투표구분}{문자, 사전투표구분: 전체 0, 첫날 1, 둘째날 2}
#'   \item{시도명}{문자, 시도명}
#'   \item{구시군명}{문자, 구시군명}
#'   \item{선거인수}{문자, 선거인수}
#'   \item{사전투표자수}{문자, 사전투표자수}
#'   \item{사전투표율}{문자, 사전투표율}
#'   \item{순서}{문자, 순서}
#' }
#' @export early_voting_2017
#' @source \url{https://www.data.go.kr/}
"early_voting_2017"
