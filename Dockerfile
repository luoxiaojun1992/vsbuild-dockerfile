# escape=`

# Use the latest Windows Server Core 2022 image.
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

RUN `
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.UniversalBuildTools workload, excluding workloads and components with known issues.
    && (start /w vs_buildtools.exe --wait --quiet --norestart --nocache --includeRecommended --includeOptional `
        --add Microsoft.VisualStudio.Workload.UniversalBuildTools `
        --add Microsoft.VisualStudio.Workload.MSBuildTools `
        --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
        --add Microsoft.VisualStudio.Workload.VCTools `
        --add Microsoft.VisualStudio.Workload.VisualStudioExtensionBuildTools `
        --add Microsoft.VisualStudio.Workload.WebBuildTools `
        --add Microsoft.VisualStudio.Workload.DataBuildTools `
        --add Microsoft.VisualStudio.Workload.XamarinBuildTools `
        --add Microsoft.VisualStudio.Workload.NodeBuildTools `
        --add Microsoft.NetCore.Component.Runtime.3.1 `
        --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" `
        || IF "%ERRORLEVEL%"=="3010" EXIT 0) `
    `
    # Cleanup
    && del /q vs_buildtools.exe

RUN `
    start /w msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
CMD ["powershell.exe", "-Command", "do { $n=Read-Host } while ( $n -ne 0 )"]
