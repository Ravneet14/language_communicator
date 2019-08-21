;generates output file "mrs_info_with_rstr_values.dat" which contains LTOP , kriyA-TAM and id-MRS-Rel_features


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

;Rule for adjective and noun : for (viSeRya-viSeRaNa 	? ?)
;	replace LBL value of viSeRaNa with the LBL value of viSeRya
;	Replace ARG1 value of viSeRaNa with ARG0 value of viSeRya
(defrule viya-viNa
(rel_name-ids viSeRya-viSeRaNa ?viya ?viNa)
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
=>
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viya-viNa  MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
)

;Replace LBL values of kriyA_viSeRaNa with the LBL value of kriyA, and Replace ARG1 values of kriyA_viSeRaNa with the ARG0 value of kriyA. Ex. "I walk slowly." INPUT facts:
  ;(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 30000 _walk_v_1 h10 e11 x2 x13)
  ;(MRS_info  id-MRS_concept-LBL-ARG0-ARG1 20000 _slow_a_1 h7 e8 e9 ) 
;OUTPUT:
  ;(MRS_info  id-MRS_concept-LBL-ARG0-ARG1 20000 _slow_a_1 h10 e8 e11 ) 
(defrule kriyA-kriyA_viSeRaNa
(rel_name-ids kriyA-kriyA_viSeRaNa ?kri ?kri_vi)
(MRS_info ?rel1 ?kri ?mrsconkri ?lbl1 ?arg0  ?arg1 $?var)
(MRS_info  ?rel2 ?kri_vi ?mrsconkrivi ?lbl2 ?arg0_2 ?arg1_2 $?vars)
=>
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(implode$ (create$ $?vars)) ")    "crlf)
(printout ?*rstr-dbug* "(rule-rel-values kriyA-kriyA_viSeRaNa  MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(    implode$ (create$ $?vars)) ")"crlf)
)


;Rule for verb when only karta is present : for (kriyA-k1 ? ?) and  (kriyA-k2 ? ?) is not present
;    replace ARG2 of kriyA with ARG0 of karwA
(defrule v-k1
;(declare (salience 10))
(rel_name-ids	kriyA-k1	?kriyA ?karwA)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?argwA_0))
(not (modified_k1 ?karwA))
=>
(retract ?f)
(assert (modified_k1 ?karwA))
(assert (MRS_info  ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?argwA_0 $?v))
;(printout ?*rstr-fp* "(MRS_info  "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?argwA_0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-k1  MRS_info "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?argwA_0 " "(implode$ (create$ $?v))")"crlf)
)

;Rule for verb and its arguments(when both karta and karma are present),Replace ARG1 value of kriyA with ARG0 value of karwA and ARG2 value of kriyA with ARG0 value of karma
(defrule v-k2
(rel_name-ids	kriyA-k2       	?kriyA ?karma)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel2 ?karma ?mrsCon2 ?lbl2 ?argma_0 $?vars1)
(test (eq (str-index _q ?mrsCon2) FALSE))
(test (neq ?arg2 ?argma_0))
=>
(retract ?f)
(assert (MRS_info  ?rel_name  ?kriyA  ?mrsCon  ?lbl ?arg0 ?arg1 ?argma_0  $?v))
;(printout ?*rstr-fp* "(MRS_info  "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?arg1 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-k2  MRS_info "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?arg1 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
)


;Rule for preposition for noun : for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
;Ex. Sera_ne_yuxXa_ke_liye_jaMgala_meM_saBA_bulAI
;f-12    (rel_name-ids kriyA-k2p 30000 20000)
;f-18    (MRS_info id-MRS_concept-LBL-ARG0 20000 _city_n_1 h15 x16)
;f-19    (MRS_info id-MRS_concept-LBL-ARG0-ARG1 30000 _go_v_1 h17 e18 x19)
;f-16    (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20001 _to_p h7 e8 e9 x10)
(defrule prep-noun
(rel_name-ids ?relp ?kriyA ?karak)
;(MRS_info ?rel_name ?karak ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
(test (neq (str-index "_n_" ?mrsCon2)FALSE))
=>
;(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?karak " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun MRS_info "?rel_name " " ?prep " " ?endsWith_p " " ?lbl " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

;  written by sakshi yadav (NIT-Raipur)
;  date-27.05.19
;Rule for verb and when word 'home' is present:
;Replace LBL of loc_nonsp with LBL of verb and  ARG1 of loc_nonsp with ARG0 of verb and LBL of place_n with LBL of home_p and ARG0 of place_n ,ARG2 of home_p,ARG0 of de_implicit_q with ARG2 of loc_nonsp.
;Ex- i am coming home
;MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 loc_nonsp h7 e8 e9 x10)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 def_implicit_q h11 x12 h13 h14)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 place_n h15 x16)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 20000 _home_p h17 e18 x19)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 30000 _come_v_1 h20 e21 x22)

