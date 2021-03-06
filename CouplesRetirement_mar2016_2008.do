
capture log close

log using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\Descriptive&Models_08_jan2016.log", replace

* do "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Do\3.CouplesRetirement_08_01.16.11.txt"



** Caminho pra rodar no meu computador: "C:\Laeticia\"
** Caminho pra rodar no sistema Winstat: "\\Client\C$\Laeticia\"


set more off
clear all
set mem 500m


/***********************************************
*     Stata Program PNAD 2008                  *
*     Retirement Behavior - Females            *
*     10/10/2011                               *
***********************************************/


# delimit ;

infix
double controlserie 5-15         /*numero de serie e controle*/
uf          		5-6          /*uf de residencia*/
double control	    5-12         /*numero de controle*/
double serie       	13-15        /*numero de serie*/
sexf        		18           /*sexo da pessoa*/
agef        		27-29        /*idade em anos*/
conddf      		30           /*condicao no domicilio*/
condff      		31           /*condicao na familia*/
nfamilia    		32           /*numero da familia*/
colorf      		33           /*cor ou raca*/
trabwef     		86           /*trabalhou na semana de referencia*/
hoursf      		345-346      /*numero de horas trabalhadas*/
ssectf      		347          /*contribuiu para previdencia na semana*/
kindsf      		348          /*tipo de previdencia*/
trabyf      		359          /*trabalhou no ano de referencia*/
cartyf      		383          /*carteira no trabalho ano*/
previf      		485          /*contribuiu previdencia trabalho no ano*/
cagetf      		492          /*codigo idade comecou a trabalhar*/
agestf      		493-494      /*idade comecou trabalhar*/
aposef      		501          /*aposentado na semana de referencia*/
pensf       		502          /*pensionista na semana de refencia*/
renapf      		506-517      /*rendimento de aposentadoria*/
renpef      		520-531      /*rendimento de pensao*/
educf       		654-655      /*anos de estudo*/
codwf       		656          /*condicao de atividade na semana*/
ocupwf      		657          /*condicao de ocupacao na semana*/
posocuwf    		658-659      /*posicao na ocupacao na semana*/
ramowf      		662-663      /*ramo da ocupacao na semana*/
gropwf      		664-665      /*grupo ocupacao na semana*/
codyf       		668          /*condicao de atividae no ano*/
ocupyf      		669          /*condicao ocupacao no ano*/
posoyf      		670-671      /*posicao ocupacao no ano*/
ramoyf      		672-673      /*ramo de ocupacao no ano*/
grupyf      		674-675      /*grupo de ocupacao no ano*/
rendaf      		676-687      /*rendimento do trabalho principal*/
rendtf      		688-699      /*rendimento todos os trabalhos*/
rendtof     		700-711      /*rendimento de todas as fontes*/ 
hhtypf      		736-737      /*tipo de familia*/
urbanf      		741          /*Situa��o - Urbano/Rural*/
pesopf      		742-746      /*peso da pessoa*/
saudef      		1212         /*estado de saude*/
problsf     		1213         /*deixou de realizar atividade habitual nas ultimas duas semanas*/
colunaf    			1221         /*doenca de coluna*/
artritef    		1222         /*tem artrite*/
cancerf     		1223         /*tem cancer*/
diabetef    		1224         /*tem diabetes*/
respiraf    		1225         /*doenca respiratoria*/
hipertef    		1226         /*hipertensao*/
coracaof    		1227         /*doenca coracao*/
renalf      		1228         /*doenca renal cronica*/
depresf     		1229         /*depressao*/
tubercf     		1230         /*tuberculose*/
tendinf     		1231         /*tendinite*/
cirrosf     		1232         /*tem cirrose*/
using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\Back-up_29.03.10\Demografia\Bases de Dados\Pnads\Pnad_2008\Dados\PES2008.txt"
;


count;



*************************************;
/* RECODING MISSINGS - TERMINAR ISSO AINDA... */

recode colorf (9=.); 
recode educf (17=.);
recode codwf (3=.);
recode codyf (3=.);
recode agef (999=.);
recode agestf (99=.);

*************************************;

/*Couple status*/

gen chefeH_conjugeM=0; 
	replace chefeH_conjugeM=1 if condff==1 & sexf==2;
	replace chefeH_conjugeM=1 if condff==2 & sexf==4;
	
	bysort controlserie nfamilia: egen somaChH_ConM=sum(chefeH_conjugeM);

drop chefeH_conjugeM;

gen chefeM_conjugeH=0;
	replace chefeM_conjugeH=1 if condff==1 & sexf==4;
	replace chefeM_conjugeH=1 if condff==2 & sexf==2;

	bysort controlserie nfamilia: egen somaChM_ConH=sum(chefeM_conjugeH);

drop chefeM_conjugeH;


	/*Dummy "couple": 1=couple; 0=no couple*/

gen couple=0;
	replace couple=1 if somaChH_ConM==2;
	replace couple=1 if somaChM_ConH==2;

drop somaChH_ConM somaChM_ConH;


**** Gerando a vari�vel de casais de outra forma, s� pra conferir:;
gen couple2_temp=1 if condff==1 | condff==2;
	replace couple2_temp=0 if condff~=1 & condff~=2;

bysort controlserie nfamilia: egen couple2 = total(couple2_temp);

drop couple2_temp;

/* Mantendo apenas os casais */
keep if couple==1;

/* Mantendo apenas os casais para os quais existe informa��o sobre as vari�veis que nos interessam */
*keep if educf~=. & colorf~=. & codwf~=. & codyf~=. & agef~=.;

**** VER COMO COLOC�-LAS NESSE KEEP TB: previf~=. & ramoyf~=. & posoyf~=. & saudef~=. & agestf~=.
count;



