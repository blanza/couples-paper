
use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_2003.dta", replace

gen year=2003


append using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_2008.dta"

recode year (.=2008)


********************** POOLED DATA MODEL



ta year, g(year)

	rename year1 year2003
	rename year2 year2008

	
********** SIMULATION ESTIMATION;

*** Bivariate probit models - one for husbands and other for wives (present only the model with the best fit, I selected the best model by comparing deviances from alternative specifications);
* Dependent variable: uses information on labor force participation during the year preceding the survey and survey’s reference week to measure retirement flows;
* Control variables: Benefit Rep. Rate (husband and wife), Eligibility Soc. Sec - old age, LS - (husband and wife), Age (husband and wife), education (husband and wife), health status (husband and wife), dependent children (husband and wife) (yes=1), labor status (husband and wife) (formal=1);

** Old system;
biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm lsm agepf lsf agem ///
	agef educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust

predict p00_old, p00
predict p11_old, p11
predict p01_old, p01
predict p10_old, p10

** New system 1;
biprobit (retirem= rratem rratef agepm lsm agepf1 lsf1 agem agef ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm lsm agepf1 lsf1 agem46 agem47 agem48 ///
	agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust
								
predict p00_new1, p00
predict p11_new1, p11
predict p01_new1, p01
predict p10_new1, p10

** New system 2;
biprobit (retirem= rratem rratef agepm2 lsm2 agepf2 lsf2 agem agef ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm2 lsm2 agepf2 lsf2 agem ///
	agef educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust
								
predict p00_new2, p00
predict p11_new2, p11
predict p01_new2, p01
predict p10_new2, p10


*** AFTER REVIEW 3: present results from a univariate model without family controls (comparison with Figure 3)


** Old system;
probit retirem rratem agepm lsm agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	educm healthm actm pos1m pibrate unemprate year2008

***mfx compute
predict pm_old

		
probit retiref rratef agepf lsf ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 ///
	agef66 agef67 agef68 agef6970 educf healthf actf pos1f pibrate unemprate year2008, robust

***mfx compute
predict pf_old


** New system 1;
probit retirem rratem agepm lsm agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	educm healthm actm pos1m pibrate unemprate year2008

*mfx compute
predict pm_new1

		
probit retiref rratef agepf1 lsf1 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educf healthf actf pos1f pibrate unemprate year2008, robust

*mfx compute
predict pf_new1


** New system 2;
probit retirem rratem agepm2 lsm2 agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	educm healthm actm pos1m pibrate unemprate year2008

*mfx compute
predict pm_new2

probit retiref rratef agepf2 lsf2 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educf healthf actf pos1f pibrate unemprate year2008, robust

*mfx compute
predict pf_new2





********************* SIMULATION GRAPHS

preserve

keep if agem>=55
*drop if gragef==1

keep if agef > 54 

keep if agef < 70

keep if year==2008


**************** POOLED DATA ESTIMATION - RESULTS FOR YEAR 2008 ONLY

	
twoway(lowess p00_old1 agem, bw(.4)) ///
		(lowess p00_new1 agem, bw(.4)) ///
		(lowess p00_new2 agem, bw(.4)), yscale(range(.1 .8)) ylabel(.1(.1).8) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados.pdf", replace
	
	
twoway(lowess p11_old1 agem, bw(.4)) ///
		(lowess p11_new1 agem, bw(.4)) ///
		(lowess p11_new2 agem, bw(.4)), yscale(range(.1 .5)) ylabel(.1(.1).5) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados.pdf", replace


twoway(lowess p01_old1 agem, bw(.4)) ///
		(lowess p01_new1 agem, bw(.4)) ///
		(lowess p01_new2 agem, bw(.4)), yscale(range(0 .2)) ylabel(0(.1).2) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada.pdf", replace

	
twoway(lowess p10_old1 agem, bw(.4)) ///
		(lowess p10_new1 agem, bw(.4)) ///
		(lowess p10_new2 agem, bw(.4)), yscale(range(.1 .5)) ylabel(.1(.1).5) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado.pdf", replace

	
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados.pdf"
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados.pdf"
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada.pdf"
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado.pdf"


					
*** AFTER REVIEW 3: present results from a univariate model without family controls (comparison with Figure 3) - RESULTS FOR 2008 ONLY

	*** Husbands
twoway(lowess pm_old agem, bw(.4)) ///
		(lowess pm_new1 agem, bw(.4)) ///
		(lowess pm_new2 agem, bw(.4)), yscale(range(.1 .9)) ylabel(.1(.1).9) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\probitMarido.pdf", replace

	*** Wives
twoway(lowess pf_old agem, bw(.4)) ///
		(lowess pf_new1 agem, bw(.4)) ///
		(lowess pf_new2 agem, bw(.4)), yscale(range(.1 .5)) ylabel(.1(.1).5) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\probitEsposa.pdf", replace

		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\probitMarido.pdf"
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\probitEsposa.pdf"



restore


saveold "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_pooled.dta", replace


*********** FINAL MODEL

biprobit (retirem= rratem rratef agepm lsm agepf lsf agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm lsm agepf lsf agem46 agem47 agem48 agem49 agem50 ///
	agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 ///
	agef66 agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust
	outreg2 using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_Table4_pooled.doc", replace
		
	margins, dydx(_all) post
	
	
************************* AFTER REVIEW 2
		
		
		
****** MODEL INCORPORATING THE RETIREMENT OF THE PARTNER ON OWN DECISION OF RETIREMENT (FOR THAT MATTER, WE EXCLUDE EVERY VARIABLE RELATED TO LABOUR MARKET)
		
biprobit (retirem= retirementf rratem rratef agepm lsm agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm pos1m pibrate unemprate year2008) (retiref= retirementm rratem rratef agepf lsf agem46 agem47 agem48 agem49 agem50 ///
	agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 ///
	agef66 agef67 agef68 agef6970 educm educf healthm healthf hhtype actf pos1f pibrate unemprate year2008), robust
	outreg2 using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_Table4_pooled.doc", append

	margins, dydx(_all) post

	
****** NEW FIGURE 1



/* Husbands and Wifes in the Labor Force - 2003 and 2008 */


* Husbands
preserve
collapse (sum) man actm, by(agem year)
gen pea2003 = actm/man if year==2003
gen pea2008 = actm/man if year==2008
twoway (line pea2003 agem) (line pea2008 agem), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "2003"  2 "2008"))
graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH1_husbands_mar2016.pdf" , replace
restore


* Wives
preserve
collapse (sum) woman actf, by(agem year)
gen pea2003 = actf/woman if year==2003
gen pea2008 = actf/woman if year==2008
twoway (line pea2003 agem) (line pea2008 agem), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "2003"  2 "2008"))
graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH1_wives_mar2016.pdf" , replace
restore

