@echo off
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent /v DriverControl
IF %errorlevel%==0 GOTO Enable32
GOTO Enable64


32 Bit
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:Enable32
FOR /F "usebackq tokens=2,* skip=2" %%L IN (
    `REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent" /v DriverControl`
) DO SET ID=%%M
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent\%ID% /v EnableRemoteControl
IF %errorlevel%==1 GOTO Disable32
NET stop "Kaseya Agent"
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent\%ID%" /v EnableRemoteControl /f
NET start "Kaseya Agent"
GOTO End


:Disable32
FOR /F "usebackq tokens=2,* skip=2" %%L IN (
    `REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent" /v DriverControl`
) DO SET ID=%%M
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent\%ID% /v EnableRemoteControl
IF %errorlevel%==0 GOTO Enable32
NET stop "Kaseya Agent"
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Kaseya\Agent\%ID%" /v EnableRemoteControl /t REG_DWORD /d 0 /f
NET start "Kaseya Agent"
GOTO End


64 Bit
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:Enable64
FOR /F "usebackq tokens=2,* skip=2" %%L IN (
    `REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Kaseya\Agent" /v DriverControl`
) DO SET ID=%%M
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Kaseya\Agent\%ID% /v EnableRemoteControl
IF %errorlevel%==1 GOTO Disable64
NET stop "Kaseya Agent"
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Kaseya\Agent\%ID%" /v EnableRemoteControl /f
NET start "Kaseya Agent"
GOTO End


:Disable64
FOR /F "usebackq tokens=2,* skip=2" %%L IN (
    `REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Kaseya\Agent" /v DriverControl`
) DO SET ID=%%M
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Kaseya\Agent\%ID% /v EnableRemoteControl
IF %errorlevel%==0 GOTO Enable64
NET stop "Kaseya Agent"
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Kaseya\Agent\%ID%" /v EnableRemoteControl /t REG_DWORD /d 0 /f
NET start "Kaseya Agent"
GOTO End


:End
