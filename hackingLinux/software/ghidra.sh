
cd $HOME
mkdir ./Tools
cd ./Tools
mkdir ./Ghidra

wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.2_build/ghidra_11.4.2_PUBLIC_20250826.zip
unzip ghidra_11.4.2_PUBLIC_20250826.zip -d ./

chmod +x "$HOME/Tools/Ghidra/ghidraRun"

echo 'alias ghidra="$HOME/Tools/Ghidra/ghidraRun"' >> ~/.bashrc

source ~/.bashrc