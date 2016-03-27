

*use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_1998.dta", replace

*gen year=1998


use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_2003.dta", replace

gen year=2003


append using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_2008.dta"

recode year (.=2008)


********************** POOLED DATA MODEL



ta year, g(year)
*	rename year1 year1998
*	rename year2 year2003
*	rename year3 year2008

	rename year1 year2003
	rename year2 year2008

	
********** Section 7.3 The Determinants of Retirement transition;

*** Bivariate probit models - one for husbands and other for wives (present only the model with the best fit, I selected the best model by comparing deviances from alternative specifications);
* Dependent variable: uses information on labor force participation during the year preceding the survey and survey’s reference week to measure retirement flows;
* Control variables: Benefit Rep. Rate (husband and wife), Eligibility Soc. Sec - old age, LS - (husband and wife), Age (husband and wife), education (husband and wife), health status (husband and wife), dependent children (husband and wife) (yes=1), labor status (husband and wife) (formal=1);

** Old system;
biprobit (retirem= rratem rratef agepm lsm agepf lsf agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm lsm agepf lsf agem46 agem47 agem48 agem49 agem50 ///
	agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 ///
	agef66 agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_Table4_pooled.doc", replace

predict p00_old, p00
predict p11_old, p11
predict p01_old, p01
predict p10_old, p10

** New system 1;
biprobit (retirem= rratem rratef agepm lsm agepf1 lsf1 agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm lsm agepf1 lsf1 agem46 agem47 agem48 ///
	agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust
								
predict p00_new1, p00
predict p11_new1, p11
predict p01_new1, p01
predict p10_new1, p10

** New system 2;
biprobit (retirem= rratem rratef agepm2 lsm2 agepf2 lsf2 agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008) (retiref=rratem rratef agepm2 lsm2 agepf2 lsf2 agem46 agem47 agem48 ///
	agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate year2008), robust
								
predict p00_new2, p00
predict p11_new2, p11
predict p01_new2, p01
predict p10_new2, p10



********************* SIMULATION GRAPHS

preserve

drop if gragef==1


**************** POOLED DATA

twoway(lowess p10_old agem, bw(.4)) (lowess p10_new1 agem, bw(.4)) (lowess p10_new2 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\HomemAposentadoMulherNao_poolbiprobit65.pdf", replace


twoway(lowess p01_old agem, bw(.4)) (lowess p01_new1 agem, bw(.4)) (lowess p01_new2 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\MulherAposentadaHomemNao_poolbiprobit65.pdf", replace


twoway(lowess p11_old agem, bw(.4)) (lowess p11_new1 agem, bw(.4)) (lowess p11_new2 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosAposentados_poolbiprobit65.pdf", replace


twoway(lowess p00_old agem, bw(.4)) (lowess p00_new1 agem, bw(.4)) (lowess p00_new2 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosNaoAposentados_poolbiprobit65.pdf", replace



**************** DATA BY YEARS


************ Equalizing the age at retirement for both men and women: 65

twoway(lowess p10_old1_08 agem, bw(.4)) (lowess p10_old1_03 agem, bw(.4)) (lowess p10_new1_08 agem, bw(.4)) (lowess p10_new1_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\HomemAposentadoMulherNao_biprobit65.pdf", replace


twoway(lowess p01_old1_08 agem, bw(.4)) (lowess p01_old1_03 agem, bw(.4)) (lowess p01_new1_08 agem, bw(.4)) (lowess p01_new1_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\MulherAposentadaHomemNao_biprobit65.pdf", replace


twoway(lowess p11_old1_08 agem, bw(.4)) (lowess p11_old1_03 agem, bw(.4)) (lowess p11_new1_08 agem, bw(.4)) (lowess p11_new1_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosAposentados_biprobit65.pdf", replace


twoway(lowess p00_old1_08 agem, bw(.4)) (lowess p00_old1_03 agem, bw(.4)) (lowess p00_new1_08 agem, bw(.4)) (lowess p00_new1_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosNaoAposentados_biprobit65.pdf", replace


	

************ Rising the age at retirement for both men and women: 68

twoway(lowess p10_old2_08 agem, bw(.4)) (lowess p10_old2_03 agem, bw(.4)) (lowess p10_new2_08 agem, bw(.4)) (lowess p10_new2_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\HomemAposentadoMulherNao_biprobit68.pdf", replace


twoway(lowess p01_old2_08 agem, bw(.4)) (lowess p01_old2_03 agem, bw(.4)) (lowess p01_new2_08 agem, bw(.4)) (lowess p01_new2_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\MulherAposentadaHomemNao_biprobit68.pdf", replace


twoway(lowess p11_old2_08 agem, bw(.4)) (lowess p11_old2_03 agem, bw(.4)) (lowess p11_new2_08 agem, bw(.4)) (lowess p11_new2_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosAposentados_biprobit68.pdf", replace


twoway(lowess p00_old2_08 agem, bw(.4)) (lowess p00_old2_03 agem, bw(.4)) (lowess p00_new2_08 agem, bw(.4)) (lowess p00_new2_03 agem, bw(.4)), yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white))

	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosNaoAposentados_biprobit68.pdf", replace


restore




************* ABRINDO OS GRÁFICOS

**************** POOLED DATA

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\HomemAposentadoMulherNao_poolbiprobit65.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\MulherAposentadaHomemNao_poolbiprobit65.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosAposentados_poolbiprobit65.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosNaoAposentados_poolbiprobit65.pdf"



**************** DATA BY YEARS

************ Equalizing the age at retirement for both men and women: 65

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\HomemAposentadoMulherNao_biprobit65.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\MulherAposentadaHomemNao_biprobit65.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosAposentados_biprobit65.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosNaoAposentados_biprobit65.pdf"


************ Rising the age at retirement for both men and women: 68

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\HomemAposentadoMulherNao_biprobit68.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\MulherAposentadaHomemNao_biprobit68.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosAposentados_biprobit68.pdf"

	graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\AmbosNaoAposentados_biprobit68.pdf"



saveold "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_pooled.dta", replace



	preserve 
	
	keep if agem>=55
	
	
twoway(lowess p00_old1_08 agem, bw(.4)) ///
		(lowess p00_new1_08 agem, bw(.4)) ///
		(lowess p00_new2_08 agem, bw(.4)), yscale(range(.1 .8)) ylabel(.1(.1).8) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados_08.pdf", replace
	
	
twoway(lowess p00_old1_03 agem, bw(.4)) ///
		(lowess p00_new1_03 agem, bw(.4)) ///
		(lowess p00_new2_03 agem, bw(.4)), yscale(range(.1 .8)) ylabel(.1(.1).8) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados_03.pdf", replace

	
twoway(lowess p11_old1_08 agem, bw(.4)) ///
		(lowess p11_new1_08 agem, bw(.4)) ///
		(lowess p11_new2_08 agem, bw(.4)), yscale(range(.1 .4)) ylabel(.1(.1).4) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados_08.pdf", replace


twoway(lowess p11_old1_03 agem, bw(.4)) ///
		(lowess p11_new1_03 agem, bw(.4)) ///
		(lowess p11_new2_03 agem, bw(.4)), yscale(range(.1 .4)) ylabel(.1(.1).4) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados_03.pdf", replace

	
twoway(lowess p01_old1_08 agem, bw(.4)) ///
		(lowess p01_new1_08 agem, bw(.4)) ///
		(lowess p01_new2_08 agem, bw(.4)), yscale(range(0 .1)) ylabel(0(.1).1) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada_08.pdf", replace


twoway(lowess p01_old1_03 agem, bw(.4)) ///
		(lowess p01_new1_03 agem, bw(.4)) ///
		(lowess p01_new2_03 agem, bw(.4)), yscale(range(0 .1)) ylabel(0(.1).1) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada_03.pdf", replace

	
twoway(lowess p10_old1_08 agem, bw(.4)) ///
		(lowess p10_new1_08 agem, bw(.4)) ///
		(lowess p10_new2_08 agem, bw(.4)), yscale(range(.1 .6)) ylabel(.1(.1).6) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado_08.pdf", replace


twoway(lowess p10_old1_03 agem, bw(.4)) ///
		(lowess p10_new1_03 agem, bw(.4)) ///
		(lowess p10_new2_03 agem, bw(.4)), yscale(range(.1 .6)) ylabel(.1(.1).6) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"))
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado_03.pdf", replace

		
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados_03.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados_08.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados_03.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados_08.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada_03.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada_08.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado_03.pdf"
		graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado_08.pdf"


		restore
		
		
************************* AFTER REVIEW 2
		
		
		
****** MODEL INCORPORATING THE RETIREMENT OF THE PARTNER ON OWN DECISION OF RETIREMENT (FOR THAT MATTER, WE EXCLUDE EVERY VARIABLE RELATED TO LABOUR MARKET)
		
biprobit (retirem= retirementf rratem rratef agepm lsm agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm pos1m pibrate unemprate year2008) (retiref= retirementm rratem rratef agepf lsf agem46 agem47 agem48 agem49 agem50 ///
	agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 ///
	agef66 agef67 agef68 agef6970 educm educf healthm healthf hhtype actf pos1f pibrate unemprate year2008), robust
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_Table4_pooled.doc", append

	
		
****** NEW FIGURE 1



/* Husbands and Wifes in the Labor Force - 2003 and 2008 */


* Husbands
preserve
collapse (sum) man actm, by(agem year)
gen pea2003 = actm/man if year==2003
gen pea2008 = actm/man if year==2008
twoway (line pea2003 agem) (line pea2008 agem), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "2003"  2 "2008"))
graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH1_husbands_mar2016.pdf" , replace
restore


* Wives
preserve
collapse (sum) woman actf, by(agem year)
gen pea2003 = actf/woman if year==2003
gen pea2008 = actf/woman if year==2008
twoway (line pea2003 agem) (line pea2008 agem), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "2003"  2 "2008"))
graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH1_wives_mar2016.pdf" , replace
restore

