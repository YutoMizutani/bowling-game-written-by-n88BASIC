1 'BOWLINGGAME.BAS

2 'Created by YutoMizutani on 2018/05/19.
3 'This software is released under the MIT License.


1 '--Main--------------------------------------------------------------

10 cls:screen 0,0,0,1
100 gosub *StoreData
200 gosub *PlayLogo
300 gosub *InputUserData
350 'userName$="Secret":userTrials=3 'Debug
400 gosub *DisplayData
450 *Trial
500 gosub *StartTrial
600 gosub *DecisionHitBall
800 if userTrials>0 then goto *Trial
900 gosub *Result
1000 end

10000 *StartTrial
10010 gosub *PlayGame
10020 userTrials=userTrials-1
10040 return

10100 *Result
10110 cls
10120 gosub *ResetStrLine
10125 strLine5$="				   RESULT"
10130 strLine12$="		Name: "+userName$+" 	  		Point: "+STR$(userPoint)
10140 gosub *PrintText
10150 return

19999 '--Constants & Variables------------------------------------------

20000 *StoreData
20010 scrWidth=640:scrHeight=400
20020 isTextChange=0
20030 tmpText0$="":tmpText1$="":tmpText2$=""
20035 tmpNum=1
20040 tmpTextLine=0:tmpTextLen=0
20050 gosub *ResetStrLine
20100 userName$=""
20110 userTrials=1
20120 userMovePosition=0 '�������ʒu
20130 userPoint=0
20140 secretParams=50:isUpSecParams=-1
20200 return

20300 *GetData
20310 if userName$="" then userName$="(NoName)"
20320 strLine0$="Name: "+userName$+",	Trials: "+STR$(userTrials)+", Point: "+STR$(userPoint)
20330 return

20999 '--DisplayData----------------------------------------------------
21000 *DisplayData
21001 cls
21002 gosub *ResetStrLine
21010 gosub *GetData
21020 gosub *DecisionTextChange
21030 gosub *PrintText
21040 return

21200 *PlayLogo
21229 'Load BMP image
21230 bload "logo.bmp",L(0)
21240 'visible
21241 for i=0 to L(0)/2+scrWidth/2
21242 cls
21250 put (i-L(0),scrHeight/2-L(1)/2),L(0),pset
21260 next i
21270 'sleep
21280 for i=0 to 2000:next i
21290 'hidden
21300 for i=0 to L(0)/2+scrWidth/2
21310 cls
21320 put (scrWidth/2-L(0)/2+i,scrHeight/2-L(1)/2),L(0),pset
21330 next i
21340 for i=0 to 1000:next i
21350 clear ,L
21560 return

21999 '--PlayGame----------------------------------------------------

22000 *PlayGame
22010 gosub *LoadGame
22020 gosub *DisplayGame
22030 gosub *MoveMan
22040 gosub *ThrowBall
22900 return

23000 *LoadGame
23100 'Load BMP images
23200 'Load Man
23210 bload "pose_kyosyu_boy.bmp",M(0)
23230 userMovePosition=(scrWidth/2-M(0))/2
23300 'Load Pins
23310 bload "bowling_pins.bmp",P(0)
23320 'Load Balls
23330 bload "bowling_ball.bmp",B(0)
23340 'Load Strike
23350 bload "bowling_strike.bmp",S(0)
23400 return

24000 *DisplayGame
24010 gosub *PrintPlayingText
24100 put (userMovePosition,scrHeight/10),M(0),pset
24110 put (scrWidth/2+(scrWidth/2-P(0))/2,scrHeight/10),P(0),pset
24120 gosub *PrintLine
24900 return

25000 *PrintPlayingText
25010 cls
25020 gosub *GetData
25030 strLine1$="	 (�R�}���h ����:�ړ�, ����:�J�[�u, Enter:������)"
25040 isTextChange=-1:gosub *PrintText
25050 return

25100 *PrintLine'���S��������
25110 line(scrWidth/2-2,scrHeight/10)-(scrWidth/2+2,scrHeight),,BF
25120 return

25300 *DisplaySecPara
25330 line(scrWidth/100-2,scrHeight/10-2)-(scrWidth/100*2+2,scrHeight/10+100+2),,BF
25340 line(scrWidth/100,scrHeight/10)-(scrWidth/100*2,scrHeight/10+100-secretParams),0,BF
25390 return

