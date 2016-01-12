extensions [array]

globals[

  Area-a
  Area-b
  Area-c
  Area-d

  total_number_of_consumers
  time_count
  checksum_total_sum_marketshares
  number_of_responsive_consumers
  contract_under_consideration

  total_financial
  total_social_gains
  total_privsec
  total_financial_correctedbymarketshare
  total_social_gains_correctedbymarketshare
  total_privsec_correctedbymarketshare

  total_consumers_RTP
  total_consumers_CPP
  total_consumers_ToU
  total_consumers_RTPH

  info_RTP
  info_CPP
  info_ToU
  info_RTPH

  marketshare_RTP
  marketshare_CPP
  marketshare_ToU
  marketshare_RTPH

]


breed[consumers consumer]
consumers-own [consumer_profile chosen_contract egoistic hedonic biospheric altruistic techacc RTPscore CPPscore ToUscore RTPHscore info_strategy_response responsiveness]

breed[contracts contract]
contracts-own [contracttype flexibility financial social environmental privsec usability amount_of_consumers marketshare information_strategy]

to setup
  clear-all
  set number_of_responsive_consumers (1 - percentage_unresponsive_consumers ) * Total_Number_of_Households ;calculates the number of responsive consumers from all the interfact inputs
  setup-contracts
  if (Low_Income_Households + Young_Families + Environmentalists + Techies + Neutrals != 1) [print "Percentages of consumer groups don't add up to 1!!"] ;check that the input of the consumer groups percentages is correct
  setup-consumers
  setup-patches
  initialcalculateconsumercontracts
  set total_number_of_consumers count consumers
  reset-ticks
end

to setup-contracts
  create-contracts 1 [set contracttype "RTP" set flexibility 2 set financial RTP_financial set social RTP_social_gains set environmental RTP_environmental set privsec RTP_privsec set usability RTP_usability set amount_of_consumers 0 set marketshare 0 set information_strategy 0 set hidden? true]
  create-contracts 1 [set contracttype "CPP" set flexibility 3 set financial CPP_financial set social CPP_social_gains set environmental CPP_environmental set privsec CPP_privsec set usability CPP_usability set amount_of_consumers 0 set marketshare 0 set information_strategy 0 set hidden? true]
  create-contracts 1 [set contracttype "ToU" set flexibility 4 set financial ToU_financial set social ToU_social_gains set environmental ToU_environmental set privsec ToU_privsec set usability ToU_usability set amount_of_consumers 0 set marketshare 0 set information_strategy 0 set hidden? true]
  create-contracts 1 [set contracttype "RTPH" set flexibility 1 set financial RTP_HA_financial set social RTP_HA_social_gains set environmental RTP_HA_environmental set privsec RTP_HA_privsec set usability RTP_HA_usability set amount_of_consumers 0 set marketshare 0 set information_strategy 0 set hidden? true]
end

