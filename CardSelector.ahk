#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Client
CoordMode, Pixel, Client
#Include FindText.ahk

; ==============================================================================
; === SETTINGS ===
; ==============================================================================
Global LogFile   := "CardLog.txt"
Global DebugMode := 0      ; 0 = Click Active. 1 = Log Only (No Click).
Global LoopState := 0      ; 0 = Off, 1 = On
Global Text_Upg0	 := "|<>*91$55.zzzlzzXU8zzzszznU7DzzkQTtlnXQ10A3wssk00U01yQQM60000zCCAQS0k0T776CD0M0DnXb7k200rtk3Xs10A3wy1ly0s71yTXt"
Global Text_Upg1	 := "|<>*88$61.zzzzzzzzzzzzzzzDzzryzzzzzbzzVm7zzzznzznkXzzzztzzlkN4mMb0sDtkC0M030M3ww70A41UAFyTXX6QMX48yDllXCAFm0T7ss1bUA1XznwQ0nk60k7tySkNwHmQ7wzDKDzzzzzyTz07zzzzzzbz47zzzzzztz7zzzzzzzzzz"
Global Text_Upg2  	 := "|<>*84$63.zzzzzzzzzzzzzzzDzzjzjzzzzlzzkkMTzzzyDzyA0XzzzzlzzXU6DzzzkC7wsMl11kA10Db778001001wwkt010000D7w7C1kk601sz1tkC60k0TbkT81s108Hww0t0D0A10DbU389y1kC3ww0tlzzzzzzXzyMTzzzzzyDzX7zzzzzztzsw"
Global Text_Max 	 := "|<>*92$55.zsHzDbnw7zwMz7Vkw1zwQD3kwAAvyS31kD0DAzD00s7kDaDbU0Q1s7n7nk0A0w3tXltVa0C1wnwwtm060SRySTs3U77AzDDw7s7VaTbbyHy7tnztzzzzzznk"
Global Text_SwitchUnits := "|<>*129$87.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzbzznzzwzzzzzwzkDzyAzzXzsyDzXA0zznXzwTz7lzwsXDzzwTzXzsyDzz4TbCH0sQ3z7l8wkUslW061U7sy81U61W4E0UA0z7l0A0s406AQPX7sy8lX7sU0lX3wQT7X74Mb606AQTXXsQMsX40kVlVUAQTU374MU76CA61XXw0ssX63tnnksQwzsDDAwzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
Global Spot_VoteSkip := {x: 1044, y: 178}
Global Text_RestartBtn := "|<>*147$53.w3zzzbzzzs3zzzDzzzk3zzyTzzzb63YwyHCTC830tk4QS0F60nUAFw12AtaAMXs20NnAMsDnWDk6A1sTb41UQ83kzDA79sMbXk"
Global Text_MenuAnchor := "|<>*85$55.zzzzzzzzzzzzzzzzznrtzzzzzzltszzzzzzswwTzzzzzwSSDzzzzzkCD43s470k47U0k000E03k08010001s30s730M0MFUA3VUA00M101s1080A1k4w0k4MS1w2TUQ3jzDzlzzzzw"
Global UncapW_Picked
Global Spot_MagicianPath := {x: 1234, y: 512}

; ==============================================================================
; === 1. SAFETY ANCHOR (YOU MUST FILL THIS) ===
; ==============================================================================
; Capture the "Time Left" or "Vote ends in" text.
; The script will NOT click anything unless it sees this first.
Global Anchor_CardScreen := "|<>*132$79.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzsztzzzzzzzzzzsDsTz7zzzzzzzw7wTzXzzzzzzzy1wDzlzzzs74Tk0yC3k70Ts1U3k0C60E30Ds0k1k17608377wQMEMEV3333XXyCA8A8MX3VXU1y06C6CA1lklk0z0373771sMMQTzlzXVV3Uw0Q20Ds0lkk1sz0D1U7y0MsQ0wTkTls7zUQST2Tzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk" ; <--- PASTE CODE HERE

; ==============================================================================
; === 2. CARD DATABASE ===
; ==============================================================================
Global Cards := []

