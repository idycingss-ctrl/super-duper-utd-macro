#NoEnv  

; ========== CARDS ===========

AddCard(Name, Code, Score := 0) {
    global Cards
    
    ; If the list doesn't exist yet, create it
    if !IsObject(Cards)
        Cards := []
    
    ; Add the new card details to the list
    Cards.Push({"name": Name, "code": Code, "score": Score})
}

InitCardDatabase() {
    static IsLoaded := false
    if (IsLoaded)
        return
    IsLoaded := true
AddCard("Lovers", "|<>*104$49.Dzzzzzzy7kzzzzzzXeTzzzzzlZDzzzzzsmy6MkkEQNSNaH8viAjCnNYwz6Lb9g2S7X/naaTDllZtr7DbgsmwnXbnqQE33lsMsSDzzzzzzz3zzzzzzz8",  4)
AddCard("Fortune", "|<>*105$58.Dzzzzzzzzkn3zzzzzzzXfDzzzzzzyChzztzzzzsuz3U1AkD3XftaCQv4taCXbNtngvaMuSQbbCni1XftmSQvCtyCjbNtngvbsuyNbbAniTXXwCD696QCU", 3)
AddCard("Death", "|<>*102$44.Dzzzzwz3ATzzzDsunzzznyCgzzyQzXfC6310suvAwtlCCinDaQvXfg3lbCsuvDUNniCgnvaQvXXAyFbCss7VWQFiDzzzzzvVzzzzzwm", 2)
AddCard("Magician", "|<>*102$69.DzzzzzDwzzzVaCDzztzbzzyCYdzzzzzzzzlpZjzzzzzzzyCghkS3C4kQ3lpZjnaNYbnWSCghzAnAwzAvlpZjlaNbblbSCghkAnAwkAvlpZitaNbatbSCghmA3AwmAvllXa9mMkW9XCDzzzynzzzzzkzzzzizzzzzwzzzzw7zzzzzw", 5)
AddCard("Emperor", "|<>*99$63.DzzzzzzzzzVa7zzzzzzzyCgzzzzzzzzlpbzzzzzzzyCjk0s7313Uloy8b4n8nASCXnCtqNCQblpyNrCE9nYyCjnCtmTCQblpaNrCntngyCAnCtaTCNblk68n1sMsQSDzzztzzzzzkzzzzDzzzzwzzzzszzzzzw", 1)
AddCard("UncappedWealth", "|<>*140$123.zzzzzzzzzzzzVy67QDzzzzzzzzzzzzzzwDkkH0zzzzzzzzzzzzzzzly32QDzzzzzzzzzzzzzzyDsMHlzzzzzzzzzzzzzzzlz3WCDzzzw60y6DVXzVzUDsQNVwDUy0k3k0w0Ds7k1zXXAT0w7X60T03k0wMQQDwQ9XX3UwMzlswSD7XXXlzVVAQQTz7jyD7XlsswMyDyC9X7XzszzlswCD37X7lzllgswTz7zwD7VlsM0MyDyCA703zszk1swCD30D7lzllUs1w77w6D7VlsMzsyDz74D7z1szXlswSD77z7lzssVszsz3wSD7XlssTsSDz74D3z7wTX1swSD7VzX1zssVwDsnU4070Dk3y0Q0DzU0Tk30S1kks3y0zs7skzy07z0wDzzzz7zlzzzzzzzzzzzzzzzzzszyDzzzzzzzzzzzzw", 999)
AddCard("Accurate", "|<>*137$83.3zzzzzzzzzzzzy1zzzzzzzzzzzzw3zzzzzzzzzzzys7zzzzzzzzzzzswDzzzzzzzzzzzVsTs7s67UsMM1y0kzUDUA71k0k1s1Vy8S8QD3k1U1w33sssssT7UzzVsS7ltltkyD3zz3kkD3z3zVwS7zy7VUS7y7z3swDzwD3kwDwDy7lsTzUS7VsTsTwDXkzU0wD3kzkzsT7Vy1VsS7VzVzkyD3wT3kwDXzXzVwS7sy7VsT3z3z3kwDlwD3ky3y3z21sTVUS7US0S0S0VkTU0S3Uy1y1y33kzVky4", 998)
Addcard("SniperRifle", "|<>*141$87.zz7zzzzzzw40yDbztzzzzzzzUb7nszzzzzzzzzy4sTz7zzzzzzzzzsb3zsMSD37z3lXz4sQS01ks0TkC0Dsb3VU0D7U1sks3z4sSD3lswSD773zsb7lsSD7Xllsszz41yD3lswS6D77zsUTlsSD7Xkk0szz4VyD3lswS60T7zsaDlsSD7Xklzszz4lyD3lswSCDz7zsb7lsSD7Xlkzszz4syD3lswSD3z7zsb3lsC77U7w0sTz1wCD1ssQ1zkD3zsDUkszzzXzzzzzzzzzz7zzwTzzzzzzzzzszzzXzzzzzzzzzz4", 997)
AddCard("50Cal", "|<>*139$69.zzjzzzsaDzz7zszlzz4lzzszU7s3zkaC0z7w0y0Dy4zk3szbzXkzkby0T7wzwT7yAzzlszbzXszlbzyD7sXsT7yAzzlsz0D3szlbzwD7sEsT7y4zk1szz73szkbw6D7zswT7z4zXlszz7XszsbwSD0zswTDz0zX1s3z7k1zw0Q074zlz0zzk3kkszsTzzzzzzzzw", 996)
AddCard("MagiciansManifest", "|<>*142$146.zzzzzXzyDzzkM70zzzzzlw3zrzzzztzzXzzy40U7zzzzwyDzxzzzzzzztzzzlA9lzzzzzzXzzTzzzzzzzzzzwHWQTzzzzzszzrUDy1lzVzk7z4sb7UDVXsw1wBs1y0ADUDs1zlC9ls1s0C60S1S0T73XlXwQTwHWQS0T03lsyA7zXlkswMz7bz4sb7zXlswSDXVzsswCCDTkzzlC9lzswSD7XlsTyCD7XXzw7zwHWQTyD7XlswS7z3XlsszzUTz4sb7z3lswSD01s0swSCDzw3zlC9ls0wSD7Xk3QCCD7XXzzkTwHWQQCD7XlswTr7XVlsszzj7z4sb77XlswSD7xlswQSC7znlzlC9llswSD7XkzQQD27XlzwwTwHWQQQD7Xlsy7n01s9sw0z0Dz1sD301ksQSDk0MMT6S7UTk7zkS3kMMQD73Xy1zzzXbzzzzzzzzzzzzzzzzszzzzzltzzzzzzzzzzzzzzzzyDzzzzswTzzzzzzzzzzzzzzzzXzzU", 1000)
}