/* working only with females between 45 and 70 years of age in urban areas */


keep if sexf==4; /*feminino*/
keep if condff>=1 & condff<=2; /*reference or conjuge*/
keep if agef>=45 & agef<=70;
***** SEM RESTRINGIR A URBANO, OS GR�FICOS FICAM EXATAMENTE IGUAIS AO DO PAPER ORIGINAL;
keep if urbanf>=1 & urbanf<=3;




/* Dummy defining females between ages 45 and 70 */


gen f45_70=1 if agef>=45 & agef<=70;
	replace f45_70=0 if agef<45 | (agef>70 & agef~=.);




count;


/*defining the age groups*/
gen gragef=1 if agef>=45 & agef<=49;
	replace gragef=2 if agef>=50 & agef<=54;
	replace gragef=3 if agef>=55 & agef<=59;
	replace gragef=4 if agef>=60 & agef<=64;
	replace gragef=5 if agef>=65 & agef<=70;



/*defining years of schooling*/
gen greducf=1 if educf>=1 & educf<=5;          		/*menos de 4 anos de estudo*/
	replace greducf=2 if educf>=6 & educf<=9;       /*entre 5 e 8 anos de estudo*/
	replace greducf=3 if educf>=10 & educf<=12;	/*entre 9 e 11 anos de estudo*/
	replace greducf=4 if educf>=13 & educf~=.;	/*mais de 12 anos de estudo*/



/*defining region of residence*/

gen uff=uf;

gen regionf=1 if uff>=11 & uff<=17;      		/*norte*/
	replace regionf=2 if uff>=21 & uff<=29;     	/*nordeste*/
	replace regionf=3 if uff>=31 & uff<=35;		/*sudeste*/
	replace regionf=4 if uff>=41 & uff<=43;		/*sul*/
	replace regionf=5 if uff>=51 & uff<=53;		/*centro-oeste*/



/*aggregating posicao na ocupacao no ano*/
gen posicaof=1 if posoyf>=1 & posoyf<=3;		/*com carteira*/
	replace posicaof=2 if posoyf>=4 & posoyf<=8;	/*sem carteira*/
	replace posicaof=3 if posoyf>=9 & posoyf<=10;	/*conta propria, empregador*/
	replace posicaof=4 if posoyf>=11 & posoyf~=.;	/*outros*/



/*aggregating ramo de ocupacao no ano*/
gen ramof=1 if ramoyf==1; 				/*agricola*/
	replace ramof=2 if ramoyf>=2 & ramoyf<=4;	/*industria*/
	replace ramof=3 if ramoyf>=5 & ramoyf<=8;	/*comercio e servicos, transporte e comunicacao*/
	replace ramof=4 if ramoyf>=9 & ramoyf<=10;	/*social e administracao publica*/
	replace ramof=5 if ramoyf>=11;			/*outras ou mal definidas*/



/*aggregating occupation*/
gen grupof=1 if grupyf==1 | grupyf==2; 			/*mais qualificado*/
	replace grupof=2 if grupyf==3;			/*agricola*/
	replace grupof=3 if grupyf>=4 & grupyf<=7;	/*nivel medio*/
	replace grupof=4 if grupyf==8;			/*outros*/



/*CREATING THE OUTCOME VARIABLES*/

/*defining retirement flows based on economicamente ativo ou nao - flow */
gen retirementf=0 if codyf==1 & codwf==1;
	replace retirementf=1 if codyf==1 & codwf==2;



/*now working only with those who were occupied a year ago and retired now - flow */
gen retiref=1 if ocupyf==1 & aposef==2;
	replace retiref=0 if ocupyf==1 & aposef==4;



/*just analyzing the stock of retirees*/
gen aposentadof=1 if aposef==2;
	replace aposentadof=0 if aposef==4;



/*Condicao de Atividade na Semana*/
gen actf=1 if codwf==1;
	replace actf=0 if codwf==2;



/*To count females*/

gen woman = 1;



/*To count females on the labor force participation*/

gen woman_LF = 1 if codyf==1;






/*CREATING SOME OF THE BINARY EXPLANATORY VARIABLES*/

/*FOR COLOR OR RACE - BASELINE IS NON-WHITE*/
gen race1f=1 if colorf==2;
	replace race1f=0 if colorf~=2 & colorf~=.;



/*FOR AGE - BASELINE IS 45-49*/
ta gragef, g(agef);
	rename agef1 age0f;
	rename agef2 age1f;
	rename agef3 age2f;
	rename agef4 age3f;
	rename agef5 age4f;



/*FOR EDUCATIONAL GROUP - BASELINE IS LESS THAN 4 YEARS OF SCHOOLING*/
ta greducf, g(educf);
	rename educf1 educ0f;
	rename educf2 educ1f;
	rename educf3 educ2f;
	rename educf4 educ3f;



/*FOR REGION OF RESIDENCE - BASELINE IS NORTHEAST*/
ta regionf, g(regionf);
	rename regionf1 region1f;
	rename regionf2 region0f;
	rename regionf3 region2f;
	rename regionf4 region3f;
	rename regionf5 region4f;



/*PAID SOCIAL SECURITY IN PREVIOUS WORK - BASELINE IS NO*/
gen previ1f=1 if previf==1;
	replace previ1f=0 if previf==3;



/*OCCUPATIONAL GROUP - BASELINE IS SOCIAL E ADMINISTRACAO PUBLICA*/
ta ramof, g(ramof);
	rename ramof1 ramo1f;
	rename ramof2 ramo2f;
	rename ramof3 ramo3f;
	rename ramof4 ramo0f;
	rename ramof5 ramo4f;



/*POSICAO NA OCUPACAO - BASELINE IS EMPREGADOR E CONTA PROPRIA*/
ta posicaof, g(posf);
	rename posf1 pos1f;
	rename posf2 pos2f;
	rename posf3 pos0f;
	rename posf4 pos3f;
	
	
	