to setup-consumers
  create-consumers Total_Number_of_Households * Low_Income_Households [ set consumer_profile "LIH" set egoistic 5 set hedonic 2 set biospheric 4 set altruistic 3 set techacc 1 set RTPscore 0 set CPPscore 0 set ToUscore 0 set RTPHscore 0 set info_strategy_response 0 set responsiveness true set color lime]
  create-consumers Total_Number_of_Households * Young_Families [ set consumer_profile "YMCF" set egoistic 2 set hedonic 5 set biospheric 3 set altruistic 4 set techacc 1 set RTPscore 0 set CPPscore 0 set ToUscore 0 set RTPHscore 0 set info_strategy_response 0 set responsiveness true set color pink]
  create-consumers Total_Number_of_Households * Environmentalists [ set consumer_profile "environmentalist" set egoistic 3 set hedonic 2 set biospheric 5 set altruistic 4 set techacc 1 set RTPscore 0 set CPPscore 0 set ToUscore 0 set RTPHscore 0 set info_strategy_response 0 set responsiveness true set color orange]
  create-consumers Total_Number_of_Households * Techies [ set consumer_profile "techie" set egoistic 3 set hedonic 4 set biospheric 1 set altruistic 2 set techacc 5 set RTPscore 0 set CPPscore 0 set ToUscore 0 set RTPHscore 0 set info_strategy_response 0 set responsiveness true set color sky]
  create-consumers Total_Number_of_Households * Neutrals [ set consumer_profile "neutral" set egoistic 3 set hedonic 3 set biospheric 3 set altruistic 3 set techacc 3 set RTPscore 0 set CPPscore 0 set ToUscore 0 set RTPHscore 0 set info_strategy_response 0 set responsiveness true set color violet]

  ; the settings below here are there to specify on which information strategy which type of consumers will react
  ask consumers with [consumer_profile = "LIH"][
    set info_strategy_response 1]
  let x 0.5 * total_number_of_consumers * Low_Income_Households
  ask n-of x consumers with [consumer_profile = "LIH"][
    set info_strategy_response 2]

  ask consumers with [consumer_profile = "YMCF"][
    set info_strategy_response 1]
  let y 0.25 * total_number_of_consumers * Young_Families
  ask n-of y consumers with [consumer_profile = "YMCF"][
    set info_strategy_response 2]

  ask consumers with [consumer_profile = "environmentalist"][
    set info_strategy_response 2]
  let z 0.5 * total_number_of_consumers * Environmentalists
  ask n-of z consumers with [consumer_profile = "environmentalist"][
    set info_strategy_response 3]

  ask consumers with [consumer_profile = "techie"][
    set info_strategy_response 2]
  let w 0.25 * total_number_of_consumers * Techies
  ask n-of w consumers with [consumer_profile = "techie"][
    set info_strategy_response 3]
end

; this is to illustrate the changes in choices of consumer with an animation
to setup-patches
  let borders patches with [pxcor = 0 or pycor = 0]
  ask borders [
    set pcolor white ]
  ask patches with [pycor = 8 and pxcor = 8] [
    set plabel "Critical-Peak Pricing"
    set plabel-color black]
  ask patches with [pycor = 8 and pxcor = -8] [
    set plabel "Real-Time Pricing"
    set plabel-color black]
  ask patches with [pycor = -8 and pxcor = 8] [
    set plabel "Time of Use"
    set plabel-color black]
  ask patches with [pycor = -8 and pxcor = -8] [
    set plabel "Real Time Pricing"
    set plabel-color black]
  ask patches with [pycor = -9 and pxcor = -8] [
    set plabel "with home automation"
    set plabel-color black]

  set area-a patches with [pxcor < 0 and pycor > 0]
  set area-b patches with [pxcor > 0 and pycor > 0]
  set area-c patches with [pxcor > 0 and pycor < 0]
  set area-d patches with [pxcor < 0 and pycor < 0]

  ask area-a [set pcolor yellow]
  ask area-b [set pcolor green]
  ask area-c [set pcolor brown]
  ask area-d [set pcolor red]
end

to initialcalculateconsumercontracts
  ask contracts with [contracttype = "RTP"][
    ask Consumers[
      set RTPscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
    ]]
  ask contracts with [contracttype = "CPP"][
    ask Consumers[
      set CPPscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
    ]]
  ask contracts with [contracttype = "ToU"][
    ask Consumers[
      set ToUscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
    ]]
  ask contracts with [contracttype = "RTPH"][
    ask Consumers[
      set RTPHscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
    ]]

  ask Consumers[
    let test (list RTPscore CPPscore ToUscore RTPHscore)
    let highest max test
    let maximumlist [] ;this list is there to ensure that also when multiple contracts have the highest score, randomly one out of them will be chosen
    let numberofmax 0
    if(RTPscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "RTP" maximumlist ]
    if(CPPscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "CPP" maximumlist ]
    if(ToUscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "ToU" maximumlist ]
    if(RTPHscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "RTPH" maximumlist ]
    set chosen_contract item (random (length maximumlist)) maximumlist]
end

