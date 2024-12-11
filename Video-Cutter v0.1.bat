@ECHO OFF
TITLE ffmpeg ���� Ŀ��

::ffmpeg.exe ���� üũ
IF NOT EXIST "ffmpeg.exe" (
	ECHO ffmpeg.exe ������ �����ϴ�.
	ECHO https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z ���� �ٿ�ε��� �ּ���. [��� �ٿ�ε� ��ũ]
	GOTO END
)

::���� ����, ���� �ʱ�ȭ
:Loop
PUSHD "%~dp0"
SET route0=%~dp0
SET route=%~dp0
SET errorlevel=0
SET /a count=0

::�۾� ��� �Է�
ECHO.
ECHO * ��ġ���ϰ� ������ ���丮�� ���, �Է����� ���� ���͸� ��������.
SET /P Input=�۾� �� ���� ���丮 ��� :
ECHO.
IF "%Input%" == "" GOTO file_Select
IF NOT "%Input%" == "" SET route=%Input%\&PUSHD "%Input%"

::���� ��� �ۼ�
:file_Select
ECHO   ��ȣ	���ϸ�
ECHO ������������������������������������������������������������������������������������������������������������������������
FOR /f "tokens=*" %%A IN ('DIR *.3gp *.asf *.avi *.dpl *.dsf *.flv *.mkv *.mov *.mp4 *.mpe *.mpeg *.mpg *.nsr *.ogm *.rmvb *.tp *.ts *.vob *.wm *.wmv /A:-D /O:N /B') DO CALL :list "%%A"

::���� ����, �ð� �Է�
:Pass
ECHO.
SET /P Select=�۾��� ���� ���� :
SET /P IN_time=���� �ð� �Է� (HH:mm:ss) :
SET /P OUT_time=���� �ð� �Է� (HH:mm:ss) :
ECHO.
FOR /f "delims=	 tokens=1-2" %%A IN (list) DO CALL :cut "%%A" "%%B"
::������ ���� ����Ʈ ����
DEL list
::�۾��Ϸ�, ���� �޻��� ���
IF "%errorlevel%" == "0" (ECHO �۾��� �Ϸ� �Ǿ����ϴ�.) ELSE (ECHO ����ġ ���� ������ �߻��߽��ϴ�.&GOTO END)
::���� ����
GOTO Loop
GOTO END

::ī��Ʈ �ϸ� ���� ��� ����
:list
SET /a count+=1
IF "%~1"=="" GOTO Pass
IF %count%==1 ECHO %count%	%~1>list
IF NOT %count%==1 ECHO %count%	%~1>>list
ECHO   %count%	%~1
EXIT /B

::ffmpeg ��ɾ� ����, �ߺ����� �ð� �Է�
:cut
FOR /f %%i IN ('powershell -c "get-date -format ddHHmmss"') DO SET DATETIME=%%i
IF %~1==%Select% "%route0%\ffmpeg.exe" -i "%route%%~2" -ss %IN_time% -to %OUT_time% -c copy "[cut %DATETIME%] %~2"
EXIT /B

:END
PAUSE