; --- GOD TIER (1.0) ---
AddCard("IncFund",    "|<>*136$147.zzzzzzzzzzzz3zzzzzzzzzkwTzzzzzzzzzzzsTzzzzzzzzy7Xzzzzzzzzzzzy3z1UDzzzzzUsDzzzzzzzzzzzsTk81zzzzzy71zzzzzzzzzzzzXz10DzzzzzswzzzzzzzzzzzzwTw9lzzzzzz7zzzzzzzzzzzzzXzVCTzzzzzszy24T3s3y0z3z0Tw9n3Vkkzk730E1UD0DU7UDU3zlDsQC03s0sNX0Mks0skskssTy9zXls0SC7XAMT77z77b777XzlDwSD7XlswPn7lszssTlslxTy8DXlswQT7XTsyD7z71yD6Dvzl1wSD7XXswPz7k0zkw3k0lwTy9jXlswQT7XTsy0T07kC0SDXzlDwSD7XXswPz7lzkMzUlzlwTy9zXlswQT7XTsyDyD7j6DyDXzlDwSD7XXswNz7kzlstskzkwTy9zXlswQD7XDsz3yA7773z63zlDwAD7XlUwM33w0k0M1w0s0Ty3zk0sQC07V0sTkD330TkDVVzkTy373lsMQDzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw", 1.0)
AddCard("SBS",        "|<>*135$121.zzzzzzbzzzzzzzzzzzzzzzzzzU0Tzzzzzs1zzzzzzzzzzkMDzzzzzw0zzzzzzzzzzk83zzzzzw0Tzzzzzzzzzw4lzzzzzs0Dzzzzzzzzzz2MzzznzsD7bzzzzzzzzzVADzzlzw7XXzzzzj3XUzka73Vk7wVlUDky0nVkkTwH7Vkk3yETU7UD08swSDy9XswSDzA7wTX3U0QCD7z4XwSD7zX0yDllzk773bzW1yD7XzskD7lszs3XVnzl0T7Xlzy63XswTw1lklzsb7XlszzlVlw0Dw8skNzwHVlswTzwQsy0T00S9Azy9kswSDzjaQT7z1UT4WTz4sQSD7znvCDXzXkDUETzWQSD7Xzlxb7kzls7sMDzlCD33lzsz3XwDsk7wC7zs0Dk0s7w07kD0A0Dy77zw0Ds8S3y07w7kD37zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk", 1.0)