to go
  set time_count time_count + 1
  calculatemarketshare
  apply_information_or_market_strategy
  calculateconsumerchoices
  move-turtles
  calculate_totals_contract_specifications ;this calculates the sums for the contract specifications to plot it in the graph
  calculate_totals_contract_specifications_correctedbymarketshare ; this calculates the sum for the contract specification corrected by marketshares to plot it in the graph
  calculate_number_of_consumers ;this calculates the total of consumers per contract to plot it in the graph
  calculate_infostrategies_forplot ;this calculates the different information strategies used to plot it in the graph
  calculate_marketshare_per_contract ;this calculates the marketshares per contract to plot it in the graph
  tick
  if (ticks = 60)[ ;The simulation stops after 5 years
    stop]
end


to calculatemarketshare
  ask Contracts [set marketshare 0
    set amount_of_consumers 0]
  ask Consumers[
    ifelse(chosen_contract = "RTP")[
      ask contracts with [contracttype = "RTP"][
        set amount_of_consumers amount_of_consumers + 1]]
    [ifelse(chosen_contract = "CPP")[
      ask contracts with [contracttype = "CPP"][
        set amount_of_consumers amount_of_consumers + 1]]
    [ifelse(chosen_contract = "ToU")[
      ask contracts with [contracttype = "ToU"][
        set amount_of_consumers amount_of_consumers + 1]]
    [ifelse(chosen_contract = "RTPH")[
      ask contracts with [contracttype = "RTPH"][
        set amount_of_consumers amount_of_consumers + 1]]
    [show "No contract is chosen so no amount of consumers can be set per contracttype"]]]]
  ]

  if(total_number_of_consumers != 0)[ ;to prevent for dividing by zero
    ask contracts [
      set marketshare amount_of_consumers / total_number_of_consumers]
  ]
end

to apply_information_or_market_strategy
  set contract_under_consideration ""

  if (time_count = 3)[
    set time_count 0
    let minimum_marketshare [marketshare] of min-one-of contracts [marketshare]
    ask contracts[
      if (marketshare = minimum_marketshare)[
        set contract_under_consideration contracttype]]

    ask contracts with [contracttype = contract_under_consideration][
      ifelse (information_strategy = 0)[
        update_infostrategy]
      [update_contract]]

    ask contracts with [contracttype != contract_under_consideration][
      set information_strategy 0]]
end

to update_infostrategy
  ask contracts with [contracttype = contract_under_consideration][
    set information_strategy random (3) + 1]
end

to update_contract
  let highestvalue 0
  let value_to_change ""
  let best_contract ""

  ask contracts with [contracttype = contract_under_consideration][
    set information_strategy 0]

  let maximum_marketshare [marketshare] of max-one-of contracts [marketshare]
  let minimum2_marketshare [marketshare] of min-one-of contracts [marketshare]

  ;to ensure that when two contracts have the highest marketshare only one will be chosen to compare the contract_under_consideration with
  ask contracts with [contracttype != contract_under_consideration and marketshare = maximum_marketshare][
    set best_contract contracttype]

  ask contracts with [contracttype = best_contract][

    ;the two blocks below are to investigate which contractattribute has to change (the one with the highest value). Also taken into account the possibility that 2 or 3 of them could have the highest value
    ifelse (financial > social)[
      set highestvalue financial
      set value_to_change "financial"]
    [ifelse (financial < social)[
      set highestvalue social
      set value_to_change "social"]
    [ifelse (financial = social and financial != privsec)[
      set value_to_change one-of ["financial" "social"]
      ifelse (value_to_change = "financial")[
        set highestvalue financial]
      [ifelse (value_to_change = "social")[
        set highestvalue social]
      [ ]]]
    [ifelse (financial = social and financial = privsec)[
      set value_to_change one-of["financial" "social" "privsec"]
      ifelse (value_to_change = "financial")[
        set highestvalue financial]
      [ifelse (value_to_change = "social")[
        set highestvalue social]
      [ifelse(value_to_change = "privsec")[
        set highestvalue privsec]
      [ ]]]
    ]
    [ ]]]]

    ifelse (highestvalue < privsec)[
      set highestvalue privsec
      set value_to_change "privsec"]
    [ifelse (highestvalue = privsec)[
      let change_to_privsec_or_not one-of ["not_privsec" "privsec"]
      if (change_to_privsec_or_not = "privsec")[
        set value_to_change "privsec"
        set highestvalue privsec]]
    [ ]]
  ]

  ask contracts with [contracttype = contract_under_consideration][
    ;if the social value is going to increase
    ifelse (value_to_change = "social")[
      let old_financial1 financial
      let new_social (social + highestvalue) / 2
      set financial financial - (new_social - social)
      ifelse (financial < 0)[
        set social social + old_financial1
        set financial 0]
      [set social new_social ]]

    ;if the privsec value is going to increase
    [ifelse (value_to_change = "privsec")[
      type"the privse value is going to change and has the value " print privsec
      let old_financial2 financial
      let new_privsec (privsec + highestvalue) / 2
      set financial financial - (new_privsec - privsec)
      ifelse (financial < 0)[
        set privsec privsec + old_financial2
        set financial 0]
      [set privsec new_privsec]]

    ;if the financial value is going to increase
    [ifelse (value_to_change = "financial")[
      let new_financial (financial + highestvalue) / 2
      let random_from_privsec_social one-of ["privsec" "social"]
      ifelse (random_from_privsec_social = "privsec")[
        let old_privsec privsec
        set privsec privsec - (new_financial - financial)
        ifelse (privsec < 0)[
          set financial financial + old_privsec
          set privsec 0]
        [set financial new_financial]]
      [ifelse (random_from_privsec_social = "social")[
        let old_social social
        set social social - (new_financial - financial)
        ifelse (social < 0)[
          set financial financial + old_social
          set social 0]
        [set financial new_financial]]
      [print "there is something wrong with random choice from social and privsec!"]]]

    [print "value_to_change is not social and not privsec and not financial"]]]]