26000 *MoveMan
26001 'Enter�Ŕ������ہA�P���̓��͂œ�����������
26002 '	*MoveMan��Enter�I��+��func�������s
26008 gosub *DisplaySecPara
26010 moveLen=10:moveMin=0:moveMax=scrWidth/2-M(0)
26020 gosub *MoveManLoop:return
26100 *MoveManLoop
26200 inputText=inkey$
26210 if inputText="" then goto *MoveManLoop
26220 if inputText="4" then goto *MoveLeft
26230 if inputText="6" then goto *MoveRight
26235 if inputText="2" then goto *MoveUp
26236 if inputText="8" then goto *MoveDown
26240 if inputText=chr$(29) then goto *MoveLeft
26250 if inputText=chr$(28) then goto *MoveRight
26255 if inputText=chr$(30) then goto *MoveUp
26256 if inputText=chr$(31) then goto *MoveDown
26260 if inputText=chr$(13) then return
26270 goto *MoveManLoop
26300 *MoveLeft
26310 if userMovePosition-moveLen<moveMin then goto *MoveManLoop
26315 userMovePosition=userMovePosition-moveLen
26320 gosub *DisplayGame:gosub *DisplaySecPara:goto *MoveManLoop
26400 *MoveRight
26410 if userMovePosition+moveLen>moveMax then goto *MoveManLoop
26415 userMovePosition=userMovePosition+moveLen
26420 gosub *DisplayGame:gosub *DisplaySecPara:goto *MoveManLoop
26510 *MoveDown
26512 secretParams=secretParams-5
26513 if secretParams<1 then secretParams=0:goto *MoveManLoop
26519 gosub *DisplayGame:gosub *DisplaySecPara:goto *MoveManLoop
26520 *MoveUp
26530 secretParams=secretParams+5
26540 if secretParams>99 then secretParams=100:goto *MoveManLoop
26550 gosub *DisplayGame:gosub *DisplaySecPara:goto *MoveManLoop
26600 return

27000 *ThrowBall
27020 bload "bowling_man.bmp",M(0)
27025 screen 0,0,0,1:gosub *DisplayGame
27030 for i=0 to 30
27031 if i mod 2 = 0 then screen 0,0,0,1 else screen 0,0,1,2
27040 gosub *DisplayGame
27050 put (userMovePosition-B(0)+i*(secretParams-50)/10,scrHeight/10+M(1)/2+i*10),B(0),pset
27060 next i
27300 return

28000 *DecisionHitBall
28010 screen 0,0,0,1:gosub *DisplayGame
28020 iMax=15
28030 for i=0 to iMax
28031 if i mod 2 = 0 then screen 0,0,0,1 else screen 0,0,1,2
28040 gosub *DisplayGame
28050 put (scrWidth-(userMovePosition+i*(secretParams-50)/10),scrHeight/10*9-M(1)/2-i*10),B(0),pset
28060 next i
28070 screen 0,0,0,1
28100 *HitTest
28110 ballMinX=scrWidth-(userMovePosition+iMax*(secretParams-50)/10)
28111 ballMaxX=ballMinX+B(0)
28120 pinMinX=scrWidth/2+(scrWidth/2-P(0))/2
28121 pinMaxX=pinMinX+P(0)
28200 if ballMinX-5<scrWidth/4*3 then if ballMaxX+5>scrWidth/4*3 then gosub  *HitStrike:return
28210 if ballMinX-5-P(0)/3<scrWidth/4*3 then if ballMaxX+15+P(0)/3>scrWidth/4*3 then gosub  *HitSix:return
28220 if ballMinX-5-P(0)/2<scrWidth/4*3 then if ballMaxX+15+P(0)/2>scrWidth/4*3 then gosub  *HitTwo:return
28500 return

28600 *HitStrike
28610 screen 0,0,0,1:gosub *DisplayGame
28620 put (scrWidth/4*3-S(0)/2,scrHeight/10),S(0),pset
28640 userPoint=userPoint+20
28645 for i=0 to 5000:next
28650 gosub *HitEnd:return

28700 *HitSix
28740 userPoint=userPoint+6
28750 gosub *HitEnd:return

28800 *HitTwo
28830 userPoint=userPoint+6
28850 gosub *HitEnd:return

28900 *HitEnd
28940 for i=0 to 5000:next
28950 return

29999 '--InputUserDataFunc----------------------------------------------
30000 *InputUserData
30001 gosub *InputUserName
30020 gosub *InputUserTrials
30060 return

30100 *InputUserName
30101 cls
30102 gosub *ResetStrLine
30105 strLine0$="�E���O����"
30110 strLine1$="	 (�R�}���h BackSpase:�폜, Enter:����)"
30120 tmpTextLine=3
30130 tmpText0$="Name: ":tmpText1$="":tmpText2$="_"
30140 gosub *InputText
30150 userName$=tmpText1$
30170 return

30200 *InputUserTrials
30201 cls
30202 gosub *ResetStrLine
30205 strLine0$="�E���s���ݒ�"
30210 strLine1$="	 (�R�}���h 1-9:����)"
30220 tmpTextLine=3
30230 tmpText0$="Number of trials: [":tmpText1$="1":tmpText2$="]"
30240 gosub *InputSingleNum
30250 userTrials=tmpNum
30260 return

