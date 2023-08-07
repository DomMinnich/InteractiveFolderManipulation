@echo off
setlocal enabledelayedexpansion
set "subFolderFile=%temp%\subfolders.txt"

:mainMenu
cls 
echo.  
echo Interactive File Explorer     
echo.  
echo You Are Here:  %cd% 
echo -----------------------------------------------------------
echo 1. List Files
echo 2. Find Folders with Same Subfolders
echo 3. Create Folder (First Last) SINGLE
echo 4. Remove Folder (Remote) SINGLE
echo 5. Create Subfolder in All Folders 
echo 6. Delete Subfolder in All Folders
echo 7. Go to Child Directory
echo 8. Go to Parent Directory
echo 9. Create Folders from List
echo 10. Exit
echo -----------------------------------------------------------
set /p "option=Enter your choice: "

if "%option%"=="1" (
    call :listFiles
) else if "%option%"=="2" (
    call :findFoldersWithSameSubfolders
) else if "%option%"=="3" (
    call :createFolder
) else if "%option%"=="4" (
    call :removeFolder
) else if "%option%"=="5" (
    call :createSubfolderInAllFolders
) else if "%option%"=="6" (
    call :deleteSubfolderInAllFolders
) else if "%option%"=="7" (
    call :goToChildDirectory
) else if "%option%"=="8" (
    call :goToParentDirectory
) else if "%option%"=="9" (
    call :createFoldersFromList
) else if "%option%"=="10" (
    exit /b
) else (

    echo Invalid option. Press any key to continue.

    pause >nul
)
goto mainMenu

:listFiles
echo Files in the current directory:
echo ------------------------------
dir /b
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:createFoldersFromList
echo Enter folder names, one per line. Press '9' when done.
set /p "folderName="
if "%folderName%"=="9" goto doneCreatingFolders
mkdir "%folderName%"
goto createFoldersFromList

:doneCreatingFolders
echo. 
echo Folders created. Press any key to continue...
pause >nul
goto mainMenu


:findFoldersWithSameSubfolders
set "subFolderList="
set "subFolderContent="

for /d %%D in (*) do (
    set "subfolders="
    for /f "tokens=*" %%F in ('dir /b /s /a:d "%%D" ^| findstr /v /c:"\\%%~nxD$"') do (
        set "subfolders=!subfolders!%%F\n"
    )
    setlocal disabledelayedexpansion
    echo !subfolders! >> "%subFolderFile%"
    endlocal
    set "subFolderList=!subFolderList!%%D\n"
    set "subFolderContent=!subFolderContent!Subfolders for %%D:\n!subfolders!\n"
)

echo Folders with the same subfolders:
echo ------------------------------
echo %subFolderList%
echo.
echo Subfolders for each folder:
echo ------------------------------
echo %subFolderContent%
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:createFolder
set "firstName="
set "lastName="

echo Enter the first name:
set /p "firstName="
echo Enter the last name:
set /p "lastName="

set "folderName=%firstName% %lastName%"

md "%folderName%"
echo Folder "%folderName%" created successfully.
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:removeFolder
set "folderName="

echo Enter the folder name to remove:
set /p "folderName="

if exist "%folderName%" (
    rd /s /q "%folderName%"
    echo Folder "%folderName%" removed successfully.
) else ( 
	echo Folder "%folderName%" does not exist.
)
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:createSubfolderInAllFolders
set "subfolderName="

echo Enter the name of the subfolder to create:
set /p "subfolderName="

for /d %%D in (*) do (
    if not exist "%%D\%subfolderName%" (
        md "%%D\%subfolderName%"
        echo Subfolder "%subfolderName%" created in folder "%%D".
    )
)
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:deleteSubfolderInAllFolders
set "subfolderName="

echo Enter the name of the subfolder to delete:
set /p "subfolderName="

for /d %%D in (*) do (
    if exist "%%D\%subfolderName%" (
        rd /s /q "%%D\%subfolderName%"
        echo Subfolder "%subfolderName%" deleted from folder "%%D".
    )
)
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:goToChildDirectory
set "directoryName="

echo Enter the name of the child directory:
set /p "directoryName="

if exist "%directoryName%" (
    cd "%directoryName%"
    echo Entered into directory "%cd%".
) else (
    echo Directory "%directoryName%" does not exist.
)
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b

:goToParentDirectory
cd ..
echo Entered into parent directory "%cd%".
pause >nul
echo.
echo Press any key to continue...
pause >nul
exit /b