end


to calculateconsumerchoices
  ask consumers [set responsiveness false]
  ask n-of number_of_responsive_consumers consumers [set responsiveness true]

  ask contracts with [contracttype = "RTP"][
    ask consumers with [responsiveness = true][
      set RTPscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
      if ([information_strategy] of myself = info_strategy_response)[
        set RTPscore RTPscore + infostrategy_increasevalue]
    ]]
  ask contracts with [contracttype = "CPP"][
    ask consumers with [responsiveness = true][
      set CPPscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
      if ([information_strategy] of myself = info_strategy_response)[
        set CPPscore CPPscore + infostrategy_increasevalue]
    ]]
  ask contracts with [contracttype = "ToU"][
    ask consumers with [responsiveness = true][
      set ToUscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
      if ([information_strategy] of myself = info_strategy_response)[
        set ToUscore ToUscore + infostrategy_increasevalue]
    ]]
  ask contracts with [contracttype = "RTPH"][
    ask consumers with [responsiveness = true][
      set RTPHscore [financial] of myself * egoistic + [social] of myself * altruistic + [environmental] of myself * biospheric + [privsec] of myself * techacc + [usability] of myself * hedonic
      if ([information_strategy] of myself = info_strategy_response)[
        set RTPHscore RTPHscore + infostrategy_increasevalue]
    ]]

  ask Consumers[
    let test (list RTPscore CPPscore ToUscore RTPHscore)
    let highest max test
    let maximumlist []
    let numberofmax 0
    if(RTPscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "RTP" maximumlist ]
    if(CPPscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "CPP" maximumlist ]
    if(ToUscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "ToU" maximumlist ]
    if(RTPHscore = highest)[
      set numberofmax numberofmax + 1
      set maximumlist lput "RTPH" maximumlist ]
    set chosen_contract item (random (length maximumlist)) maximumlist
  ]
end

;this is for the animation
to move-turtles
  ask Consumers [
    ifelse (chosen_contract = "RTP") [
      set heading towards one-of area-a]
    [ifelse (chosen_contract = "CPP") [
      set heading towards one-of area-b]
    [ifelse (chosen_contract = "ToU") [
      set heading towards one-of area-c]
    [ifelse (chosen_contract = "RTPH")
      [set heading towards one-of area-d]
      [print "no contract is chosen so turtles can not move"]]]]
    fd 1]
end

to calculate_totals_contract_specifications
  set total_financial 0
  set total_social_gains 0
  set total_privsec 0
  ask contracts [
    set total_financial total_financial + financial
    set total_social_gains total_social_gains + social
    set total_privsec total_privsec + privsec]
end