; --- HIGH TIER (0.6) ---
AddCard("THTF",       "|<>*135$111.zzzzzzzzzzzzzzzzzzzzzzzzzwDzzzzzzsTzz01zzzzz1zzzzs3v3zzvETzzzzsDzzzz0T8TzzG1zzzzzVzzzzs013zzuMDzzzzyDzzzz00ATzzHVzzzzzlzzzzw03XzzuQDzzzzyDzzzzwXwTzzHVs3sFw1z3kXz4zX3z2QD0D060DUC0Dlbw0DUHVs0w1XVsks3yAzU1smEDz7VwSD773zlbwCD7E1zswT7llsszyAzXllu0Dz7XsyCD77zlbwSCDHVzkwT7lk0szyAzXlk2QD07XsyC0T7zlbwSC0HVkMwT7llzszyAzXlluQSD7XsyCDz7zkbwSCDHXlswT3lkzszz4zXlkuQSA7XwMD3z7zsDwSD37Uk0QDU1w0sTzU3Vlw0y733Vy67kD3zy0QCDkzzzzzzzzzzzzzzzzlzzzzzzzzzzzzzzzzzyDzzzzzzzzzzzzzzzzznzw", 0.6)
AddCard("UncapW",     "|<>*134$105.zzzzzzzzzzy3zzzzzzzzzzzzzzzzkD1Va3zzzzzzzzzzzy3wAAkTzzzzzzzzzzzsT1Ua1zzzzzzzzzzzzXw44sTzzzzzzzzzzzwTkkbXzzzzzzzzzzzzXy64QTsA1wAT37z3z0TksX3s1U7U1s0TUDU3z72Mw6A0S07U1skssTsMH76lzXkswCD767Xz32MszDwSD3XklslwTsQH6DzzXlsQS6D6DXzXWFlzzsSD3Xkk0lwTwQMC0zU3lsQS60SDXzVX1k7sASD3XklzlwTyA8CDz7XlswSCDyDXzll3lzswSD7XlkzkwTyC8S7z63lswSD3z63zlk3sM80C0DU3w0s0Tz00zU3VVk7w1zkDVVzw0Dy7zzyDzXzzzzzzzzzzzzzzlzwTzzzzzzzzzzzzzyDzXzzzzzzzzzzzzzzlzwTzzzzzzzzzzw", 0.6)
AddCard("Accurate",   "|<>*146$87.03zzzzzzzzzzzzs0DzzzzzzzzztzzHXzzzzzzzzzyDzuQTsTVXkslUDUDkHXw1k4C70A0s1w2QT6AMlsw1U7lyAHXslX6D7XzwSDlmQSDMxlswTzXlwSE3lz7yD7XzwSDXm0SDszlswTz3lw0HXlz7yD7Xw0SDU+QSDszlswT3XlwTHXlz7yD7XswSDXuQS7sTlswT7XlyDHXszXyC7XssSDksw70A0s0QDU1kD07kw3kDVXVwAD1w4", 0.6)
AddCard("Corruption", "|<>*135$79.zzzzzzzzzzz1zzzzzzzzzzzzUzzzzzzzzzzzzkTzzzzzzzzzzzwTzzzzzzzzzztzzzzzzzzzzzzszzzUy4EW73VXs33y0D0003Vk0s1Vw73k60lsw0D7swPlsT3swS77XwSDsQTXwSD7VlyCDwCDlyD7Xksz77y77sz7XlsQTXXzXXwTXlswCDllzVlyDlswS77sszlsz7swSD7XwQRswTXwSD7XlyC6wSDly67Xlsz7X0T3sTU1k1w3Vs0zVwDkEs3z1kyDzzzzzzwTzzzzzzzzzzzyDzzzzzzzzzzzz7zzzzzzzzzzzzXzzzzzzzzzzzzkzzzzzk", 0.6)
AddCard("Weakened",   "|<>*136$83.zzzzzzzzzzzzzzzzzzzz3zzzzzzzzzzzzy7zzzzzzyMDzzzwDzzzzzzokDzzzsTzzzzzzdkzzzzszzzzzzzHlzzzzlzzzzzzyXXzzzzXzzzzzzxa7ky0z67y7VVzXAS0w0y87k701w2Msks0w0D6703lYlllzlsQSCCD7X9X7XzXlswQSCCGCD7z7XllsswQQkQ0DwD67U1lss1Us1w0S8T0DXlk11lzkMwFyDz7XXW7XzXlslwTyD774D3z7XlVsTwSC60T3yA7XVsTswS41z0A073Vs1ksS07z0wAC7Xs7VsyDzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", 0.6)