(defrule v-home
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?lbl1 ?arg01 ?rstr ?body)
(MRS_info id-MRS_concept-LBL-ARG0 ?id place_n ?lbl2 ?arg02)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _home_p ?lbl3 ?arg03 ?arg13)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 ?v ?lbl4 ?arg04 ?arg14)
(test (neq (str-index "_v_" ?v)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0" " ?arg04 " " ?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0 " " ?arg04 " " ?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " _home_p "?lbl3"  "?arg03" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " _home_p "?lbl3"  "?arg03" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
)

;  written by sakshi yadav (NIT-Raipur) date-27.05.19
;Rule for verb and word yesterday,today,tomorrow is present :
;Replace LBL of loc_nonsp with LBL of verb and  ARG1 of loc_nonsp with ARG0 of verb and LBL of place_n with LBL of home_p and ARG1 of mrs_time  ,ARG0 of time_n home_p,ARG0 of de_implicit_q with ARG2 of loc_nonsp
;MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 loc_nonsp h7 e8 e9 x10)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 def_implicit_q h11 x12 h13 h14)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 time_n h15 x16)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 20000 _yesterday_a_1|_today_a_1|_tomorrow_a_2 h17 e18 x19)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 30000 _come_v_1 h20 e21 x22)
;Ex- i came yesterday, i will come tomorrow, i come today
(defrule v-time
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?lbl1 ?arg01 ?rstr ?body)
(MRS_info id-MRS_concept-LBL-ARG0 ?id time_n ?lbl2 ?arg02)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?mrs_time ?lbl3 ?arg03 ?arg13)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 ?v ?lbl4 ?arg04 ?arg14)
(test (neq (str-index "_v_" ?v)FALSE))
(test (or (eq ?mrs_time _yesterday_a_1) (eq ?mrs_time _today_a_1) (eq ?mrs_time _tomorrow_a_1)))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0" " ?arg04 " " ?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0 " " ?arg04 " " ?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" time_n "?lbl3" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0  "?id" time_n "?lbl3" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?mrs_time " "?lbl3"  "?arg03" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?mrs_time " "?lbl3"  "?arg03" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
)


;Rule for preposition for proper_noun : for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20001 _for_p h11 e12 e13 x14)
;(MRS_info id-MRS_concept-LBL-ARG0-CARG 20000 named h19 x20 n21)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 40000 _come_v_1 h28 e29 x30)
;then
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20001 _for_p vlbl e12 varg0 namedarg0)
;Ex. mEM_John_ke_liye_Sahara_se_AyA
;Ex. baccA_somavAra_ko_Pala__KA-wA_hE
;Ex. baccA_janavarI_meM_Pala__KA-wA_hE
(defrule prep-propn
(rel_name-ids ?relp ?kri ?id)
?f1<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1 ?id ?named ?l  ?namedarg0 $?v)
(MRS_info ?rel2 ?kri ?mrsCon2 ?vlbl ?varg0 $?varss)
(test (or (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p") (neq (str-index "_p_" ?endsWith_p)FALSE)) )
(test (neq (str-index "_v_" ?mrsCon2)FALSE))
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?id))))
(test (or (eq ?named named) (eq ?named dofw) (eq ?named mofy))) ;
=>
(retract ?f1)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?vlbl " " ?arg0 " " ?varg0 " " ?namedarg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-propn MRS_info "?rel_name " " ?prep " " ?endsWith_p " " ?vlbl " " ?arg0 " " ?varg0 " " ?namedarg0 ")"crlf)
)

;Rule for possessive pronoun:
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 poss h7 e8 x9 x10)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 _friend_n_1 h31 x32)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 def_explicit_q h11 x12 h13 h14)
;(MRS_info id-MRS_concept-LBL-ARG0 10000 pron h1 x2)
;then
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 poss nlbl e8 narg0 pronarg0)
;Ex.My friend is playing in the garden.
(defrule RaRTI-viSeRaNa
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_explicit_q ?lbl1 ?arg01 ?rstr ?body)
(MRS_info ?rel_name ?id poss ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1 ?id ?mrsCon1 ?nlbl  ?narg0 $?v)
(MRS_info ?rel2 ?id1 pron ?plbl ?parg0 $?var)
(test (neq (str-index "_n_" ?mrsCon1)FALSE))
;(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
;(test (neq (str-index "_v_" ?mrsCon2)FALSE))
;(test (eq (sub-string 1 1 (str-cat ?poss)) (sub-string 1 1 (str-cat ?id))))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id " def_explicit_q " ?lbl1 " "?narg0 " " ?rstr " " ?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values RaRTI-viSeRaNa MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY " ?id " def_explicit_q " ?lbl1 " " ?narg0 " " ?rstr " " ?body")"crlf)

