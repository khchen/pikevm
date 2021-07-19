#!/bin/sh

regex="\
abc
cde
abc*
abc*
abc+
abc+
(([0-9]*)([a-z]*)[0-9]*)
([0-9]*)(([a-z]*)([0-9]*))
(([0-9]*)(?:[a-z]*)[0-9]*)
(?:[0-9]*)(([a-z]*)(?:[0-9]*))
([0-9]*)(?:([a-z]*)(?:[0-9]*))
(?:)
1?:
[0-9]+
[a-zA-Z0-9_]+
(([0-9]*)([a-z]*)[a-zA-Z0-9_]*)
[a]*
([yab]*)(e*)([cd])
([yab]*)(e*)([^y]?)$
[-]*
[-a]*
[-ab]*
[-a-c]*
[a-]*
[ab-]*
[a-c-]*
(\\\?:)
\\\(?:
[^a]*b
a{5}
[^a]{1,3}
(abc+){5}|[0-9]{1,}
(abc+){5}|[0-9]{1,}
b[^c]*
۱۲۳۴۵۶۷۸۹۰
[йцукен]
日本語*
([^ひらがな])|(な+)
([^ひらがな])|(な+)
([^abc])|(a+)
[a-g]+
[а-г]+
called|chief|dust|familiar|forth|waif|campaign|divers|smile|notice|kill|human|stands|nightshade|dollar|doughty|gloaming|twist|July|officers|wrest|coop|one|ability|welcome|significance|writer|spring|it's|helped|set|Paris|from|coomb|stay|hummock|taken|anon|makes|boat|nearly|am|justice|further|expression|contemporary|sooth|order|about|question|lived|apply|educational|of|night|satisfy|opened|never|success|until|visit|promise|parts|beneath|matter|typical|bade|apartment|rapidly|primary|bring|throat|hold|laws|understand|trade|desire|material|evidence|another|often|plash|model|someone|bond|hell|relationship|probably|exercise|performance|wants|known|countries|gammer|leeward|took|itself|representative|objection|aircraft
abc+h+d+f
([0-9]|abc){5}[0-9]+(grh)
"
input="\
abcdef
abcdef
abdef
abcccdef
abdef
abcccdef
1234hello567
1234hello567
1234hello568
1234hello568
1234hello568
1234hello568
1:
123abc456
123abc_456 abc
123hello456
a
xyac
xyac
--
-a-b
-a-b
-a-b-d-
-a-b
-a-b
-a-b-d-
:
(:
hhagbdbdbjsjjjda
aaaaaaaa
vbcvb
abcabcabcabcabcabchsdfhsdh
62374623
djfjgjsdfjbshdhfhshd
۱۲۳۴۵۶۷۸۹۰
ке
日本語語語語語語語本本本本
なななな
abc
aaaa
aaaabcdefghij
ааааабвг...
hhfd h23  performance
abcccccccccccchdf
344444442344grhhhsdfg
"
expect="\
(0,3)
(2,5)
(0,2)
(0,5)
-nomatch-
(0,5)
(0,12)(0,12)(0,4)(4,9)
(0,12)(0,4)(4,12)(4,9)(9,12)
(0,12)(0,12)(0,4)
(0,12)(4,12)(4,9)
(0,12)(0,4)(4,9)
(0,0)
(0,2)
(0,3)
(0,10)
(0,11)(0,11)(0,3)(3,8)
(0,1)
(1,4)(1,3)(3,3)(3,4)
(1,4)(1,3)(3,3)(3,4)
(0,2)
(0,3)
(0,4)
(0,5)
(0,3)
(0,4)
(0,5)
-nomatch-
(0,2)
(3,9)
(0,5)
(0,3)
(0,15)(12,15)
(0,8)(?,?)
(10,20)
(0,20)
(0,2)
(0,27)
(0,12)(?,?)(0,12)
(0,1)(0,1)(?,?)
(0,4)(?,?)(0,4)
(0,10)
(0,16)
(10,21)
(0,17)
(0,15)(4,5)(12,15)
(0,0)
"
c=1
echo "$regex" | tr '\n' | while read re; do
	inp=$(echo "$input" | awk -v c=$c 'BEGIN{ RS = "" ; FS = "\n" }{print $c}')
	exp=$(echo "$expect" | awk -v c=$c 'BEGIN{ RS = "" ; FS = "\n" }{print $c}')
	var=$(./a.out "$re" "$inp")
	if [ "$1" ]; then
	echo "$var"
	fi
	var1=$(echo "$var" | tail -1)
	if [ ! "$exp" = "$var1" ]; then
		echo "fail test$c regex:$re input:$inp expect:$exp output:$var1"
		exit 1
	fi
	time=$(echo "$var" | tail -2 | head -n1)
	echo "pass test$c regex:$re input:$inp expect:$exp output:$var1 $time"
	c=$((c+1))
done