; --- GOOD TIER (0.5) ---
AddCard("Mirrored",   "|<>*134$103.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzszzzzzzzzzzkTUsD1sDzzzzzzzzzs7kQ7Uw7zzzzzzzzzw7kA3UC3zzzzzzzzzz3w40U7Xzzzzzzzzzzlz2MH3zzzzzzzzzzzszVC9lzzzzzzzzzzzwTkb4ssQ8V7kT2DVzUDsHWQQC001U7U30T07y9lCD7UA1XVs36773z4sb7Xky7lswDXX3lzWQHXlsz7lwCDXlXszlC9lswTXsy77lslwTsb4swSDlwT3Xs0MyDwHWQSD7syDllw0wT7y9lCD7XwT7ksyDyDXz4sb7XlyDXsQT7z7lzWQHXlsz7kwSDVzVszlC9lswTXwSD7sTskTsD0sQC7kz0DVy0Q0Dw7Uw673sTkTkzUT33zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw", 0.5)
AddCard("Toxic",      "|<>*128$69.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz7zzzs1lzzzzkTzzy007zzzw1zzzk00zzzzUDzzz00Dzzzz7zzzw01zzzzzzzzzs1zzzzzzzzzz0zw7VkEzUzzkby0Q627k7zyAzX1ksswEzzlbsSD27737zyAz3lwFssMzzlbsyDUT77zzyAz7ky7sszzzlbsy7kz77zzyAz7kw3sszzzkbsy7YT77zzz4z3lslssTzzsDwSCC77XzzzU3U3UsMQ0zzy0T1w7X3kDzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw", 0.5)
AddCard("BadB",       "|<>*134$101.nzzzzUzztzVzzzzzy0zzzz0zU0S1zzzzzz1zzzy3z1Uy7zzzzzw1zzzy7w20wDzzzzztXzzzyDw4lwTzzzzzn7zzzwTw9Xszzzzzza7zzzszsH3lzzzzzzAD0Tw1zka7Xy3zUzuMy0TU3zVAT7k3w0z4lw0SC7zWMyD73lkwN7zssSDz4XwSD7XlkkDzllwTy87ssy6DVXUDzXXszwE7llwAT37CDy77lzsb7XXsMy6CQC0CDXzlC777slyAQsMAQT7zWQCCDVXsMtklssyDz4sQQT37klnVXlkwTy9kssSC7XVb763lUzwHXlswSD7W0S03U1zs0DVs1y0T01y67VVzk0z3sDy3z7zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU", 0.5)
AddCard("Binoculars", "|<>*136$91.TwTzzzzzzzzkzzzzyDzzzzzzzzsTzzly3zzzzzzzzwDzzsD1zzzzzzzzy7zzz7nzzzzzzzzzXzzzXzzzzzzzzzzlzzzkzzzzzzzzzzszzzsQC67y3zUVkwS0yAS701w0z0EsSD0D6DXk0wQD6ASD7U3mDlswSD7X6D7Xzls7swSCDVXn7Xlzsw1wSD77klzXlszwSQSD7XXsMzlswTwDC77XllyATswSD07b3Xlssz6DwSD71XnVlswQT77yD7XXltlswSC7XVz7XllswswSD7XlszVVsskS0y73Vs1w0s0QA070z3Vsy3z0w6C733bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk", 0.5)
AddCard("Plague",     "|<>*141$67.C3kzzzzzzzzW0MTzzzzzzzlCCDzzzzzzzsb37zzzzzzzwHVXzzzzzzzy9kls3zUQC7w4sMw0z0673w2QAS0T73XlslC6Dz7XVlswMb77zXXkswQQFXXzllswSC087lzkswSD704Dsw0QSD7XU2TwQCCD7XlllDyCD73Xlsssbz77XllswQAHzXX1sEwQD23zkk0S2T03k1zsQADXDklwTzzzzz7bzzzzzzzzz7Xzzzw", 0.5)
AddCard("Statis",     "|<>*146$73.zsSDDzzzzzzzzsD77zzzzzzzzt7n0Q1zUMzUTwVz0C0T0AD0DyMDsz0Db77b7za3wTzXXnXXnzlUSDzlkzlkzzwA77zssDssDzzX3XzsS1wS1zzstly0DkSDkTzTAsy77w77w7zbqQT7XrXXrXznvCDXlnllnlztzD7lktsstszw0DUQ0A0wQ0zy0DsC660y60zzzzzzzzzzzzz", 0.5)
AddCard("SharedVis",  "|<>*135$91.zzzzzzzVzzzyDzyTzzzzzzUy3C77zzDzzzzzzkTVa31zz7zzzzzzwDkn0UzzXzzzzzzz7s9ktzztzzzzzzzXy4wTzzzzzzzzzzlz2SDzzzw1w8y7y0zVC67k6C0S0A1w0Tsn73k3707UAMQQDwNXllVnzXkyCCD7y4lsswtzlsyD6DXz2MwQDwzswT7X7lzlAyC3yTsSDU1XszskT7UTC0D7k3lwTwMDXs7a37XszsyDy47lz1n7XlwTwT7zW7ststXlsy7y7XzlXwQwQlUwTVzX1zsFyCCCM0C7s1k0zy1z30DC673y1wADzVzVUDbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk", 0.5)
AddCard("SpyGlass",   "|<>*134$91.0zzzzzzk30zzzzzUTzzzzzs1UTzzzzkDzzzzzw0sTzzzzs7zzzzzy0QDzzzzw3zzzzzt0D7zzzzzlzzzzzsb7XzzzzzszzzzzwHblzzzzzwMMwC3w9nsw1z0S7w0C71y4zwS0T0C1z03Xtz2TyD0766ADVlkszXDz7zXXn63lsQQTlYTXzlkzVUswCCTsm3lzssDkMQS77DwN1szsS1w7CD3V7y4UwS0DUT1b7Vsbz2QSC37w7uHXlwHzlCD77XbXDVlsz3zs77XX1llXkswTVzw3XllUsslVw0Tkzz03sM0A0s1y0zsTzs7wC660w7z7zyDzzzzzzzzzzzXzzDzzzzzzzzzzzlzzbzzzzzzzzzzzszzXzzzzzzzzzzk", 0.5)
AddCard("Chippin",    "|<>*134$91.sTz7zzzzyDzz1zzU7z1zzzzy3zzUy067zUzzzzz1zzsz033zkTzzzzUzzwTU1lzwTzzzzszzyDs0szzzzzzzzzzzDy4QTzzzzzzzzzzzz2CAD3VXsMy733zzVD03Vk0w0D3U0zzkbU1sw0D03ls0TzsHkswS77VlswCDzw9swSD7VlsQSD7zy4wSD7XkswCD7Xzz2SD7XlsQS77XlzzVD7XlswCD3XlszzkbXlswS77VlswTzsHlswSD7XlswSDzw9swSD7XlswSD7zy4wSD7XlswSD7Xzz2S77Vk1w0T3VkzzkT3Xks3y0zVkwTzsDzlzwTz7zzzzzzzzzszyDzXzzzzzzzzzwzz7zlzzzzzzzzzyzzXzszzzzzzzzk", 0.5)
AddCard("Chromed",    "|<>*135$79.z3zzzzzzzzzzzVVzzzzzzzzzzzkkzzzzzzzzzzzsMTzzzzzzzzzzwCDzzzzzzzzzzz77zzzzzzzzzzzXXzzzzzzzzzzzllVsFw7kVkzsTzs0Q0M1s0EDk7rw0D0MsS003lVny77VwSD7Xlsstz7XlwT3XlsswMzXlsyDVlswQSATlswT7kswSC06DswSDXwQSD70D7wSD7lwCD7XXzXyD7XsyD7Xllzlz7XlwD7XlssTszXlsz7XlswS7y3kswDk3sQC7U71sQS7w7wC73s7rzyDzzzzzzzzzzzz7zzzzzzzzzzzzbzzzzzzzzzzzzrzzzzzzzzzzk", 0.5)
AddCard("Telescope",  "|<>*135$91.zzzzzzzzzzzzzzzzzzwDzzzzzzzzzzrnzy7zzzzzzzzzzvtzz3zzzzzzzzzzw0zzVzzzzzzzzzzy0Tzszzzzzzzzzzz0TzwTzzzzzzzzzzlzzyDzzzzzzzzzztzsT7wDk7sDUy6Dwzk7Xs3k3k70D03yTlVlsklVlX73k0xDssswQMwslXlsQSbswQQSADswXsQS6HwSCCD63wTlwCD39y07703USDsy77VYz0DXU7s77wTXXkmTXzllzz1XyDVlsNDlzssztslz7lswQbsTwQDwwMTVswSC7y7yD3yCCDswSD7U7U73k30D0C0T07s3s7Vw3UDkDUzUDzzzzzzzzzzzzzlzzzzzzzzzzzzzzszzzzzzzzzzzzzzwTzk", 0.5)
AddCard("Lambo",      "|<>*137$71.zzzzzzzzzzzztzzzzzzsTzzzzzzzzzzkzzzz|<>*137$71.zzzzzzzzzzzztzzzzzzsTzzzzzzzzzzkzzzzUTzzzzz1zzzv0zzzzzz3zzzY1zzzzzz7zzz8XzzzzzyDzzyFbzzzzzwTzzwXC0y6C7slzkN7w0w087k1y0GDs1w007U1ss4zzlswSD7Xls9zzXlswSD77kHzz7XlswS6DUrzwD7XlswATVjw0SD7XlsMz3TkMwSD7Xlly6zXlswSD7XXsRz7XlswSD73k3yA7XlswSD7U0A073Vks1z080QAC73Vk7z1zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", 0.5)
AddCard("50Cal",      "|<>*132$55.zzzzzzzzzzzzzzzrzzzzzzzzU3zzzzzzzs3zzzzzzzw1zzzzzzzm0zzyDzzzlATzk7yDzsaDzk3w1zsH70M1w0Tw9zU4zwS7y4zk0TyDXz2TzsDy7lzXDzw4T3szlbzy07VwTsHzy0VkyDw9zU3ssT7y4zUlwCDXzWTlsyD7lzlDswT7Xtzs7wMDXs0zy0C07Xy1zzU7VW3zzzzzzzy7zzzzzzzzDzzzzzzzzk", 0.5)
AddCard("HawkEye",    "|<>*132$83.zzzzzzzzzzzzzzzzzzzVzzzzzzzzzzzzy1zzz00Dzzzzzzw3zzw00DzzzzzzwDzzs40zzzzzzzwTzzs81zzzzzzzszzzsHXzzzzzzzlzzzkbDzy0wC63X3zzVCMQ40sQA743zz2Tks80swSC07zy4zlwzlkswQC7zy8DVlzXVktswTzwETXXz7XVnlss1sUz7DwD737X3k3lDyCQ0SA6T4DU7WTw8kMy94y8zzz4xwHXlwG9wMzzy9lsb7Xs43skzzwHXlCA7sMDlkzzsb7kw07ksTVkzzk0DVwADVlz3lzzU0T3zzzzzzzzzzzzz7zzzzzzzzzzzzyTzzzzzzzzzzzzwz", 0.5)
AddCard("MaxRep",     "|<>*135$79.zzzzzzzznzzzzy3zzzzzk07zzzz1zzzzzsA3zzzz0Tzzzzs40zzzx0Dzzzzy2ADzzya7zzzzzVC7zzzHXzzzzzkb3zzzdls3ksDsHVz3kosw0sQ7y9ky0s2QS0D77z4sSAC1CDz7V7zWQT772b7zXsXzl0T7XXHXzly3zsUTXlldlzkz3zwG7k0sosw0TVzy9Xs1wOQQ6DUTz4kwTyBCCD7mDzWQSDz6b77XlXzlCD3zXHXX1lkzsb3kzlVkk0EwDw7kw0s1sAA8D7y3sD0w7zzzzzzzzzzzyDzzzzzzzzzzzz7zzzzzzzzzzzzXzzzzzzzzzzzzlk", 0.5)
AddCard("TWC",        "|<>*136$99.zzzzszwDzzzxzzzzzzzzz7zVzzzzzzzzzzzzzkTsDzzzw3zzzzzzzy3zVzzzz0TzzzzzzztzyDzzz83zzzzzzzzzzlzzzlATzzzzzzzzzyDzzy9XzzztsQQ67w1z3zVAQ1w873VUky0DUDw9zU7U0QSD77XVskzVDw0S0XVlsswSD77wNzzXkwSC7D77llszXDzwSDXlktssyCD7wNzzXlwSC6D77lk0zXDzsSDXlUnssyC0Tw9zU3lwT4aT77llzzVDsASDXsYHssyCDzy9z7XlwT0Uz73lkzzlDswSDXwA7swMD3zy1z63lwDVkz3U1w0zs0s0C7VwCDsS67kDzU7VVkzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw", 0.4)