(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?id " poss " ?nlbl " " ?arg0 " " ?narg0 " " ?parg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values RaRTI-viSeRaNa MRS_info " ?rel_name " " ?id " poss " ?nlbl " " ?arg0 " " ?narg0 " " ?parg0 ")"crlf)
)

; written by sakshi yadav (NIT-Raipur) Date - 27.05.19
;Rule for proper noun :
;Replace LBL of poss with LBL of mrsCon1 and ARG1 of poss with ARG0 of mrsCon1 and ARG2 of poss with ARG0 of proper_q and ARG0 of named wirh ARG0 of proper_q
;Ex- John's son studies in the school
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 poss h7 e8 x9 x10)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 _son_n_1 h31 x32)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 def_explicit_q h11 x12 h13 h14)
;(MRS_info id-MRS_concept-LBL-ARG0 10000 proper_q h1 x2 h3 h4)
;(MRS_info id-MRS_concept-LBL-ARG0 10000 named h15 x22 )
;Ex-John's son studies in the school.
(defrule RaRTI-viSeRaNapropn
(rel_name-ids viSeRya-r6	?id	?id1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id poss ?lbl8 ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id1 proper_q ?lbl11 ?arg02 ?rstr1 ?body2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?mrsCon1 ?lbl3  ?arg09 ?arg22)
(MRS_info ?rel                             ?id1 named ?lbl6 ?arg33 ?v)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_explicit_q ?lbl1 ?arg01 ?rstr2 ?body)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2  " ?id " poss " ?lbl3 " " ?arg0 " " ?arg09 " " ?arg33 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values RaRTI-viSeRaNapropn MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2  " ?id " poss " ?lbl3 " " ?arg0 " " ?arg09 " " ?arg33 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY  " ?id " def_explicit_q " ?lbl1 " " ?arg09 " " ?rstr2 " " ?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values RaRTI-viSeRaNapropn MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY  " ?id " def_explicit_q " ?lbl1 " " ?arg09 " " ?rstr2" " ?body ")"crlf)
)


;Rule for preposition for pronoun : when (id-pron ? yes) for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
;Ex. mEM_usake_lie_Sahara_se_AyA
(defrule prep-pron
(rel_name-ids ?relp ?kriyA ?karaka)
(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karaka pron ?lbl2 ?argpron_0 $?varss)
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karaka))))
=>
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argpron_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-pron MRS_info "?rel_name " " ?kriyA " " ?endsWith_p " " ?lbl " " ?arg0 " " ?argv_0 " " ?argpron_0 ")"crlf)
)


;Rule for interrogative sent 'where'
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 which_q h11 x12 h13 h14)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 30000 _live_v_1 h17 e18 x19)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 loc_nonsp h7 e8 e9 x10)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 place_n h15 x16)
;then
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 loc_nonsp lilbl arg0 liarg0 wharg0)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 place_n plbl wharg0)
(defrule ques-where
(MRS_info ?rel_name ?id which_q ?whlbl ?wharg0 $?v)
(MRS_info ?rel1 ?id1 ?mrsCon1 ?lilbl ?liarg0 $?vars)
(MRS_info ?rel ?id place_n ?plbl ?parg0)
?f<- (MRS_info ?rel2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel2 " "?id " " loc_nonsp " " ?lilbl " " ?arg0 " " ?liarg0 " " ?parg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-where MRS_info  " ?rel2 " "?id " " loc_nonsp " " ?lilbl " " ?arg0 " " ?liarg0 " " ?parg0 ")"crlf)

(printout ?*rstr-fp* "(MRS_info  " ?rel_name " "?id " " which_q " " ?whlbl " " ?parg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-where MRS_info  " ?rel_name " "?id " " which_q " " ?whlbl " " ?parg0 ")"crlf)
)