; =========== GLOBALS ==========

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
Global Text_Defeat := "|<>**50$157.M000Ak000w000D00030A06zz0zg1z03M3zzy0zzzUDzzU60301UM60bk1g10030E00k4000700k0kA30EC0S0U01U800M2000300M0M61U830D0Tz0k7zkA1zw01U060A30k40k7UDzkM3zw60zz01U03061UM20M3k00AA0033000k0k40k30kA1060s0066001VU00M0k30M1UM60U30Q0033000kk00A0M3U60kA30E1UC001VU00MM0060M1s30M61U80kD000kk00AA0030A1w0kA30k40k7U00MM0066001UA0y0M61UM20M3k7zsA1zy30TzU6000630kA10M1s3zs60zy1UDzU600031UM60Uw1g10030E00k40030000kkA30Ts0q0zzlU800M3zz30000MM61UDk0v0Tzzk400A1zzxU0006A30k000NU001s20060007U7zk361UM000Mk000Q10030001k7zw0n0kE"
Global Text_Lobby := "|<>*139$77.znzDzzzzzzzzzzbyTzzzzzzzzzzDzzzzzzzzzzzSTzwzzyTzzwzsA1nUFskA27UM083a0Vl0M060k4l3AMX6AF0AMWTb6E1W80aAE14TCAk70s3AMk6M6QNXj3lqMlXgk4sn0S7UAlX0NsNlb0yTUNn70nU"
Global Anchor_CardScreen := "|<>*124$21.5zUszy37zsAzzVbry3yzkTby3wTsTXz3yTkTty1zjkDww8zz13zkMDw7U00w"
Global Text_Disconnected := "|<>*147$89.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzzzzzzznzzzzzzzzzzzzwzbzzzzzzzzzzzztzzzzzzzzzzzzzznzzzzzzzzzzzzzzbwy7sT3sVsVy3y41lk70M3k1k1s3k033XQBXXVXVXXb3Qw77sz7b7b7bDaDttD3nyT6DCDC0AznkT1bwyASQSQ0NzbUzn7swswswtzlzD9na7llltltlvVyC3UC0k7XnXnk7UA67Uy3kT7b7bsTUwDzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"