; --- TRASH TIER (-1.0) ---
AddCard("FailedTarget","|<>*134$127.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzXVzzzkTzzzzzzzzzzzzlzUUTzzs7s3lzzzzzzzzzkTkMTzzw7w1wzzzzzzzzzsDsADzzz3y00Tzzzzzzzzw7yD7zzzlz00Dzzzzzzzzz7zzXzzzszk0DzzzzzzzyTzzzlzzzwTz8zzzzzzzzyDzzVszVzUDz4zUDV7kDsS0ktkwT0T07z6Tk3k1U3k60MQwSD6773zXDw0w1XVlVlyDSD7XX3lzlbzwS7Vksssz7j7XXlXszsnzyD7lsMwQTXrXllslwTwNzz7XswASCDlvlss0MyDyAzz3lwS6077sxswQ0wT7z6Tk1syD30DXwSwSCDyDXzXDkMwT7VXzlyDSD77z7lzkbswSDVllzsz7j7XVzVszwHwSD7sssTwTXrXlsTskTy3yA7Xw0S7yDltksS0Q0DzU301kz0DU70sQsQDUT33zs1kksTlbs7kQCzzzzzzzzzzzzzzlnzzzzzzzzzzzzzzzzzzzltzzzzzzzzzzzzzzzzzzzlszzzzzw", -1.0)
AddCard("BTA",         "|<>*137$121.znzXzzzzzzzzzzzVzzzzzzzlzzzzzzzzzzzkzzzzsQDkTzzzzzzzz0z8Tzzzs41sTzzzzzzzzU04Dzzzy2MyTzzzzzzzzk037zzzzVATzzzzzzzzzy03Xzzzzka7zzzzzzzzzzmDlzzzzwH3Vz0zUTkw8zlDskzksS9Xky0D07UC0DlbwEDUAD4nwSC773X3UDsny07X37WFyD73XVllkzwNz3XllVl0z77VXkltszyAzXllsssUDXXklsMxwTz6TlsswQQHXllsMwA0SDzXDswQ0CC9lsswQSC0T7zlbwSC0T74sQQSCD77zXzsnyD77znWQCC773XXzlzw9z7XXztlCD7XXllkzszz4zXlkzwsb7Xk1s0wDwTzUzlswDzQ07kw0y0T0C7zs0sQT0Di07sT6TXDkD3zy0QCDkDrzzzz7DXbzzzzzzzz7zzzzzzz7bXnzzzzzzzzXzzzzzzz7XXlzzzzzzzznzzzzzzzVnktzzzzzzzzvzzzE", -1.0)
AddCard("PB",          "|<>*134$91.zzzzzzzzztzzzzzzzzzzzzzs07zzzzzzzzzzzzw63zzzzzzzzzzzzw20zzzzzzzzzzzzz1ATzzzzzzzzzzbzkaDzzzzzzzzzzXzsH3zzzzUy67y7UDw9VksT0ED01w1U7y4lsQD083k0wMQTzWMyD767lsQSCCDzl8z7XXnswSCD77zsUTXlkzwSD77XXzwE7lssDwD7XU1lzy9lswS1k7Xlk3szz4sQSDUNXlsszwTzWQCD7w7lswQTyDzlC77XbXswSC7z7zsb3XlnlkSD7VzXzwHXkkssU73Vs1kDy03w0A0n3Vsy1w7z03y260zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk", -1.0)
AddCard("SlowR",       "|<>*134$99.zzzzzzzzzzzzzzzzzzzzzznzzzzzzzzwTzzzzw01zzzzzzzz1zzzzzUkDzzzzzzzsDzzzzs40zzzzzzzz1zzzzzUX3zzzzzzzwTzzzzy4sTzzzzzyTzzzzzzkb3zzzzzzXzzsQQ7y4sTky0zs833z3VUzkb3s3k3w00MTQSD7z4sSAC0D6ATXnVlszsb7llzlklXwSAC7Dz41wSDyCDATXVlktzsUTXlzllzXwQCC6Dz4Vw0DwCDwTXVlUnzsaDU7k1lzXwQD4WTz4kwTw6CDwTXVsYHzsb7XzXllzXwQT0Uzz4swDwSC7wTXXwA7zsb3kzX1szXwSzVkzz1wD0A070A3VzwCDzsDUw3kkw3kQDzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw", -1.0)
AddCard("Investment", "|<>*136$95.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzDzzzzzzzzzzzzzzwTzzzzzzVVksDVy0k64C7z3l01VkQ1s10A087s3X03XtlVX3Xw007X3aD73XXX7b7swSD77ASD76D67yDlswQSCMwSCQSA7wTXlsswQlswQs0Q3sz7Xlk0tXlsFk3w3lyD7XU7n7XsbXzy3XwSD77zaD7lD7zj77swSCDzASDUS7ySCDlswQDyMwTVy7wQQTXlswDwksT3y0M1s73Vkw0tVsy7y1k7sC73Vw3nzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", -1.0)

