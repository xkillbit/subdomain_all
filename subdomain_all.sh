#!/bin/bash
url=$1
if [ ! -d "$url" ]; then
	mkdir $url
fi
if [ ! -d "$url/recon" ]; then
	mkdir -p $url/recon
fi
echo "[+] Harvesting subdomains with ASSETFINDER..."
assetfinder $url >> $url/recon/assets.txt
echo "[+] Data stored in file $url/recon/assets.txt"
cat $url/recon/assets.txt | grep $1 >> $url/recon/final_assets_by_assetfinder.txt
rm $url/recon/assets.txt
#echo "[+] Harvesting subdomains with AMASS..."
#amass enum -d $url >> #$url/recon/final_assets_by_amass.txt
#sort -u $url/recon/f.txt

echo "[+] Probing for alive subdomains..."
cat $url/recon/final_assets_by_assetfinder.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/alivedomains.txt
echo "[+] Output to $url/recon/alivedomains.txt..."
