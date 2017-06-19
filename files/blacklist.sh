#!/bin/bash 
#Script that downloads the Emerging Threats - Shadowserver C&C List, #Spamhaus 
#DROP Nets, Dshield Top Attackers, Known RBN Nets #and IPs, Compromised IP List, 
#RBN Malvertisers IP List;  AlienVault - IP Reputation Database; ZeuS Tracker - 
#IP Block List; SpyEye Tracker - IP Block List; Palevo Tracker - IP Block List; 
#SSLBL - SSL Blacklist; Malc0de Blacklist; Binary Defense Systems Artillery 
#Threat Intelligence Feed and Banlist Feedand then strips any junk/formatting 
#that can't be used and creates Splunk-ready inputs.    
#   
#Feel free to use and modify as needed   
#   
#Author: Adrian Daucourt based on work from Keith
#(http://#sysadminnygoodness.blogspot.com)   
#
#==============================================================================
#Fix error when calling script from Splunk
#==============================================================================

unset LD_LIBRARY_PATH

#==============================================================================
#Set threatlist base directory variable
#==============================================================================

tl_dir=/opt/threatlists         # threatlist directory *.txt monitored by splunk

#==============================================================================
#Emerging Threats - Abuse.ch C&C List, Spamhaus DROP Nets, Dshield Top
#Attackers
#==============================================================================

wget http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt -O $tl_dir/emerging-Block-IPs.txt --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/emerging_threats_abusech_ips.txt

cat $tl_dir/emerging-Block-IPs.txt | sed -e '1,/# \Feodo/d' -e '/#/,$d' | sed -n '/^[0-9]/p' | sed 's/$/ Abuse.ch C&C List/' > $tl_dir/emerging_threats_abusech_ips.tmp

echo "# Generated: `date`" > $tl_dir/emerging_threats_spamhaus_drop_ips.txt

# apt-get install prips OR compile from source for rpm based https://gitlab.com/prips/prips

cat $tl_dir/emerging-Block-IPs.txt | sed -e '1,/#Spamhaus DROP Nets/d' -e '/#/,$d' | xargs -n 1 prips | sed -n '/^[0-9]/p' | sed 's/$/ Spamhaus IP/' > $tl_dir/emerging_threats_spamhaus_drop_ips.tmp

echo "# Generated: `date`" > $tl_dir/emerging_threats_dshield_ips.txt

cat $tl_dir/emerging-Block-IPs.txt | sed -e '1,/#Dshield Top Attackers/d' -e '/#/,$d' | xargs -n 1 prips | sed -n '/^[0-9]/p' | sed 's/$/ Dshield IP/' > $tl_dir/emerging_threats_dshield_ips.tmp

rm $tl_dir/emerging-Block-IPs.txt

#==============================================================================
#Emerging Threats - Compromised IP List
#==============================================================================

wget http://rules.emergingthreats.net/blockrules/compromised-ips.txt -O $tl_dir/compromised-ips.txt --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/emerging_threats_compromised_ips.txt

cat $tl_dir/compromised-ips.txt | sed -n '/^[0-9]/p' | sed 's/$/ Compromised IP/' > $tl_dir/emerging_threats_compromised_ips.tmp

rm $tl_dir/compromised-ips.txt

#==============================================================================
#Binary Defense Systems Artillery Threat Intelligence Feed and Banlist Feed
#==============================================================================

wget http://www.binarydefense.com/banlist.txt -O $tl_dir/binary_defense_ips.txt --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/binary_defense_ban_list.txt

cat $tl_dir/binary_defense_ips.txt | sed -n '/^[0-9]/p' | sed 's/$/ Binary Defense IP/' > $tl_dir/binary_defense_ban_list.tmp

rm $tl_dir/binary_defense_ips.txt

#==============================================================================
#AlienVault - IP Reputation Database
#==============================================================================