to calculate_totals_contract_specifications_correctedbymarketshare
  set total_financial_correctedbymarketshare 0
  set total_social_gains_correctedbymarketshare 0
  set total_privsec_correctedbymarketshare 0
  ask contracts [
    if (marketshare != 0)[
      set total_financial_correctedbymarketshare total_financial_correctedbymarketshare + (financial * marketshare)
      set total_social_gains_correctedbymarketshare total_social_gains_correctedbymarketshare + (social * marketshare)
      set total_privsec_correctedbymarketshare total_privsec_correctedbymarketshare + (privsec * marketshare)]
  ]
end

to calculate_infostrategies_forplot
  set info_RTP 0
  set info_CPP 0
  set info_ToU 0
  set info_RTPH 0
  ask contracts with [contracttype = "RTP"][
    set info_RTP information_strategy]
  ask contracts with [contracttype = "CPP"][
    set info_CPP information_strategy]
  ask contracts with [contracttype = "ToU"][
    set info_ToU information_strategy]
  ask contracts with [contracttype = "RTPH"][
    set info_RTPH information_strategy]
end

to calculate_number_of_consumers
  set total_consumers_RTP 0
  ask contracts with [contracttype = "RTP"][
    set total_consumers_RTP amount_of_consumers]
  set total_consumers_CPP 0
  ask contracts with [contracttype = "CPP"][
    set total_consumers_CPP amount_of_consumers]
  set total_consumers_ToU 0
  ask contracts with [contracttype = "ToU"][
    set total_consumers_ToU amount_of_consumers]
  set total_consumers_RTPH 0
  ask contracts with [contracttype = "RTPH"][
    set total_consumers_RTPH amount_of_consumers]
end

to calculate_marketshare_per_contract
  set marketshare_RTP 0
  ask contracts with [contracttype = "RTP"][
    set marketshare_RTP marketshare * 100]
  set marketshare_CPP 0
  ask contracts with [contracttype = "CPP"][
    set marketshare_CPP marketshare * 100]
  set marketshare_ToU 0
  ask contracts with [contracttype = "ToU"][
    set marketshare_ToU marketshare * 100]
  set marketshare_RTPH 0
  ask contracts with [contracttype = "RTPH"][
    set marketshare_RTPH marketshare * 100]
end

@#$#@#$#@
GRAPHICS-WINDOW
8
10
447
470
16
16
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
468
17
531
50
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
546
17
609
50
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
632
11
1000
44
percentage_unresponsive_consumers
percentage_unresponsive_consumers
0.4
.6
0.51
0.01
1
NIL
HORIZONTAL

SLIDER
632
46
833
79
infostrategy_increasevalue
infostrategy_increasevalue
0
5
5
0.1
1
NIL
HORIZONTAL

TEXTBOX
637
114
718
132
Real Time Pricing
11
0.0
1

INPUTBOX
627
133
732
193
RTP_financial
0.6
1
0
Number

INPUTBOX
627
192
732
254
RTP_social_gains
0.4
1
0
Number

INPUTBOX
627
253
733
313
RTP_environmental
0.6
1
0
Number

INPUTBOX
627
311
732
371
RTP_privsec
0.2
1
0
Number

INPUTBOX
627
371
731
431
RTP_usability
0.2
1
0
Number

INPUTBOX
731
133
836
193
CPP_financial
0.4
1
0
Number

INPUTBOX
731
191
836
251
CPP_social_gains
0.6
1
0
Number

INPUTBOX
730
250
836
310
CPP_environmental
0.4
1
0
Number

INPUTBOX
730
308
836
370
CPP_privsec
0.4
1
0
Number

INPUTBOX
730
367
837
427
CPP_usability
0.6
1
0
Number

TEXTBOX
735
112
850
130
Critical Peak Pricing
11
0.0
1

INPUTBOX
470
163
606
223
Low_Income_Households
0.2
1
0
Number

INPUTBOX
470
222
606
282
Young_Families
0.2
1
0
Number

INPUTBOX
470
281
606
341
Environmentalists
0.2
1
0
Number

INPUTBOX
471
341
606
401
Techies
0.2
1
0
Number

INPUTBOX
471
400
606
460
Neutrals
0.2
1
0
Number