; ==============================================================================
; === 3. ZONE CONFIGURATION (1920x1080) ===
; ==============================================================================
Global ZoneL := {x1: 530,  y1: 430, x2: 790,  y2: 510, name: "LEFT  ", clickX: 660,  clickY: 600}
Global ZoneM := {x1: 830,  y1: 430, x2: 1090, y2: 510, name: "MIDDLE", clickX: 960,  clickY: 600}
Global ZoneR := {x1: 1130, y1: 430, x2: 1390, y2: 510, name: "RIGHT ", clickX: 1260, clickY: 600}

; ==============================================================================
; === 4. HOTKEYS ===
; ==============================================================================

; F1::
;     LoopState := !LoopState
;     if (LoopState) {
;         SoundBeep, 750, 200
;         SetTimer, AutoPickLoop, 500 ; Check every 500ms
;         ToolTip, [AUTO] ON - Waiting for Cards...
;         SetTimer, ClearTip, -2000
;     } else {
;         SoundBeep, 300, 200
;         SetTimer, AutoPickLoop, Off
;         ToolTip, [AUTO] OFF
;         SetTimer, ClearTip, -2000
;     }
; return

; F3::
;     DebugMode := !DebugMode
;     MsgBox, % "Debug Mode: " . (DebugMode ? "ON (Log Only)" : "OFF (Click Active)")
; return