/*WORK TENURE: review1*/

gen expf = agef - (educf + 6);

gen expf2 = agef - agestf;



/*Health Status and Disease*/
gen healthf=1 if saudef>=3 & saudef~=.; 	/*Fair or Bad Health*/
	replace healthf=0 if saudef<=2; 	/*Good and Excelent Health*/ 



/*Years of Contribution*/
gen ycon1f = agef - educf; 	/*Based on Education Years*/
gen ycon2f = agef - agestf; 	/*Based on when started to work*/

gen agepf=1 if agef>=60 & agef~=.;
	replace agepf=0 if agef<=59;



count;


sort controlserie nfamilia;

saveold "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.females08.dta", replace;



clear;

/***********************************************
*     Stata Program PNAD 2008                  *
*     Retirement Behavior - Males              *
*     10/10/2011                               *
***********************************************/



infix
double controlserie    	5-15         /*numero de serie e controle*/
uf          		5-6          /*uf de residencia*/
double control	    	5-12         /*numero de controle*/
double serie       	13-15        /*numero de serie*/
sexm        		18           /*sexo da pessoa*/
agem        		27-29        /*idade em anos*/
conddm      		30           /*condicao no domicilio*/
condfm      		31           /*condicao na familia*/
nfamilia    		32           /*numero da familia*/
colorm      		33           /*cor ou raca*/
trabwem     		86           /*trabalhou na semana de referencia*/
hoursm      		345-346      /*numero de horas trabalhadas*/
ssectm      		347          /*contribuiu para previdencia na semana*/
kindsm      		348          /*tipo de previdencia*/
trabym      		359          /*trabalhou no ano de referencia*/
cartym      		383          /*carteira no trabalho ano*/
previm      		485          /*contribuiu previdencia trabalho no ano*/
cagetm      		492          /*codigo idade comecou a trabalhar*/
agestm      		493-494      /*idade comecou trabalhar*/
aposem      		501          /*aposentado na semana de referencia*/
pensm       		502          /*pensionista na semana de refencia*/
renapm      		506-517      /*rendimento de aposentadoria*/
renpem      		520-531      /*rendimento de pensao*/
educm       		654-655      /*anos de estudo*/
codwm       		656          /*condicao de atividade na semana*/
ocupwm      		657          /*condicao de ocupacao na semana*/
posocuwm    		658-659      /*posicao na ocupacao na semana*/
ramowm      		662-663      /*ramo da ocupacao na semana*/
gropwm      		664-665      /*grupo ocupacao na semana*/
codym       		668          /*condicao de atividae no ano*/
ocupym      		669          /*condicao ocupacao no ano*/
posoym      		670-671      /*posicao ocupacao no ano*/
ramoym      		672-673      /*ramo de ocupacao no ano*/
grupym      		674-675      /*grupo de ocupacao no ano*/
rendam      		676-687      /*rendimento do trabalho principal*/
rendtm      		688-699      /*rendimento todos os trabalhos*/
rendtom     		700-711      /*rendimento de todas as fontes*/ 
hhtypm      		736-737      /*tipo de familia*/
urbanm      		741          /*Situa��o - Urbano/Rural*/
pesopm      		742-746      /*peso da pessoa*/
saudem      		1212         /*estado de saude*/
problsm     		1213         /*deixou de realizar atividade habitual nas ultimas duas semanas*/
colunam    		1221         /*doenca de coluna*/
artritem    		1222         /*tem artrite*/
cancerm     		1223         /*tem cancer*/
diabetem    		1224         /*tem diabetes*/
respiram    		1225         /*doenca respiratoria*/
hipertem    		1226         /*hipertensao*/
coracaom    		1227         /*doenca coracao*/
renalm      		1228         /*doenca renal cronica*/
depresm     		1229         /*depressao*/
tubercm     		1230         /*tuberculose*/
tendinm     		1231         /*tendinite*/
cirrosm     		1232         /*tem cirrose*/
using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\Back-up_29.03.10\Demografia\Bases de Dados\Pnads\Pnad_2008\Dados\PES2008.txt"
;


count;


*************************************;
/* RECODING MISSINGS - TERMINAR ISSO AINDA... */

recode colorm (9=.);
recode educm (17=.);
recode codwm (3=.);
recode codym (3=.);
recode agem (999=.);
recode agestm (99=.);

*************************************;

/*Couple status*/

gen chefeH_conjugeM=0; 
	replace chefeH_conjugeM=1 if condfm==1 & sexm==2;
	replace chefeH_conjugeM=1 if condfm==2 & sexm==4;
	
	bysort controlserie nfamilia: egen somaChH_ConM=sum(chefeH_conjugeM);

drop chefeH_conjugeM;

gen chefeM_conjugeH=0;
	replace chefeM_conjugeH=1 if condfm==1 & sexm==4;
	replace chefeM_conjugeH=1 if condfm==2 & sexm==2;

	bysort controlserie nfamilia: egen somaChM_ConH=sum(chefeM_conjugeH);

drop chefeM_conjugeH;


	/*Dummy "couple": 1=couple; 0=no couple*/

gen couple=0;
	replace couple=1 if somaChH_ConM==2;
	replace couple=1 if somaChM_ConH==2;

drop somaChH_ConM somaChM_ConH;


/* Mantendo apenas os casais */
keep if couple==1;

/* Mantendo apenas os casais para os quais existe informa��o sobre as vari�veis que nos interessam */
*keep if educm~=. & colorm~=. & codwm~=. & codym~=. & agem~=.;

**** VER COMO COLOC�-LAS NESSE KEEP TB: previm~=. & ramoym~=. & posoym~=. & saudem~=. & agestm~=.
count;