TEXTBOX
466
142
616
160
Percentage Consumer Groups
11
0.0
1

INPUTBOX
457
63
621
123
Total_Number_of_Households
3000
1
0
Number

PLOT
1081
10
1479
234
Development of Contract Specifications
time
Sum from all contracts
0.0
10.0
0.0
3.0
true
true
"" ""
PENS
"Financial gains" 1.0 0 -955883 true "" "plot total_financial"
"Social gains" 1.0 0 -2064490 true "" "plot total_social_gains"
"Privacy and security" 1.0 0 -8630108 true "" "plot total_privsec"
"Financial corrected" 1.0 0 -7500403 true "" "plot total_financial_correctedbymarketshare"
"social corrected" 1.0 0 -2674135 true "" "plot total_social_gains_correctedbymarketshare"
"privsec corrected" 1.0 0 -6459832 true "" "plot total_privsec_correctedbymarketshare"

PLOT
1074
242
1485
476
Number of Consumers per Contract
time
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"RTP" 1.0 0 -1184463 true "" "plot total_consumers_RTP"
"CPP" 1.0 0 -13840069 true "" "plot total_consumers_CPP"
"ToU" 1.0 0 -6459832 true "" "plot total_consumers_ToU"
"RTP with HA" 1.0 0 -2674135 true "" "plot total_consumers_RTPH"

INPUTBOX
835
132
945
192
ToU_financial
0.2
1
0
Number

INPUTBOX
834
191
944
251
ToU_social_gains
0.2
1
0
Number

INPUTBOX
835
250
944
310
ToU_environmental
0.2
1
0
Number

INPUTBOX
835
309
944
369
ToU_privsec
0.8
1
0
Number

INPUTBOX
835
368
945
428
ToU_usability
0.8
1
0
Number

INPUTBOX
944
132
1069
192
RTP_HA_financial
0.8
1
0
Number

INPUTBOX
942
191
1069
251
RTP_HA_social_gains
0.8
1
0
Number

INPUTBOX
943
250
1069
310
RTP_HA_environmental
0.8
1
0
Number

INPUTBOX
943
309
1068
369
RTP_HA_privsec
0
1
0
Number

INPUTBOX
944
368
1068
428
RTP_HA_usability
0.8
1
0
Number

TEXTBOX
844
111
922
129
Time of Use
11
0.0
1

TEXTBOX
953
100
1061
128
Real Time Pricing with \nHome Automation
11
0.0
1

PLOT
1492
14
1798
190
Information Strategies
time
Information Strategy
0.0
10.0
0.0
3.0
true
true
"" ""
PENS
"RTP" 1.0 0 -1184463 true "" "plot info_RTP"
"CPP" 1.0 0 -10899396 true "" "plot info_CPP"
"ToU" 1.0 0 -6459832 true "" "plot info_ToU"
"RTP with HA" 1.0 0 -2674135 true "" "plot info_RTPH"

PLOT
1512
225
1802
461
Marketshares per Contract
time
marketshare
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"RTP" 1.0 0 -1184463 true "" "plot marketshare_RTP"
"CPP" 1.0 0 -10899396 true "" "plot marketshare_CPP"
"ToU" 1.0 0 -6459832 true "" "plot marketshare_ToU"
"RTP with HA" 1.0 0 -2674135 true "" "plot marketshare_RTPH"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experimentinfostrategy" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="60"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="RTP_HA_environmental">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_environmental">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_social_gains">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_HA_usability">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ToU_environmental">
      <value value="0.2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="infostrategy_increasevalue" first="0" step="0.1" last="5"/>
    <enumeratedValueSet variable="Techies">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_HA_social_gains">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ToU_privsec">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ToU_financial">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CPP_financial">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Neutrals">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Low_Income_Households">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CPP_environmental">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_HA_privsec">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_HA_financial">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CPP_social_gains">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ToU_usability">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage_unresponsive_consumers">
      <value value="0.51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Environmentalists">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CPP_usability">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_usability">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_privsec">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Young_Families">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Total_Number_of_Households">
      <value value="3000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CPP_privsec">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTP_financial">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ToU_social_gains">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
