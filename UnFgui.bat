
@echo off
title Fgui批量反向解密工具 v1.0
::设置控制台属性
mode con cp select=65001 >nul
mode con cols=100 lines=35 >nul

setlocal enabledelayedexpansion
::基础颜色代码设置
for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "PINK=%ESC%[95m"
set "BLUE=%ESC%[94m"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "RESET=%ESC%[0m"
:: 检查Java环境
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未检测到node环境，请先安装node并配置环境变量

    pause
    exit /b 1
)

:: 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"

:menu
call :PRINT_TITLE "Fgui批量反向解密工具 v1.0"
call :PRINT_ENV
call :PRINT_OPTIONS
call :usage
echo 请选择操作:
set /p choice=请输入选项 (1/2):

if "%choice%"=="1" (
    call :check_dirs
    if "!dirs_exist!"=="true" (
        call :decrypt_all
    ) else (
        echo 错误: input  目录不存在，请检查后重试。
    )
    pause
    goto :menu
) else if "%choice%"=="2" (
    exit
) else (
    echo 无效选项，请重新输入。
    goto :menu
)

:check_dirs
echo 正在检查目录: %SCRIPT_DIR%input
if exist "%SCRIPT_DIR%input\" (
    echo 找到input目录: %SCRIPT_DIR%input\
    set dirs_exist=true
    
    rem 确保output目录存在
    if not exist "%SCRIPT_DIR%output\" (
        echo 创建output目录: %SCRIPT_DIR%output\
        mkdir "%SCRIPT_DIR%output"
    ) else (
        echo output目录已存在: %SCRIPT_DIR%output\
    )
) else (
    echo 错误: input目录不存在 - %SCRIPT_DIR%input\
    set dirs_exist=false
)
goto :eof

:decrypt_all
for /R "%SCRIPT_DIR%input" %%f in (*.bytes) do (
    echo ----开始反向Fgui资源文件: %%~nf ----
    
    rem 使用正确的路径格式
    node restore "%%f" "%SCRIPT_DIR%output"
    echo ----反向结束: %%~nf ----
)
goto :eof


:PRINT_TITLE
cls
echo -------------------------------------
echo %BLUE%   %~1%RESET%
echo -------------------------------------
exit /b

:PRINT_ENV
echo %GREEN%  所有人: 网络热心群众
echo %GREEN%  输入目录: %SCRIPT_DIR%input
echo -------------------------------------
exit /bs

:PRINT_OPTIONS
echo %BLUE%  [1] 解密input目录下所有 .bytes文件%RESET%
echo %BLUE%  [2] 退出程序%RESET%
echo -------------------------------------

exit /b

:usage
echo -------------------------------------
echo %BLUE%  使用说明 %RESET%
echo -------------------------------------
echo 1. 将需要解密的.bytes MOD UI文件放入input目录下。
echo 2. 选择选项1开始解密。
echo 3. 解密后的.bytes文件将保存在原MOD目录下，位置不会变化，方便修改MOD。
echo 4. 选择选项2退出程序。
echo -------------------------------------
exit /b



:main
goto :menu