/* working only with males between 45 and 70 years of age*/


keep if sexm==2; /*masculino*/
keep if condfm>=1 & condfm<=2;  /*reference or conjuge*/
keep if agem>=45 & agem<=70;
***** SEM RESTRINGIR A URBANO, OS GR�FICOS FICAM EXATAMENTE IGUAIS AO DO PAPER ORIGINAL;
keep if urbanm>=1 & urbanm<=3;




/* Dummy defining males between ages 45 and 70 */


gen m45_70=1 if agem>=45 & agem<=70;
	replace m45_70=0 if agem<45 | (agem>70 & agem~=.);



count;



/*defining the age groups*/
gen gragem=1 if agem>=45 & agem<=49;
	replace gragem=2 if agem>=50 & agem<=54;
	replace gragem=3 if agem>=55 & agem<=59;
	replace gragem=4 if agem>=60 & agem<=64;
	replace gragem=5 if agem>=65 & agem<=70;



/*defining years of schooling*/
gen greducm=1 if educm>=1 & educm<=5;          		/*menos de 4 anos de estudo*/
	replace greducm=2 if educm>=6 & educm<=9;       /*entre 5 e 8 anos de estudo*/
	replace greducm=3 if educm>=10 & educm<=12;	/*entre 9 e 11 anos de estudo*/
	replace greducm=4 if educm>=13 & educm~=.;	/*mais de 12 anos de estudo*/



/*defining region of residence*/

gen ufm=uf;

gen regionm=1 if ufm>=11 & ufm<=17;      		/*norte*/
	replace regionm=2 if ufm>=21 & ufm<=29;     	/*nordeste*/
	replace regionm=3 if ufm>=31 & ufm<=35;		/*sudeste*/
	replace regionm=4 if ufm>=41 & ufm<=43;		/*sul*/
	replace regionm=5 if ufm>=51 & ufm<=53;		/*centro-oeste*/



/*aggregating posicao na ocupacao no ano*/
gen posicaom=1 if posoym>=1 & posoym<=3;		/*com carteira*/
	replace posicaom=2 if posoym>=4 & posoym<=8;	/*sem carteira*/
	replace posicaom=3 if posoym>=9 & posoym<=10;	/*conta propria, empregador*/
	replace posicaom=4 if posoym>=11 & posoym~=.;	/*outros*/



/*aggregating ramo de ocupacao no ano*/
gen ramom=1 if ramoym==1; 				/*agricola*/
	replace ramom=2 if ramoym>=2 & ramoym<=4;	/*industria*/
	replace ramom=3 if ramoym>=5 & ramoym<=8;	/*comercio e servicos, transporte e comunicacao*/
	replace ramom=4 if ramoym>=9 & ramoym<=10;	/*social e administracao publica*/
	replace ramom=5 if ramoym>=11;			/*outras ou mal definidas*/



/*aggregating occupation*/
gen grupom=1 if grupym==1 | grupym==2; 			/*mais qualificado*/
	replace grupom=2 if grupym==3;			/*agricola*/
	replace grupom=3 if grupym>=4 & grupym<=7;	/*nivel medio*/
	replace grupom=4 if grupym==8;			/*outros*/



/*CREATING THE OUTCOME VARIABLES*/

/*defining retirement flows based on economicamente ativo ou nao - flow */
gen retirementm=0 if codym==1 & codwm==1;
	replace retirementm=1 if codym==1 & codwm==2;



/*now working only with those who were occupied a year ago and retired now - flow */
gen retirem=1 if ocupym==1 & aposem==2;
	replace retirem=0 if ocupym==1 & aposem==4;



/*just analyzing the stock of retirees*/
gen aposentadom=1 if aposem==2;
	replace aposentadom=0 if aposem==4;



/*Condicao de Atividade na Semana*/
gen actm=1 if codwm==1;
	replace actm=0 if codwm==2;



/*To count males*/

gen man = 1;



/*To count males on the labor force participation*/

gen man_LF=1 if codym==1;






/*CREATING SOME OF THE BINARY EXPLANATORY VARIABLES*/

/*FOR COLOR OR RACE - BASELINE IS NON-WHITE*/
gen race1m=1 if colorm==2;
	replace race1m=0 if colorm~=2 & colorm~=.;



/*FOR AGE - BASELINE IS 45-49*/
ta gragem, g(agem);
	rename agem1 age0m;
	rename agem2 age1m;
	rename agem3 age2m;
	rename agem4 age3m;
	rename agem5 age4m;



/*FOR EDUCATIONAL GROUP - BASELINE IS LESS THAN 4 YEARS OF SCHOOLING*/
ta greducm, g(educm);
	rename educm1 educ0m;
	rename educm2 educ1m;
	rename educm3 educ2m;
	rename educm4 educ3m;



/*FOR REGION OF RESIDENCE - BASELINE IS NORTHEAST*/
ta regionm, g(regionm);
	rename regionm1 region1m;
	rename regionm2 region0m;
	rename regionm3 region2m;
	rename regionm4 region3m;
	rename regionm5 region4m;



/*PAID SOCIAL SECURITY IN PREVIOUS WORK - BASELINE IS NO*/
gen previ1m=1 if previm==1;
	replace previ1m=0 if previm==3;



/*OCCUPATIONAL GROUP - BASELINE IS SOCIAL E ADMINISTRACAO PUBLICA*/
ta ramom, g(ramom);
	rename ramom1 ramo1m;
	rename ramom2 ramo2m;
	rename ramom3 ramo3m;
	rename ramom4 ramo0m;
	rename ramom5 ramo4m;



