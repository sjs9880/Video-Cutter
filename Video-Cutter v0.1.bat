@ECHO OFF
TITLE ffmpeg 영상 커터

::ffmpeg.exe 파일 체크
IF NOT EXIST "ffmpeg.exe" (
	ECHO ffmpeg.exe 파일이 없습니다.
	ECHO https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z 에서 다운로드해 주세요. [즉시 다운로드 링크]
	GOTO END
)

::루프 원점, 변수 초기화
:Loop
PUSHD "%~dp0"
SET route0=%~dp0
SET route=%~dp0
SET errorlevel=0
SET /a count=0

::작업 경로 입력
ECHO.
ECHO * 배치파일과 동일한 디랙토리인 경우, 입력하지 말고 엔터를 누르세요.
SET /P Input=작업 할 영상 디랙토리 경로 :
ECHO.
IF "%Input%" == "" GOTO file_Select
IF NOT "%Input%" == "" SET route=%Input%\&PUSHD "%Input%"

::파일 목록 작성
:file_Select
ECHO   번호	파일명
ECHO ────────────────────────────────────────────────────────────
FOR /f "tokens=*" %%A IN ('DIR *.3gp *.asf *.avi *.dpl *.dsf *.flv *.mkv *.mov *.mp4 *.mpe *.mpeg *.mpg *.nsr *.ogm *.rmvb *.tp *.ts *.vob *.wm *.wmv /A:-D /O:N /B') DO CALL :list "%%A"

::영상 선택, 시간 입력
:Pass
ECHO.
SET /P Select=작업할 영상 선택 :
SET /P IN_time=시작 시간 입력 (HH:mm:ss) :
SET /P OUT_time=종료 시간 입력 (HH:mm:ss) :
ECHO.
FOR /f "delims=	 tokens=1-2" %%A IN (list) DO CALL :cut "%%A" "%%B"
::생성한 파일 리스트 삭제
DEL list
::작업완료, 에러 메새지 출력
IF "%errorlevel%" == "0" (ECHO 작업이 완료 되었습니다.) ELSE (ECHO 예기치 못한 오류가 발생했습니다.&GOTO END)
::루프 종점
GOTO Loop
GOTO END

::카운트 하며 파일 목록 생성
:list
SET /a count+=1
IF "%~1"=="" GOTO Pass
IF %count%==1 ECHO %count%	%~1>list
IF NOT %count%==1 ECHO %count%	%~1>>list
ECHO   %count%	%~1
EXIT /B

::ffmpeg 명령어 실행, 중복방지 시간 입력
:cut
FOR /f %%i IN ('powershell -c "get-date -format ddHHmmss"') DO SET DATETIME=%%i
IF %~1==%Select% "%route0%\ffmpeg.exe" -i "%route%%~2" -ss %IN_time% -to %OUT_time% -c copy "[cut %DATETIME%] %~2"
EXIT /B

:END
PAUSE