59999 '--PrintTextSubroutine--------------------------------------------

60000 *ResetStrLine
60001 tmpTextLine=100'���݂��Ȃ����l
60002 for i=0 to 2:tmpText(i)="":next i
60011 strLine0$ = "":strLine1$ = "":strLine2$ = "":strLine3$ = ""
60012 strLine4$ = "":strLine5$ = "":strLine6$ = "":strLine7$ = ""
60013 strLine8$ = "":strLine9$ = "":strLine10$ = "":strLine11$ = ""
60014 strLine12$ = "":strLine13$ = "":strLine14$ = "":strLine15$ = ""
60015 strLine16$ = "":strLine17$ = "":strLine18$ = "":strLine19$ = ""
60016 strLine20$ = "":strLine21$ = "":strLine22$ = "":strLine23$ = ""
60017 strLineOld0$ = "":strLineOld1$ = "":strLineOld2$ = ""
60018 strLineOld3$ = "":strLineOld4$ = "":strLineOld5$ = ""
60019 strLineOld6$ = "":strLineOld7$ = "":strLineOld8$ = ""
60020 strLineOld9$ = "":strLineOld10$ = "":strLineOld11$ = ""
60021 strLineOld12$ = "":strLineOld13$ = "":strLineOld14$ = ""
60022 strLineOld15$ = "":strLineOld16$ = "":strLineOld17$ = ""
60023 strLineOld18$ = "":strLineOld19$ = "":strLineOld20$ = ""
60024 strLineOld21$ = "":strLineOld22$ = "":strLineOld23$ = ""
60025 return

60100 *InsertStrLine
60110 tmpTexts$ = tmpText0$+tmpText1$+tmpText2$
60111 if tmpTextLine = 0 then strLine0$ = tmpTexts$:return
60112 if tmpTextLine = 1 then strLine1$ = tmpTexts$:return
60113 if tmpTextLine = 2 then strLine2$ = tmpTexts$:return
60114 if tmpTextLine = 3 then strLine3$ = tmpTexts$:return
60115 if tmpTextLine = 4 then strLine4$ = tmpTexts$:return
60116 if tmpTextLine = 5 then strLine5$ = tmpTexts$:return
60117 if tmpTextLine = 6 then strLine6$ = tmpTexts$:return
60118 if tmpTextLine = 7 then strLine7$ = tmpTexts$:return
60119 if tmpTextLine = 8 then strLine8$ = tmpTexts$:return
60120 if tmpTextLine = 9 then strLine9$ = tmpTexts$:return
60121 if tmpTextLine = 10 then strLine10$ = tmpTexts$:return
60122 if tmpTextLine = 11 then strLine11$ = tmpTexts$:return
60123 if tmpTextLine = 12 then strLine12$ = tmpTexts$:return
60124 if tmpTextLine = 13 then strLine13$ = tmpTexts$:return
60125 if tmpTextLine = 14 then strLine14$ = tmpTexts$:return
60126 if tmpTextLine = 15 then strLine15$ = tmpTexts$:return
60127 if tmpTextLine = 16 then strLine16$ = tmpTexts$:return
60128 if tmpTextLine = 17 then strLine17$ = tmpTexts$:return
60129 if tmpTextLine = 18 then strLine18$ = tmpTexts$:return
60130 if tmpTextLine = 19 then strLine19$ = tmpTexts$:return
60131 if tmpTextLine = 20 then strLine20$ = tmpTexts$:return
60132 if tmpTextLine = 21 then strLine21$ = tmpTexts$:return
60133 if tmpTextLine = 22 then strLine22$ = tmpTexts$:return
60134 if tmpTextLine = 23 then strLine23$ = tmpTexts$:return
60135 return

60200 *DecisionTextChange
60210 isTextChange=0
60211 if strLine0$ <> strLineOld0$ then isTextChange=-1:return
60212 if strLine1$ <> strLineOld1$ then isTextChange=-1:return
60213 if strLine2$ <> strLineOld2$ then isTextChange=-1:return
60214 if strLine3$ <> strLineOld3$ then isTextChange=-1:return
60215 if strLine4$ <> strLineOld4$ then isTextChange=-1:return
60216 if strLine5$ <> strLineOld5$ then isTextChange=-1:return
60217 if strLine6$ <> strLineOld6$ then isTextChange=-1:return
60218 if strLine7$ <> strLineOld7$ then isTextChange=-1:return
60219 if strLine8$ <> strLineOld8$ then isTextChange=-1:return
60220 if strLine9$ <> strLineOld9$ then isTextChange=-1:return
60221 if strLine10$ <> strLineOld10$ then :isTextChange=-1:return
60222 if strLine11$ <> strLineOld11$ then :isTextChange=-1:return
60223 if strLine12$ <> strLineOld12$ then :isTextChange=-1:return
60224 if strLine13$ <> strLineOld13$ then :isTextChange=-1:return
60225 if strLine14$ <> strLineOld14$ then :isTextChange=-1:return
60226 if strLine15$ <> strLineOld15$ then :isTextChange=-1:return
60227 if strLine16$ <> strLineOld16$ then :isTextChange=-1:return
60228 if strLine17$ <> strLineOld17$ then :isTextChange=-1:return
60229 if strLine18$ <> strLineOld18$ then :isTextChange=-1:return
60230 if strLine19$ <> strLineOld19$ then :isTextChange=-1:return
60231 if strLine20$ <> strLineOld20$ then :isTextChange=-1:return
60232 if strLine21$ <> strLineOld21$ then :isTextChange=-1:return
60233 if strLine22$ <> strLineOld22$ then :isTextChange=-1:return
60234 if strLine23$ <> strLineOld23$ then :isTextChange=-1:return
60235 return