/*POSICAO NA OCUPACAO - BASELINE IS EMPREGADOR E CONTA PROPRIA*/
ta posicaom, g(posm);
	rename posm1 pos1m;
	rename posm2 pos2m;
	rename posm3 pos0m;
	rename posm4 pos3m;
	
	
	
/*WORK TENURE: review1*/

gen expm = agem - (educm + 6);

gen expm2 = agem - agestm;



/*Health Status and Disease*/
gen healthm=1 if saudem>=3 & saudem~=.; 	/*Fair or Bad Health*/
	replace healthm=0 if saudem<=2; 	/*Good and Excelent Health*/ 



/*Years of Contribution*/
gen ycon1m = agem - educm; 	/*Based on Education Years*/
gen ycon2m = agem - agestm; 	/*Based on when started to work*/

gen agepm=1 if agem>=65 & agem~=.;
	replace agepm=0 if agem<=64;



count;

sort controlserie nfamilia;

saveold "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.males08.dta", replace;




******************************************************************************************************
************************************************ MERGE ***********************************************
******************************************************************************************************;

use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.females08.dta", clear;

merge controlserie nfamilia using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.males08.dta";

count;

count if woman==1;

count if man==1;

ta _merge;


***** Casos em que _merge=1, representam mulheres (master data) fora do intervalo de idade definido (45 a 70 anos);
***** Casos em que _merge=2, representam homens (using data) fora do intervalo de idade definido (45 a 70 anos);
***** Como restringimos nossa amostra a pessoas que tenham entre 45 e 70 anos de idade E, AL�M DISSO, apenas nos interessa os casais, esses casos n�o nos interessam, por isso o keep a seguir;

keep if _merge==3;

count;

count if woman==1;

count if man==1;


**** N�O RESTRINGINDO A AMOSTRA A APENAS OS CASAIS NOS QUAIS AO MENOS UM EST� NA FOR�A DE TRABALHO, TEMOS UMA AMOSTRA MUITO PARECIDA � DO PAPER ORIGINAL;

/* Mantendo apenas os casais com pelo menos um dos dois na for�a de trabalho durante o ano de refer�ncia e aqueles em que, pelo menos um deles est� no intervalo de idade de 45 a 70 anos */

egen AtLeastOne_InLF=rownonmiss(man_LF woman_LF);

ta AtLeastOne_InLF, m;

*keep if (AtLeastOne_InLF==1 | AtLeastOne_InLF==2) & (m45_70==1 | f45_70==1);


**** MANTENDO OS CASAIS EM QUE AO MENOS UM EST� NO INTERVALO ET�RIO DE 45 A 70 ANOS;

*keep if (m45_70==1 | f45_70==1);


count;

saveold "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.08.dta", replace;




******************************************************************************************************
************************************ SUMMARY STATISTICS **********************************************
******************************************************************************************************;

************ CITED STATISTICS ON THE BODY OF THE TEXT (ORIGINAL PAPER: PAGE 8);


/* Couple's mean age differential */


*** Para preencher os par�metros do teste de m�dias (ttesti #obs1 #mean1 #sd1 #obs2 #mean2 #sd2);

sum agem;

sum agef;

ttesti 19024 56.67126 6.727091 19024 53.7265 6.23598;

	local difAge_08 = r(mu_1) - r(mu_2);

	local sd_difAge_08 = r(sd);


/* % women married with men of the same age or older */

gen agem_MaiorIgual_agef=0;
	replace agem_MaiorIgual_agef=1 if agem>=agef;

sum agem_MaiorIgual_agef;

	local ManSameAgeOrOlder_08 = r(mean)*100;


/* % couples in the same educational group */

gen same_educ=0;
	replace same_educ=1 if greducm==greducf;

sum same_educ;

	local SameEduc_08 = r(mean)*100;



/* % couples formed by partners of the same race */

gen same_race=0;
	replace same_race=1 if colorm==colorf;

sum same_race;

	local SameRace_08 = r(mean)*100;



/* Sample size */

count;

	local SampleSize_08 = r(N);



************* MATRIZ ****************;

mat cited_statistics_08 = 						  ///	
`difAge_08',		`sd_difAge_08'				\ ///
`ManSameAgeOrOlder_08',	`ManSameAgeOrOlder_08'	\ ///
`SameEduc_08',		`SameEduc_08'				\ ///
`SameRace_08', 		`SameRace_08' 				\ ///
`SampleSize_08', 	`SampleSize_08';


mat rown cited_statistics_08 = difAge ManSameAgeOrOlder SameEduc SameRace SampleSize;
mat coln cited_statistics_08 = Value sd_value;

mat list cited_statistics_08;




************ TABLE 1;


/* Husband's age */

sum agem;

	local AgeM_08 = r(mean);

	local sd_AgeM_08 = r(sd);



/* Wife's age */

sum agef;

	local AgeF_08 = r(mean);

	local sd_AgeF_08 = r(sd);



/* Husband's education */

sum educm;
	
	local EducM_08 = r(mean);

	local sd_EducM_08 = r(sd);



/* Wife's education */

sum educf;
	
	local EducF_08 = r(mean);

	local sd_EducF_08 = r(sd);



/* % husbands in LF */

sum actm;

	local ActiveM_08 = r(mean)*100;




/* % wives in LF */

sum actf;

	local ActiveF_08 = r(mean)*100;




/* % husbands retired */

sum aposentadom;

	local AposentM_08 = r(mean)*100;




/* % wives retired */

sum aposentadof;

	local AposentF_08 = r(mean)*100;




/* % husbands with poor health */

sum healthm;

	local HealthM_08 = r(mean)*100; 


/* % wives retired with poor health */

sum healthf;

	local HealthF_08 = r(mean)*100; 



*** MATRIZ ***;

mat Table1_08 = ///	
`AgeM_08',		`sd_AgeM_08'	\ ///
`AgeF_08',		`sd_AgeF_08'	\ ///
`EducM_08',		`sd_EducM_08'	\ ///
`EducF_08', 		`sd_EducF_08' 	\ ///
`ActiveM_08', 		`ActiveM_08' 	\ ///
`ActiveF_08', 		`ActiveF_08' 	\ ///
`AposentM_08', 		`AposentM_08' 	\ ///
`AposentF_08', 		`AposentF_08' 	\ ///
`HealthM_08', 		`HealthM_08' 	\ ///
`HealthF_08', 		`HealthF_08';


mat rown Table1_08 = AgeM AgeF EducM EducF ActiveM ActiveF AposentM AposentF HealthM HealthF;
mat coln Table1_08 = Value sd_value;

mat list Table1_08;




************ TABLE 2;


gen bothin = 0;
replace bothin = 1 if  (actm==1 & actf==1);

gen bothout = 0;
replace bothout = 1 if (actm==0 & actf==0);

gen husbin = 0;
replace husbin = 1 if  (actm==1 & actf==0);

gen wifein = 0;
replace wifein =1 if   (actm==0 & actf==1);



preserve;
collapse(sum) couple bothin bothout husbin wifein, by(gragef gragem);
gen bin  = bothin/couple;
gen hin  = husbin/couple;
gen win  = wifein/couple;
gen bout = bothout/couple;

*drop if gragef==1 | gragem==1;

saveold "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\TABLE2.08.dta", replace;

restore;




************ FIGURES 1 and 2;


/* Husbands in the Labor Force */


preserve;
collapse (sum) man actm, by(agem);
gen pea = actm/man;
gen nopea = 1 - pea;
twoway (line pea agem) (line nopea agem), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "In Labor Force"  2 "Out Labor Force"));
graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH1_08_ago2015.pdf" , replace;
restore;




