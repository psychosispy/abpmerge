#!/bin/sh

# 下载规则
curl -o i-jiekouAD.txt https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt
curl -o i-adt-chinalist-easylist.txt http://sub.adtchrome.com/adt-chinalist-easylist.txt
curl -o i-cjx-annoyance.txt https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt
curl -o i-rule.txt https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt
curl -o i-mv.txt https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt
curl -o i-easylist.txt https://easylist-downloads.adblockplus.org/easylist-minified.txt
curl -o i-AdGuard_china.txt https://filters.adtidy.org/extension/ublock/filters/104_optimized.txt
curl -o i-ADgk.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
curl -o i-antiadblockfilters.txt https://easylist-downloads.adblockplus.org/antiadblockfilters.txt
curl -o i-CN.txt https://raw.githubusercontent.com/Crystal-RainSlide/AdditionalFiltersCN/master/CN.txt
curl -o i-Intl.txt https://raw.githubusercontent.com/Crystal-RainSlide/AdditionalFiltersCN/master/Intl.txt
curl -o i-AdGuard_Annoyances.txt https://filters.adtidy.org/extension/ublock/filters/14_optimized.txt
curl -o wlist.txt https://raw.githubusercontent.com/psychosispy/abpmerge/main/wlist.txt


# 合并规则并去除重复项
cat i*.txt > i-mergd.txt
cat i-mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > i-tmpp.txt
sort -n i-tmpp.txt | uniq > i-raw.txt

grep -vFf wlist.txt i-raw.txt > i-tmp.txt

python rule.py i-tmp.txt

# 计算规则数
num=`cat i-tmp.txt | wc -l`

# 添加标题和时间
echo "[Adblock Plus 2.0]" >> i-tpdate.txt
echo "! Title: ABP Merge Rules" >> i-tpdate.txt
echo "! Description: 该规则合并自jiekouAD，，乘风视频广告过滤规则，Easylist+China_optimized，ChinaList+EasyList(修正)，CJX'sAnnoyance，Adblock Warning Removal List以及补充的一些规则" >> i-tpdate.txt
echo "! Homepage: https://github.com/psychosispy/abpmerge" >> i-tpdate.txt
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> i-tpdate.txt
echo "! Total count: $num" >> i-tpdate.txt
cat i-tpdate.txt i-tmp.txt > abpmerge.txt

cat "abpmerge.txt" | grep \
-e "\(^\|\w\)#@\?#" \
-e "\(^\|\w\)#@\??#" \
-e "\(^\|\w\)#@\?\$#" \
-e "\(^\|\w\)#@\?\$?#" \
> "CSSRule.txt"

# 从 https://filters.adtidy.org/android/filters/2_optimized.txt 下载规则文件
# 移除包含 # 或 generichide 的行，然后生成 easylistnocssrule.txt 的修改版本到当前工作目录。

# 获取规则文件并将其存储在内存中
EASYLIST=$(wget -q -O - https://filters.adtidy.org/android/filters/2_optimized.txt)

# 移除包含 # 或 generichide 的行
echo "$EASYLIST" | grep -v "#" | grep -v "generichide" > EasyListnoElementRules.txt

# 将 EasyListnoElementRules.txt 复制到存储库中
cp EasyListnoElementRules.txt /path/to/repository/


# 删除缓存
rm i-*.txt

#退出程序
exit