;Rule for interrogative sent 'when'
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 which_q h13 x14 h15 h16)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 30000 _go_v_1 h17 e18 x19)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 loc_nonsp h7 e8 e9 x10)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 time_n h11 x12)
;then
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 loc_nonsp glbl arg0 garg0 targ0)
;(MRS_info id-MRS_concept-LBL-ARG0 20000 time_n whlbl targ0)
(defrule ques-when
(MRS_info ?rel_name ?id which_q ?whlbl ?wharg0 $?v)
(MRS_info ?rel1 ?id1 ?mrsCon1 ?glbl ?garg0 $?vars)
(MRS_info ?rel ?id time_n ?tlbl ?targ0)
?f<- (MRS_info ?rel2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel2 " "?id " " loc_nonsp " " ?glbl " " ?arg0 " " ?garg0 " " ?targ0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-when MRS_info  " ?rel2 " "?id " " loc_nonsp " " ?glbl " " ?arg0 " " ?garg0 " " ?targ0 ")"crlf)

(printout ?*rstr-fp* "(MRS_info  " ?rel_name " "?id " " which_q " " ?whlbl " " ?targ0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-when MRS_info  " ?rel_name " "?id " " which_q " " ?whlbl " " ?targ0 " "(implode$ (create$ $?v))")"crlf)
)


;Rule for binding proper noun (proper_q) and named ARG0 values. And, replace CARG value with proper name present in the sent. 
;(id-concept_label	20000	John_1)
;(MRS_info id-MRS_concept-LBL-ARG0-CARG 20000 named h1 x2 n3)
;(MRS_info  id-MRS_concept-LBL-ARG0-RSTR-BODY 20000 proper_q h4 n2 h6 h7)
;Ex. rAma_jA_rahA_hE.  kyA_rAma_jA_rahA_hE?
(defrule propn
(declare (salience 1000))
(id-concept_label	?id	?properName)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id ?named ?h1 ?x2 ?carg)
(test (eq ?named named) )
(not (modified ?id))
=>
(retract ?f)
;(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-CARG "?id" named "?h1" "?x2 " " ?properName ")"crlf)
(assert (MRS_info  id-MRS_concept-LBL-ARG0-CARG  ?id  ?named ?h1 ?x2  (sym-cat (upcase (sub-string 1 1 ?properName ))(lowcase (sub-string 2 (str-length ?properName) ?properName )))))
(printout ?*rstr-dbug* "(rule-rel-values propn MRS_info id-MRS_concept-LBL-ARG0-CARG "?id"  "?named " "?h1" "?x2" " (sym-cat (upcase (sub-string 1 1 ?properName )) (lowcase (sub-string 2 (str-length ?properName) ?properName ))) ")"crlf)
(assert (modified ?id))
)

;Rule for generating CARG value 'Mon' in days of week and 'Jan' in months of year
(defrule dofw
(id-concept_label	?id	?con)
(or (mofy ?con ?val) (dofw ?con ?val))
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id ?dofw  ?h1 ?x2 ?carg)
(test (or (eq ?dofw mofy) (eq ?dofw dofw)))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-CARG "?id" " ?dofw " "?h1" "?x2 " " ?val ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values dofw MRS_info id-MRS_concept-LBL-ARG0-CARG "?id"  "?dofw " "?h1" "?x2" " ?val ")"crlf)
)


;Rule for numerical adjectives. Replace 
;   CARG value of cardinal number with English number and 
;   LBL value of the same fact with LBL of viSeRya, and
;   ARG1 value with the ARG0 value of viSeRya
;Ex. rAma xo kiwAbaeM paDa rahA hE.
(defrule saMKyA_vi
(rel_name-ids viSeRya-saMKyA_viSeRaNa	?vi     ?num)
(concept_label-concept_in_Eng-MRS_concept ?hnum ?enum card)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num card ?lbl ?numARG0 ?ARG1 ?CARG)
(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" card "?vilbl" " ?numARG0 " "?viarg0" " ?enum ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values saMKyA_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" card "?vilbl" "?numARG0" "?viarg0" "?enum")"crlf)
)


;Rule for numerical adjectives. Replace 
;   CARG value of ordinal number with English number and 
;   LBL value of the same fact with LBL of viSeRya, and
;   ARG1 value with the ARG0 value of viSeRya
;Ex. rAma pahalI kiwAba paDa rahA hE.
(defrule kramavAcI_vi
(rel_name-ids viSeRya-kramavAcI_viSeRaNa   ?vi     ?num)
(concept_label-concept_in_Eng-MRS_concept ?hnum ?enum ord)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num ord ?lbl ?numARG0 ?ARG1 ?CARG)
(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" ord "?vilbl" " ?numARG0 " "?viarg0" " ?enum ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kramavAcI_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" ord "?vilbl" "?numARG0" "?viarg0" "?enum")"crlf)
)