60300 *PrintText
60302 if isTextChange <> -1 then return
60303 gosub *RenewalOldValue
60304 cls
60311 print strLine0$
60312 print strLine1$
60313 print strLine2$
60314 print strLine3$
60315 print strLine4$
60316 print strLine5$
60317 print strLine6$
60318 print strLine7$
60319 print strLine8$
60320 print strLine9$
60321 print strLine10$
60322 print strLine11$
60323 print strLine12$
60324 print strLine13$
60325 print strLine14$
60326 print strLine15$
60327 print strLine16$
60328 print strLine17$
60329 print strLine18$
60330 print strLine19$
60331 print strLine20$
60332 print strLine21$
60333 print strLine22$
60334 print strLine23$
60335 return

60400 *RenewalOldValue
60411 strLineOld0$ = strLine0$
60412 strLineOld1$ = strLine1$
60413 strLineOld2$ = strLine2$
60414 strLineOld3$ = strLine3$
60415 strLineOld4$ = strLine4$
60416 strLineOld5$ = strLine5$
60417 strLineOld6$ = strLine6$
60418 strLineOld7$ = strLine7$
60419 strLineOld8$ = strLine8$
60420 strLineOld9$ = strLine9$
60421 strLineOld10$ = strLine10$
60422 strLineOld11$ = strLine11$
60423 strLineOld12$ = strLine12$
60424 strLineOld13$ = strLine13$
60425 strLineOld14$ = strLine14$
60426 strLineOld15$ = strLine15$
60427 strLineOld16$ = strLine16$
60428 strLineOld17$ = strLine17$
60429 strLineOld18$ = strLine18$
60430 strLineOld19$ = strLine19$
60431 strLineOld20$ = strLine20$
60432 strLineOld21$ = strLine21$
60433 strLineOld22$ = strLine22$
60434 strLineOld23$ = strLine23$
60435 return

60500 *InputText
60510 gosub *InputTextLoop:userName$=tmpText$:return
60511 *InputTextLoop
60512 gosub *InsertStrLine
60513 gosub *DecisionTextChange
60514 gosub *PrintText
60515 inputText=inkey$
60516 if inputText="" then goto *InputTextLoop
60517 'BackSpase:chr$(8), Enter:chr$(13)<-(D)�śƂ����B
60518 if inputText=chr$(8) then gosub *TextDelete:goto *InputTextLoop
60519 if inputText=chr$(13) then return
60522 tmpTextLen = len(tmpText(1)):if tmpTextLen > 20 then goto *InputTextLoop
60523 tmpText1$=tmpText1$+inputText
60524 goto *InputTextLoop

60600 *TextDelete
60610 length = len(tmpText1$):if length = 0 then return
60611 tmpText1$ = left$(tmpText1$,length-1)
60612 return

60700 *InputSingleNum
60710 gosub *InputSingleNumLoop:return
60711 *InputSingleNumLoop
60712 gosub *InsertStrLine
60713 gosub *DecisionTextChange
60714 gosub *PrintText
60715 inputText=inkey$
60716 if inputText="" then goto *InputSingleNumLoop
60718 if inputText="1" then tmpNum=1:tmpText1$="1"
60719 if inputText="2" then tmpNum=2:tmpText1$="2"
60720 if inputText="3" then tmpNum=3:tmpText1$="3"
60721 if inputText="4" then tmpNum=4:tmpText1$="4"
60722 if inputText="5" then tmpNum=5:tmpText1$="5"
60723 if inputText="6" then tmpNum=6:tmpText1$="6"
60724 if inputText="7" then tmpNum=7:tmpText1$="7"
60725 if inputText="8" then tmpNum=8:tmpText1$="8"
60726 if inputText="9" then tmpNum=9:tmpText1$="9"
60727 if inputText=chr$(13) then if tmpNum>0 then return
60739 goto *InputSingleNumLoop
