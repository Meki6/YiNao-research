use "C:\Users\Maggie Liu\Desktop\research\CFPS\CFPS2018年数据\最新\cfps2018person_202012.dta" 
*data processing
summarize qn10026
gen trust_doc=qn10026 if qn10026 >=0
summarize trust_doc
gen med_prob=qn6016 if qn6016 >=0
summarize med_prob
summarize qp601
gen hospital=qp601 if qp601 >=0
tab hospital
gen hosp_satisfy=qp602 if qp602>=0
summarize hosp_satisfy
gen hosp_quality=qp603 if qp603>=0
summarize hosp_quality
gen trust=qn1001 if qn1001>0
reg trust_doc trust

summarize qp702 if qp702>=0
summarize qc701 if qc701>=0
summarize metotal
summarize metotal if metotal >= 0

tab qbb01
tab qbb001
tab qn103
tab qn104
reg trust_doc trust hospital hosp_satisfy hosp_quality med_prob

*generate binary variable
gen trust_doc_01 = 1 if trust_doc>=5
order trust_doc_01
replace trust_doc_01=0 if trust_doc_01=.
replace trust_doc_01=0 if trust_doc_01==.

tab gender
tab marriage_last
gen marr=1 if marriage_last==1
gen marr=0 if marriage_last>=2
replace marr=0 if marriage_last>=2
replace marr=0 if marriage_last==1
replace marr=1 if marriage_last==2
replace marr=0 if marriage_last>=3
tab age
gen age2=age*age
order marr age2
order age
order qa302 qa301
tab qa201
tab qa301
tab qa301 if qa301==1

*tab to check the code
gen hanzu=1 if qa701code==1
tab qa701code qa701code==1
tab qa701code if qa701code==1
tab qa701code if qa701code>=2
replace hanzu=0 if qa701code>=2

order hanzu
tab qn4004
order party
tab party
tab qn4001
tab gender if gender==0
replace party=0 if party!=1
order pg1201_min pg1201_max
order cfps2018eduy cfps2018edu cfps2018eduy_im
order pg12
gen wage = (pg1201_min+pg1201_max)/2
order wage
tab wage
order qp201
order qp202
tab qp201
gen health_status = qp201
tab qp202
gen health_change = qp202
summarize qp201
summarize qp202
replace healthstatus = qp201 if qp201>=0
gen healthstatus = qp201 if qp201>=0
gen healthchange = qp202 if qp202>=0
order healthstatus healthchange
tab cfps2018eduy
gen edu= cfps2018eduy
tab qg6
gen workhrs=qg6
order workhrs
order employ

*generate 4 districts using provinceid
tab provcd18
tab provcd18 if provcd18==110000
tab provcd18 if provcd18==1
summarize provcd18
tab provcd18 if provcd18==11
gen district_east=1 if (provcd18==11 or provcd18==12)
gen district_east=1 if (provcd18==11 | provcd18==12)
replace district_east=1 if (provcd18==13 | provcd18==31|provcd18==32|provcd18==33|provcd18==35|provcd18==37|provcd18==44|provcd18==46)
replace district_east=0 if district_east==.
gen district_mid=1 if (provcd18==14| provcd18==34|provcd18==36|provcd18==41|provcd18==42|provcd18==43)
replace district_mid=0 if district_mid==.
gen district_eastnor=1 if 20<provcd18<=23
replace district_eastnor=0 if district_eastnor==.
order district_eastnor
drop district_eastnor
gen district_eastnor=1 if (provcd18==23|provcd18==22|provcd18==21)
replace district_eastnor=0 if district_eastnor==.
gen district_west=1 if (provcd18==15 | provcd18==45|provcd18==50|provcd18==51|provcd18==52|provcd18==53|provcd18==54|provcd18==61|provcd18==62|provcd18==63|provcd18==64|provcd18==65)
replace district_west=0 if district_west==.

gen medinsur_cover = metotal-qc701
order medinsur_cover
summarize medinsur_cover
order qc701
gen medinsur=0 if qp605_a_78==1
replace medinsur=1 if medinsur==.
order medinsur
order medinsur medinsur_cover employ workhrs healthstatus healthchange wage party hanzu urban age marr age2 metotal med_prob hosp_satisfy hosp_quality trust gender edu retire trust_doc_01 hospital trust_doc district_east district_mid district_eastnor district_west
summarize qu250m
gen Ihrs=qu250m if qu250m>=0
summarize qu1m
tab qu1m
tab qu704
tab qu802
tab qu802 if qu802>=0
gen internet_info = qu802 if qu802>=0
tab internet_info
tab medinsur
tab medinsur_cover
tab employ
tab workhrs
tab healthstatus
tab healthchange
tab wage
probit trust_doc_01 trust hospital hosp_satisfy hosp_quality med_prob internet_info medinsur qc701 employ workhrs healthstatus healthchange party hanzu urban age age2 marr gender edu retire district_east district_mid district_eastnor
tab party
tab hanzu
probit trust_doc_01 trust hospital hosp_satisfy hosp_quality med_prob internet_info medinsur qc701 employ workhrs healthstatus healthchange party urban age age2 marr gender edu retire district_east district_mid district_eastnor
tab retire
summarize metotal
summarize qc701
gen med_exp_self = qc701 if qc701>=0

*probit model
probit trust_doc_01 trust hospital hosp_satisfy hosp_quality med_prob internet_info medinsur employ workhrs healthstatus healthchange party urban age age2 marr gender edu retire district_east district_mid district_eastnor
estimate store tab1

*calculate the marginal effects (coefficients are not marginal effects in probit model)
mfx
estimate store tab2
esttab tab1 tab2, ar2 b(3) t(3)  star(* 0.10 ** 0.05 *** 0.01)

save "C:\Users\Maggie Liu\Desktop\research\CFPS2018_1.dta"