; F10::ExitApp

; ClearTip:
;     ToolTip
; return

; ==============================================================================
; === 5. THE LOOP ===
; ==============================================================================

; AutoPickLoop:
;     ; 1. Check if the Card Screen is actually open (Using the Anchor)
;     ;    We scan the whole screen for the Anchor text.
;     if (!FindText(X, Y, 0, 0, 1920, 1080, 0, 0, Anchor_CardScreen)) {
;         return ; Anchor not found -> Screen is clear -> Do nothing
;     }

;     ; 2. Anchor Found! Proceed to selection
;     SelectBestCard()

;     ; 3. Wait for the screen to fade away so we don't double-click
;     Sleep, 1500
; return

; ==============================================================================
; === 6. LOGIC & LOGGING ===
; ==============================================================================

SelectBestCard() {
    MouseMove, 0, 0, 0
    Sleep, 150

    InfoL := GetZoneInfo(ZoneL)
    InfoM := GetZoneInfo(ZoneM)
    InfoR := GetZoneInfo(ZoneR)

    ; --- WINNER CALCULATION ---
    Winner := ""
    if (InfoL.score >= InfoM.score && InfoL.score >= InfoR.score)
        Winner := ZoneL
    else if (InfoM.score >= InfoL.score && InfoM.score >= InfoR.score)
        Winner := ZoneM
    else
        Winner := ZoneR
    /*
        ; --- AUTO-SCREENSHOT FOR UNKNOWNS ---
        ; Check if ANY of the cards are unknown
        if (InfoL.cardName = "Unknown" || InfoM.cardName = "Unknown" || InfoR.cardName = "Unknown") {
            ; Create temp folder if it doesn't exist
            if !InStr(FileExist("temp"), "D") {
                FileCreateDir, temp
            }

            ; Generate a unique filename using date and time
            FormatTime, FileTime,, yyyy-MM-dd_HH-mm-ss
            SnapPath := "temp\Unknown_" . FileTime . ".bmp"

            ; Capture the screen and save to the temp folder
            ; Syntax: FindText().SavePic(FileName, X1, Y1, X2, Y2)
            ; We capture the middle band where cards appear (Y 400 to 700) to keep files small
            FindText().SavePic(SnapPath, 0, 400, 1920, 700)
        }
    */

    ; --- LOGGING ---
    FormatTime, TimeString,, HH:mm:ss
    LogEntry := "TIME: " . TimeString . " | L: " . InfoL.cardName . " | M: " . InfoM.cardName . " | R: " . InfoR.cardName . " | WINNER: " . Winner.name . "`n"
    FileAppend, %LogEntry%, %LogFile%

    ; --- EXECUTION ---
    if (!DebugMode) {
        Click, % Winner.clickX . ", " . Winner.clickY
    } else {
        SoundBeep, 750, 100
    }
}

GetZoneInfo(Zone) {
    for index, card in Cards {
        if (FindText(X, Y, Zone.x1, Zone.y1, Zone.x2, Zone.y2, 0, 0, card.code)) {
            return {score: card.score, cardName: card.name}
        }
    }
    return {score: 0.0, cardName: "Unknown"}
}

ClickCard(Zone) {
    Click, % Zone.clickX . ", " . Zone.clickY
    Sleep, 200
}

AddCard(Name, Code, Score) {
    Global Cards
    Cards.Push({name: Name, code: Code, score: Score})
}