/* Wifes in the Labor Force */


preserve;
collapse (sum) woman actf, by(agef);
gen pea = actf/woman;
gen nopea = 1 - pea;
twoway (line pea agef) (line nopea agef), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "In Labor Force"  2 "Out Labor Force"));
graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH2_08_ago2015.pdf" , replace;
restore;



/* Couples in the Labor Force - joint retirement by husband's age */


preserve;
collapse (sum) couple bothin bothout husbin wifein, by(agem);
gen bin  = bothin/couple;
gen bout = bothout/couple;
gen hin  = husbin/couple;
gen win  = wifein/couple;
twoway (line bin agem) (line bout agem) (line hin agem) (line win agem), ytitle(Probability) xtitle(Husband's Age) yscale(range(0 .65)) ylabel(0(.2).6) graphregion(fcolor(white)) legend(order(1 "Both In"  2 "Both Out" 3 "Husband In" 4 "Wife In"));
graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH3_08_ago2015.pdf" , replace;
restore;



******************************************************************************************
************************************ MODELS **********************************************
******************************************************************************************;


****************** Estimating Wages and Benefits ******************;

gen agem2=agem*agem;
gen agef2=agef*agef;



********** CREATING DUMMY: CHILDREN UNDER 14 IN THE HOUSEHOLD ***********;
gen hhtype=0 if hhtypf==2 | hhtypf==4;
	replace hhtype=1 if hhtypf==1 | hhtypf==3 | hhtypf==5;



*For MALES - estimating pension benefits (aposentadoria);

replace renapm = . if renapm == - 1;
replace renapm = . if renapm > 15001;
summarize renapm, detail;
gen lnpensionm = log(renapm);
heckman lnpensionm educm agem agem2, select(educm agem agem2 region1m region2m region3m region4m) two;
predict malebenefit;

regress lnpensionm educm agem agem2;

*For MALES - estimating wages;

replace rendam = . if rendam == - 1;
replace rendam = . if rendam > 70000;
summarize rendam, detail;
gen lnrendam = log(rendam);
heckman lnrendam educm agem agem2 expm2 hhtype, select(educm agem agem2 expm2 hhtype region1m region2m region3m region4m) two;
predict malewage;

regress lnrendam educm agem agem2 expm2 hhtype;

gen rratem = malebenefit/malewage;
summ rratem;



*For FEMALES - estimating pension benefits (aposentadoria);

replace renapf = . if renapf == - 1;
replace renapf = . if renapf > 15001;
summarize renapf, detail;
gen lnpensionf = log(renapf);
heckman lnpensionf educf agef agef2, select(educf agef agef2 region1f region2f region3f region4f) two;
predict femalebenefit;

regress lnpensionf educf agef agef2;

*For FEMALES - estimating wages;

replace rendaf = . if rendaf == - 1;
replace rendaf = . if rendaf > 70000;
summarize rendaf, detail;
gen lnrendaf = log(rendaf);
heckman lnrendaf educf agef agef2 expf2 hhtype, select(educf agef agef2 expf2 hhtype region1f region2f region3f region4f) two;
predict femalewage;

regress lnrendaf educf agef agef2 expf2 hhtype;

gen rratef = femalebenefit/femalewage;
summ rratef;



******* TAXA DE CRESCIMENTO DO PIB (1994-1998, 1999-2003, 2004-2008): review1;

gen pibrate=.;
replace pibrate	=	28.89	 if uf	==	12;
replace pibrate	=	18.50	 if uf	==	27;
replace pibrate	=	23.64	 if uf	==	13;
replace pibrate	=	21.67	 if uf	==	16;
replace pibrate	=	19.17	 if uf	==	29;
replace pibrate	=	24.51	 if uf	==	23;
replace pibrate	=	21.89	 if uf	==	53;
replace pibrate	=	30.44	 if uf	==	32;
replace pibrate	=	22.34	 if uf	==	52;
replace pibrate	=	28.31	 if uf	==	21;
replace pibrate	=	19.97	 if uf	==	31;
replace pibrate	=	23.58	 if uf	==	50;
replace pibrate	=	21.36	 if uf	==	51;
replace pibrate	=	19.71	 if uf	==	15;
replace pibrate	=	19.66	 if uf	==	25;
replace pibrate	=	21.51	 if uf	==	26;
replace pibrate	=	23.06	 if uf	==	22;
replace pibrate	=	13.53	 if uf	==	41;
replace pibrate	=	15.50	 if uf	==	33;
replace pibrate	=	16.93	 if uf	==	24;
replace pibrate	=	17.38	 if uf	==	11;
replace pibrate	=	22.60	 if uf	==	14;
replace pibrate	=	11.31	 if uf	==	43;
replace pibrate	=	13.69	 if uf	==	42;
replace pibrate	=	19.89	 if uf	==	28;
replace pibrate	=	22.43	 if uf	==	35;
replace pibrate	=	22.95	 if uf	==	17;



******* TAXA DE DESEMPREGO (1998, 2003, 2008): review1;

gen unemprate=.;
replace unemprate	=	5.83	 if uf	==	12;
replace unemprate	=	6.93	 if uf	==	27;
replace unemprate	=	13.93	 if uf	==	13;
replace unemprate	=	8.08	 if uf	==	16;
replace unemprate	=	9.03	 if uf	==	29;
replace unemprate	=	6.27	 if uf	==	23;
replace unemprate	=	11.08	 if uf	==	53;
replace unemprate	=	5.84	 if uf	==	32;
replace unemprate	=	6.79	 if uf	==	52;
replace unemprate	=	5.39	 if uf	==	21;
replace unemprate	=	5.77	 if uf	==	31;
replace unemprate	=	7.39	 if uf	==	50;
replace unemprate	=	6.09	 if uf	==	51;
replace unemprate	=	5.13	 if uf	==	15;
replace unemprate	=	6.76	 if uf	==	25;
replace unemprate	=	4.58	 if uf	==	26;
replace unemprate	=	9.55	 if uf	==	22;
replace unemprate	=	4.02	 if uf	==	41;
replace unemprate	=	9.56	 if uf	==	33;
replace unemprate	=	7.29	 if uf	==	24;
replace unemprate	=	5.49	 if uf	==	11;
replace unemprate	=	6.13	 if uf	==	14;
replace unemprate	=	5.63	 if uf	==	43;
replace unemprate	=	4.53	 if uf	==	42;
replace unemprate	=	8.09	 if uf	==	28;
replace unemprate	=	7.68	 if uf	==	35;
replace unemprate	=	5.05	 if uf	==	17;



****************** Sections 6 and 7 ******************;

********** CREATING LENGHT OF SERVICE ELIGIBILITY **********;
/* FORMA ANTERIOR 

gen lsm = .;
replace lsm = 1 if (agem < 66 & (agem - educm + agestm >= 35));
replace lsm = 0 if lsm ==.;

gen lsf = .;
replace lsf = 1 if (agef < 61 & (agef - educf + agestf >= 30));
replace lsf = 0 if lsf ==.; */

gen lsm=1 if (agem<65 & (agem-6-educm>=35));
	replace lsm=0 if lsm==.;


gen lsf=1 if (agef<60 & (agef-6-educf>=30));
	replace lsf=0 if lsf==.;




/*
********** Section 7.3 The Determinants of Retirement transition;

*** Bivariate probit models - one for husbands and other for wives (present only the model with the best fit, I selected the best model by comparing deviances from alternative specifications);
* Dependent variable: uses information on labor force participation during the year preceding the survey and survey�s reference week to measure retirement flows;
* Control variables: Benefit Rep. Rate (husband and wife), Eligibility Soc. Sec - old age, LS - (husband and wife), Age (husband and wife), education (husband and wife), health status (husband and wife), dependent children (husband and wife) (yes=1), labor status (husband and wife) (formal=1);


biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype actm actf pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype actm actf pos1m pos1f), robust;
	outreg2 using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_Table4_08_ago2015.doc", replace;

*/
	
/*Dummies of age PLUS the economic cycle variables (OUR FINAL MODEL AFTER REVIEW): review1*/

ta agef, gen(agedf);
	recode agedf25 (0=1) if agedf26==1;
	drop agedf26;
	
	rename	agedf1	agef45	;
	rename	agedf2	agef46	;
	rename	agedf3	agef47	;
	rename	agedf4	agef48	;
	rename	agedf5	agef49	;
	rename	agedf6	agef50	;
	rename	agedf7	agef51	;
	rename	agedf8	agef52	;
	rename	agedf9	agef53	;
	rename	agedf10	agef54	;
	rename	agedf11	agef55	;
	rename	agedf12	agef56	;
	rename	agedf13	agef57	;
	rename	agedf14	agef58	;
	rename	agedf15	agef59	;
	rename	agedf16	agef60	;
	rename	agedf17	agef61	;
	rename	agedf18	agef62	;
	rename	agedf19	agef63	;
	rename	agedf20	agef64	;
	rename	agedf21	agef65	;
	rename	agedf22	agef66	;
	rename	agedf23	agef67	;
	rename	agedf24	agef68	;
	rename	agedf25	agef6970	;


ta agem, gen(agedm);
	recode agedm25 (0=1) if agedm26==1;
	drop agedm26;
	
	rename	agedm1	agem45	;
	rename	agedm2	agem46	;
	rename	agedm3	agem47	;
	rename	agedm4	agem48	;
	rename	agedm5	agem49	;
	rename	agedm6	agem50	;
	rename	agedm7	agem51	;
	rename	agedm8	agem52	;
	rename	agedm9	agem53	;
	rename	agedm10	agem54	;
	rename	agedm11	agem55	;
	rename	agedm12	agem56	;
	rename	agedm13	agem57	;
	rename	agedm14	agem58	;
	rename	agedm15	agem59	;
	rename	agedm16	agem60	;
	rename	agedm17	agem61	;
	rename	agedm18	agem62	;
	rename	agedm19	agem63	;
	rename	agedm20	agem64	;
	rename	agedm21	agem65	;
	rename	agedm22	agem66	;
	rename	agedm23	agem67	;
	rename	agedm24	agem68	;
	rename	agedm25	agem6970	;
	
	
********** Policy simulation;

gen agepf1=1 if agef>=65 & agef~=.;
	replace agepf1=0 if agef<=64;
	
gen lsf1=1 if (agef<65 & (agef-6-educf>=35));
	replace lsf1=0 if lsf1==.;
	

gen agepf2=1 if agef>=68 & agef~=.;
	replace agepf2=0 if agef<=67;
	
gen lsf2=1 if (agef<68 & (agef-6-educf>=38));
	replace lsf2=0 if lsf2==.;

gen agepm2=1 if agem>=68 & agem~=.;
	replace agepm2=0 if agem<=67;
	
gen lsm2=1 if (agem<68 & (agem-6-educm>=38));
	replace lsm2=0 if lsm2==.;

/*biprobit (retirem= rratem rratef agepm lsm agepf lsf agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate) (retiref=rratem rratef agepm lsm agepf lsf agem46 agem47 agem48 agem49 agem50 ///
	agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 ///
	agef66 agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate), robust;
	outreg2 using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_simulation_08.doc", replace;
*/

biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate) (retiref=rratem rratef agepm lsm agepf lsf agem ///
	agef educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate), robust;
	outreg2 using "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_simulation_08.doc", replace;

