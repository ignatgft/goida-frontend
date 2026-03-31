@echo off
REM Скрипт для запуска Android эмулятора с рабочим интернетом

echo Starting Android Emulator with DNS settings...

REM Получаем имя первого доступного AVD
for /f "tokens=*" %%i in ('adb emu avd name 2^>nul') do set AVD_NAME=%%i

if "%AVD_NAME%"=="" (
    echo No emulator running, trying to find AVD...
    for /f "tokens=1" %%i in ('emulator -list-avds 2^>nul ^| findstr /v "ERROR"') do (
        set AVD_NAME=%%i
        goto :found
    )
)

:found
if "%AVD_NAME%"=="" (
    echo No AVD found. Please create one in Android Studio.
    pause
    exit /b 1
)

echo Starting AVD: %AVD_NAME%

REM Запуск эмулятора с DNS и сетевыми настройками
start "Android Emulator" emulator -avd %AVD_NAME% -dns-server 8.8.8.8,8.8.4.4 -no-snapshot-load -no-snapshot-save

echo Waiting for emulator to start...
timeout /t 30 /nobreak

REM Проверка подключения
adb shell ping -c 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo Internet is working!
) else (
    echo Warning: Internet may not be working properly.
    echo Try restarting the emulator or check your network settings.
)

echo.
echo Emulator started. You can now run: flutter run
pause