;Rule for sentence and tam info: (if (kriyA-TAM), value of id = value of kriyA from the facts kriyA-TAM, SF from sentence_type and the rest from tam_mapping.csv)
;for asssertive sentence information
(defrule kri-tam-asser
(kriyA-TAM ?kri ?tam)
(sentence_type  assertive|pass-assertive)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;for negation sentence information
(defrule kri-tam-neg
(kriyA-TAM ?kri ?tam)
(sentence_type  negation)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

; written by sakshi yadav (NIT-Raipur) Date - 10.06.19
;Rule for verb - passive sentences . 
;Replace LBL of parg_d with LBL of v and ARG1 of parg_d with ARG0 of verb 
;Ex. rAvana mArA gayA.
(defrule pargd
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id parg_d ?lbl ?arg2 ?arg4 $?vr)
(MRS_info ?rel ?id ?v ?lbl1 ?arg01 $?var)
(test (neq (str-index "_v_" ?v)FALSE))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" parg_d "?lbl1" " ?arg2 " " ?arg01 " " (implode$ (create$ $?vr)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pargd id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" parg_d " ?lbl1 " " ?arg2 " " ?arg01 " " (implode$ (create$ $?vr)) ")"crlf)

;(printout ?*rstr-fp* "(MRS_info  ?rel "?id" ?v "?lbl1"  " ?arg01 " " (implode$ (create$ $?var)) ")"crlf)
;(printout ?*rstr-dbug* "(rule-rel-values pargd ?rel "?id" ?v " ?lbl1 "  " ?arg01 " " (implode$ (create$ $?var)) ")"crlf)
)



;;for imperative sentence information
(defrule kri-tam-imper
(kriyA-TAM ?kri ?tam)
(sentence_type  imperative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense  ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-imper id-SF-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

; Bind feature values for imperative sentence. Replace ARG0 value of pron and pronoun_q with the ARG1 value of verb
;(MRS_info id-MRS_concept-LBL-ARG0 70000 pron h1 x2)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 70000 pronoun_q h3 x4 h5 h6)
(defrule kriImperPronArg
;(declare (salience 9000))
(sentence_type  imperative)
?f1<-(MRS_info ?rel1 ?kri ?con ?lbl ?arg0 ?arg1  $?var)
?f<-(MRS_info ?rel2 ?pron ?co ?lbl1 ?arg01  $?vars)
(test  (eq pron ?co)) 
(test (neq (str-index "_v_" ?con)FALSE))
(not (already_modified ?kri ARG1  ?arg1))
=>
(retract ?f1 ?f)
(assert (already_modified ?kri ARG1  ?arg01))
(assert (MRS_info  ?rel1 ?kri ?con ?lbl ?arg0  ?arg01 $?var))
;(printout ?*rstr-fp* "(MRS_info " ?rel1 " "?kri" " ?con " "?lbl" " ?arg0 " " ?arg01 " "(implode$ (create$ $?var))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kriImperPronArg MRS_info " ?rel1 " "?kri" " ?con " "?lbl" " ?arg0 " " ?arg01 " "(implode$ (create$ $?var))")"crlf)
)



;for question sentence information
(defrule kri-tam-q
(kriyA-TAM ?kri ?tam)
(sentence_type  question)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense  ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-q id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;Rule for LTOP: The LBL value and ARG0 value of *_v_* becomes the value of LTOP and INDEX if the following words are not there in the sentence: "possibly", "suddenly". "not".If they exist, the LTOP value becomes the LBL value of that word and INDEX value is the ARG0 value of *_v_*. For "not" we get a node "neg" in the MRS
(defrule v-LTOP
;(declare (salience 100))
(MRS_info ?rel ?kri_id ?mrsCon ?lbl ?arg0 $?vars)
=>
(if (or (neq (str-index possible_ ?mrsCon) FALSE) (neq (str-index sudden_ ?mrsCon) FALSE))
then
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values v-LTOP  LTOP-INDEX h0 "?arg0 ")"crlf)
else
    (if (neq (str-index _v_ ?mrsCon) FALSE)
then
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values v-LTOP LTOP-INDEX h0 "?arg0 ")"crlf))  
)     
)

(defrule printFacts
(declare (salience -9000))
(MRS_info ?rel ?kri ?mrsCon $?vars)
;(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info " ?rel " "?kri " "?mrsCon " " (implode$ (create$ $?vars)) ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values printFacts " ?rel " "?kri " "?mrsCon " " (implode$ (create$ $?vars)) ")"crlf)
)