predict p00_old1_08, p00;
predict p11_old1_08, p11;
predict p01_old1_08, p01;
predict p10_old1_08, p10;

** New system 1;
/*biprobit (retirem= rratem rratef agepm lsm agepf1 lsf1 agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate) (retiref=rratem rratef agepm lsm agepf1 lsf1 agem46 agem47 agem48 ///
	agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate), robust;
*/		

biprobit (retirem= rratem rratef agepm lsm agepf1 lsf1 agem agef ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate) (retiref=rratem rratef agepm lsm agepf1 lsf1 agem ///
	agef educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate), robust;
	
predict p00_new1_08, p00;
predict p11_new1_08, p11;
predict p01_new1_08, p01;
predict p10_new1_08, p10;

** New system 2;
/*biprobit (retirem= rratem rratef agepm2 lsm2 agepf2 lsf2 agem46 agem47 agem48 agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 ///
	agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 ///
	agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 agef67 agef68 agef6970 ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate) (retiref=rratem rratef agepm2 lsm2 agepf2 lsf2 agem46 agem47 agem48 ///
	agem49 agem50 agem51 agem52 agem53 agem54 agem55 agem56 agem57 agem58 agem59 agem60 agem61 agem62 agem63 agem64 agem65 agem66 agem67 agem68 agem6970 ///
	agef46 agef47 agef48 agef49 agef50 agef51 agef52 agef53 agef54 agef55 agef56 agef57 agef58 agef59 agef60 agef61 agef62 agef63 agef64 agef65 agef66 ///
	agef67 agef68 agef6970 educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate), robust;
*/

