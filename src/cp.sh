#!/bin/bash


# CP側のメイン処理					
CP(){					
	echo 'CPのターン'				
	echo '----------'				
					
	# 1枚目を?で表示し、残りの引いたカードをそのまま表示する処理				
	text='?';				
	sum=0;				
	for((i=1; i < ${#cCards[@]}; i++));				
	do				
		text="$text ${cCards[i]}"			
		sum=$(($sum + ${cCards[i]}));			
	done				
	echo "$text sum:? + $sum"				
					
	# カードのドロー or パス処理				
	if `AI` ;then				
		# カードを1枚引く			
		c=${cards[0]}			
		echo $c'を引いた'			
		cCards=(${cCards[@]} ${cards[0]})			
		cards=(${cards[@]:1})			
		echo 'sum:? + '$(($sum + $c));			
		cPass=false			
	else				
		echo 'パス';			
		cPass=true			
	fi				
}					
					
#先攻後攻決め 0=Player 1=CP					
first=$(($RANDOM % 2));					
if [ $first = 0 ];then					
	echo 'Playerの先攻'				
else					
	echo 'CPの先攻'				
fi					
					
# メイン処理					
while true					
do					
	echo ''				
					
	# 先攻処理				
	if [ 0 != ${#cards[@]} ];then				
		if [ $first = 0 ];then			
			Player		
	else				
		CP			
	fi				
	else				
		# カードが無くなったので終了			
		break;			
	fi				
					
	echo ''				
					
	# 後攻処理				
	if [ 0 != ${#cards[@]} ];then				
		if [ $first = 1 ];then			
			Player		
		else			
		CP			
	fi				
	else				
		# カードが無くなったので終了			
		break;			
	fi				
	# お互いがパスしたのでゲーム終了				
	if $pPass && $cPass ;then				
		break;			
	fi				
done					
					
# 合計値取得					
resultP=`pSum`					
resultC=`cSum`					
					
# 判定					
echo 'ゲーム終了'					
echo '--------------------'					
echo '結果発表'					
echo '----------'					
if [ $resultP -lt 22 ] && [ $resultC -lt 22 ];then					
	# 両方ともバースしてない				
	if [ $resultP = $resultC ];then				
		echo "引き分け  Player=$resultP CP=$resultC";			
	elif [ $resultP -lt $resultC ];then				
		echo "CPの勝ち $resultC"			
		echo "Playerの負け $resultP";			
	else				
		echo "Playerの勝ち $resultP"			
		echo "CPの負け $resultC";			
	fi				
elif [ 21 -lt $resultP ] && [ 21 -lt $resultC ];then					
	# 両方ともバースした				
	echo "引き分け（両者バースト）  Player=$resultP CP=$resultC";				
elif [ 21 -lt $resultP ];then					
	# Playerのみがバースした				
	echo "CPの勝ち $resultC";				
	echo "Playerのバースト負け $resultP";				
elif [ 21 -lt $resultC ];then					
	# CPのみがバースした				
	echo "Playerの勝ち $resultP";				
	echo "CPのバースト負け $resultC";				
fi					
