
@echo off
flutter pub run build_runner build --delete-conflicting-outputs 


if %errorlevel% neq 0 (
		echo Build failed with error code %errorlevel%.
		exit /b %errorlevel%
) else (
		echo Build completed successfully.
)