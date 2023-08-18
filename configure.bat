@echo off

::Defaults
::set IDE_TOOL=2022
set IDE_TOOL=CodeBlocks
set BUILD_DIR=%cd%\build
set SOURCE_DIR=%~dp0
set BUILD_TYPE=Debug
  
set PLATFORM_NAME=x64
set WEBENGINE=YES
IF "%IDE_TOOL%"=="2013" (
set CMAKE_GENERATOR="Visual Studio 12 Win64"
)
IF "%IDE_TOOL%"=="2017" (
set CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)
IF "%IDE_TOOL%"=="2019" (
set CMAKE_GENERATOR="Visual Studio 16 2019"
)
IF "%IDE_TOOL%"=="2022" (
set CMAKE_GENERATOR="Visual Studio 17 2022"
)
IF "%IDE_TOOL%"=="CodeBlocks" (
    set CMAKE_GENERATOR="CodeBlocks - MinGW Makefiles"
)

echo -- Build  Dir    : %BUILD_DIR%
echo -- Source Dir    : %SOURCE_DIR%
echo -- Tool Generator: %CMAKE_GENERATOR%



:CMAKE
mkdir %BUILD_DIR%
del %BUILD_DIR%\CMakeCache.txt > nul 2>&1
echo -- Running CMake
@echo on

set BOOST_PATH=C:\Users\lherr\Documents\Src\boost

cmake -G%CMAKE_GENERATOR% ^
-DBOOST_PATH=%BOOST_PATH% ^
-DUTF_HEADER_ONLY=1 ^
-DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
-B %BUILD_DIR% ^
-Wno-dev %* %SOURCE_DIR%

::-DBOOST_ROOT=%BOOST_PATH% ^