wget https://reputation.alienvault.com/reputation.snort.gz -P $tl_dir --no-check-certificate -N

gzip -d $tl_dir/reputation.snort.gz

echo "# Generated: `date`" > $tl_dir/av_ip_rep_list.txt

cat $tl_dir/reputation.snort | sed -n '/^[0-9]/p' | sed "s/# //"> $tl_dir/av_ip_rep_list.tmp

rm $tl_dir/reputation.snort

#==============================================================================
#SSLBL - SSL Blacklist
#==============================================================================

wget https://sslbl.abuse.ch/blacklist/sslipblacklist.csv -O $tl_dir/sslipblacklist.csv --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/sslipblacklist.txt

cat $tl_dir/sslipblacklist.csv | sed -n '/^[0-9]/p' | cut -d',' -f1,3 | sed "s/,/ /" | sed 's/$/ SSLBL IP/' > $tl_dir/sslipblacklist.tmp

rm $tl_dir/sslipblacklist.csv

#==============================================================================
#ZeuS Tracker - IP Block List
#==============================================================================

wget https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist -O $tl_dir/zeustracker.txt --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/zeus_ip_block_list.txt

cat $tl_dir/zeustracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Zeus IP/' > $tl_dir/zeus_ip_block_list.tmp

rm $tl_dir/zeustracker.txt

#==============================================================================
#SpyEye Tracker - IP Block List
#SpyEye Tracker has been disconntinued. More information will follow soon on
#https://www.abuse.ch Thanks for all your support!
#==============================================================================

#wget https://spyeyetracker.abuse.ch/blocklist.php?download=ipblocklist -O $tl_dir/spyeyetracker.txt --no-check-certificate -N

#echo "# Generated: `date`" > $tl_dir/spyeye_ip_block_list.txt

#cat $tl_dir/spyeyetracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Spyeye IP/' > $tl_dir/spyeye_ip_block_list.tmp

#rm $tl_dir/spyeyetracker.txt

#==============================================================================
#Palevo Tracker - IP Block List
#Palevo Tracker has been discontinued
#==============================================================================

#wget https://palevotracker.abuse.ch/blocklists.php?download=ipblocklist -O $tl_dir/palevotracker.txt --no-check-certificate -N

#echo "# Generated: `date`" > $tl_dir/palevo_ip_block_list.txt

#cat $tl_dir/palevotracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Palevo IP/' > $tl_dir/palevo_ip_block_list.tmp

#rm $tl_dir/palevotracker.txt

#==============================================================================
#Malc0de - Malc0de Blacklist
#==============================================================================

wget http://malc0de.com/bl/IP_Blacklist.txt -O $tl_dir/IP_Blacklist.txt --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/malc0de_black_list.txt

cat $tl_dir/IP_Blacklist.txt | sed -n '/^[0-9]/p' | sed 's/$/ Malc0de IP/' > $tl_dir/malc0de_black_list.tmp

rm $tl_dir/IP_Blacklist.txt

#==============================================================================
#Ransomware Tracker - IP Block List
#added by https://github.com/mary-cordova 
#==============================================================================

wget https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt -O $tl_dir/ransomwaretracker.txt --no-check-certificate -N

echo "# Generated: `date`" > $tl_dir/ransomwaretracker_ip_block_list.txt

cat $tl_dir/ransomwaretracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Ransomware Tracker/' > $tl_dir/ransomwaretracker_ip_block_list.tmp

rm $tl_dir/ransomwaretracker.txt

#==============================================================================
#Appending only new IPs from .tmp to the Splunk monitored .txt files 
#added by https://github.com/mary-cordova 
#==============================================================================

for i in `ls $tl_dir/*.tmp | sed 's/\.tmp//g'`
do

awk '!seen[$0]++' $i.txt $i.tmp > $i.append
diff -p $i.txt $i.append | sed -n 's/+ //gp' >> $i.txt
rm $i.tmp
rm $i.append

done
