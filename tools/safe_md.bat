if exist "%1" goto already
echo Create directory [%1]
mkdir "%1"
goto end

:already
echo Directory [%1] already exists
goto end

:end