biprobit (retirem= rratem rratef agepm2 lsm2 agepf2 lsf2 agem agef ///
	educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate) (retiref=rratem rratef agepm2 lsm2 agepf2 lsf2 agem ///
	agef educm educf healthm healthf hhtype actm actf pos1m pos1f pibrate unemprate), robust;

predict p00_new2_08, p00;
predict p11_new2_08, p11;
predict p01_new2_08, p01;
predict p10_new2_08, p10;


	preserve;
	
keep if agem>=55;
*drop if gragef==1;

keep if agef > 54; 

keep if agef < 70;

	
twoway(lowess p00_old1_08 agem, bw(.4)) ///
		(lowess p00_new1_08 agem, bw(.4)) ///
		(lowess p00_new2_08 agem, bw(.4)), yscale(range(.1 .8)) ylabel(.1(.1).8) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"));
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados_08.pdf", replace;
	
	
twoway(lowess p11_old1_08 agem, bw(.4)) ///
		(lowess p11_new1_08 agem, bw(.4)) ///
		(lowess p11_new2_08 agem, bw(.4)), yscale(range(.1 .4)) ylabel(.1(.1).4) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"));
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados_08.pdf", replace;


twoway(lowess p01_old1_08 agem, bw(.4)) ///
		(lowess p01_new1_08 agem, bw(.4)) ///
		(lowess p01_new2_08 agem, bw(.4)), yscale(range(0 .1)) ylabel(0(.1).1) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"));
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada_08.pdf", replace;

	
twoway(lowess p10_old1_08 agem, bw(.4)) ///
		(lowess p10_new1_08 agem, bw(.4)) ///
		(lowess p10_new2_08 agem, bw(.4)), yscale(range(.1 .6)) ylabel(.1(.1).6) ///
		xscale(range(55 70)) xlabel(55(5)70) ytitle(Probability) xtitle(Husband's age) ///
		graphregion(fcolor(white)) legend(order(1 "Current system"  2 "Age at retirement: 65" 3 "Age at retirement: 68"));
	graph save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado_08.pdf", replace;

	
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosNaoAposentados_08.pdf";
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UAmbosAposentados_08.pdf";
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UEsposaAposentada_08.pdf";
		graph use "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\UMaridoAposentado_08.pdf";


		restore;


log c;

save "D:\New_06.23.2015\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_2008.dta", replace;

