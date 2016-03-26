
capture log close

log using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\Descriptive&Models_03_ago2015.log", append

* do "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Do\3.CouplesRetirement_03_01.16.11.txt"



** Caminho pra rodar no meu computador: "C:\Laeticia\"
** Caminho pra rodar no sistema Winstat: "\\Client\C$\Laeticia\"


set more off
clear all
set mem 500m


/***********************************************
*     Stata Program PNAD 2003                  *
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
trabwef     		137          /*trabalhou na semana de referencia*/
hoursf      		360-361      /*numero de horas trabalhadas*/
ssectf      		362          /*contribuiu para previdencia na semana*/
kindsf      		363          /*tipo de previdencia*/
trabyf      		374          /*trabalhou no ano de referencia*/
cartyf      		398          /*carteira no trabalho ano*/
previf      		400          /*contribuiu previdencia trabalho no ano*/
cagetf      		407          /*codigo idade comecou a trabalhar*/
agestf      		408-409      /*idade comecou trabalhar*/
aposef      		520          /*aposentado na semana de referencia*/
pensf       		521          /*pensionista na semana de refencia*/
renapf      		524-535      /*rendimento de aposentadoria*/
renpef      		538-549      /*rendimento de pensao*/
saudef      		677          /*estado de saude*/
problsf     		678          /*deixou de realizar atividade habitual nas ultimas duas semanas*/
colunaf    			686          /*doenca de coluna*/
artritef    		687          /*tem artrite*/
cancerf     		688          /*tem cancer*/
diabetef    		689          /*tem diabetes*/
respiraf    		690          /*doenca respiratoria*/
hipertef    		691          /*hipertensao*/
coracaof    		692          /*doenca coracao*/
renalf      		693          /*doenca renal cronica*/
depresf     		694          /*depressao*/
tubercf     		695          /*tuberculose*/
tendinf     		696          /*tendinite*/
cirrosf     		697          /*tem cirrose*/
educf       		785-786      /*anos de estudo*/
codwf       		787          /*condicao de atividade na semana*/
ocupwf      		788          /*condicao de ocupacao na semana*/
posocuwf    		789-790      /*posicao na ocupacao na semana*/
ramowf      		793-794      /*ramo da ocupacao na semana*/
gropwf      		795-796      /*grupo ocupacao na semana*/
codyf       		799          /*condicao de atividae no ano*/
ocupyf      		800          /*condicao ocupacao no ano*/
posoyf      		801-802      /*posicao ocupacao no ano*/
ramoyf      		803-804      /*ramo de ocupacao no ano*/
grupyf      		805-806      /*grupo de ocupacao no ano*/
rendaf      		807-818      /*rendimento do trabalho principal*/
rendtf      		819-830      /*rendimento todos os trabalhos*/
rendtof     		831-842      /*rendimento de todas as fontes*/ 
hhtypf      		867-868      /*tipo de familia*/
urbanf      		886          /*Situação - Urbano/Rural*/
pesopf      		887-891      /*peso da pessoa*/
using "D:\New\Laeticia\UltimoBackup_13.09.2013\Back-up_29.03.10\Demografia\Bases de Dados\Pnads\Pnad_2003\Dados\PES2003.txt"
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


**** Gerando a variável de casais de outra forma, só pra conferir:;
gen couple2_temp=1 if condff==1 | condff==2;
	replace couple2_temp=0 if condff~=1 & condff~=2;

bysort controlserie nfamilia: egen couple2 = total(couple2_temp);

drop couple2_temp;

/* Mantendo apenas os casais */
keep if couple==1;

/* Mantendo apenas os casais para os quais existe informação sobre as variáveis que nos interessam */
*keep if educf~=. & colorf~=. & codwf~=. & codyf~=. & agef~=.;

**** VER COMO COLOCÁ-LAS NESSE KEEP TB: previf~=. & ramoyf~=. & posoyf~=. & saudef~=. & agestf~=.
count;



/* working only with females between 45 and 70 years of age in urban areas */


keep if sexf==4; /*feminino*/
keep if condff>=1 & condff<=2; /*reference or conjuge*/
keep if agef>=45 & agef<=70;
***** SEM RESTRINGIR A URBANO, OS GRÁFICOS FICAM EXATAMENTE IGUAIS AO DO PAPER ORIGINAL;
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

saveold "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.females03.dta", replace;



clear;

/***********************************************
*     Stata Program PNAD 2003                  *
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
trabwem     		137          /*trabalhou na semana de referencia*/
hoursm      		360-361      /*numero de horas trabalhadas*/
ssectm      		362          /*contribuiu para previdencia na semana*/
kindsm      		363          /*tipo de previdencia*/
trabym      		374          /*trabalhou no ano de referencia*/
cartym      		398          /*carteira no trabalho ano*/
previm      		400          /*contribuiu previdencia trabalho no ano*/
cagetm      		407          /*codigo idade comecou a trabalhar*/
agestm      		408-409      /*idade comecou trabalhar*/
aposem      		520          /*aposentado na semana de referencia*/
pensm       		521          /*pensionista na semana de refencia*/
renapm      		524-535      /*rendimento de aposentadoria*/
renpem      		538-549      /*rendimento de pensao*/
saudem      		677          /*estado de saude*/
problsm     		678          /*deixou de realizar atividade habitual nas ultimas duas semanas*/
colunam    		686          /*doenca de coluna*/
artritem    		687          /*tem artrite*/
cancerm     		688          /*tem cancer*/
diabetem    		689          /*tem diabetes*/
respiram    		690          /*doenca respiratoria*/
hipertem    		691          /*hipertensao*/
coracaom    		692          /*doenca coracao*/
renalm      		693          /*doenca renal cronica*/
depresm     		694          /*depressao*/
tubercm     		695          /*tuberculose*/
tendinm     		696          /*tendinite*/
cirrosm     		697          /*tem cirrose*/
educm       		785-786      /*anos de estudo*/
codwm       		787          /*condicao de atividade na semana*/
ocupwm      		788          /*condicao de ocupacao na semana*/
posocuwm    		789-790      /*posicao na ocupacao na semana*/
ramowm      		793-794      /*ramo da ocupacao na semana*/
gropwm      		795-796      /*grupo ocupacao na semana*/
codym       		799          /*condicao de atividae no ano*/
ocupym      		800          /*condicao ocupacao no ano*/
posoym      		801-802      /*posicao ocupacao no ano*/
ramoym      		803-804      /*ramo de ocupacao no ano*/
grupym      		805-806      /*grupo de ocupacao no ano*/
rendam      		807-818      /*rendimento do trabalho principal*/
rendtm      		819-830      /*rendimento todos os trabalhos*/
rendtom     		831-842      /*rendimento de todas as fontes*/ 
hhtypm      		867-868      /*tipo de familia*/
urbanm      		886          /*Situação - Urbano/Rural*/
pesopm      		887-891      /*peso da pessoa*/
using "D:\New\Laeticia\UltimoBackup_13.09.2013\Back-up_29.03.10\Demografia\Bases de Dados\Pnads\Pnad_2003\Dados\PES2003.txt"
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

/* Mantendo apenas os casais para os quais existe informação sobre as variáveis que nos interessam */
*keep if educm~=. & colorm~=. & codwm~=. & codym~=. & agem~=.;

**** VER COMO COLOCÁ-LAS NESSE KEEP TB: previm~=. & ramoym~=. & posoym~=. & saudem~=. & agestm~=.
count;



/* working only with males between 45 and 70 years of age*/


keep if sexm==2; /*masculino*/
keep if condfm>=1 & condfm<=2;  /*reference or conjuge*/
keep if agem>=45 & agem<=70;
***** SEM RESTRINGIR A URBANO, OS GRÁFICOS FICAM EXATAMENTE IGUAIS AO DO PAPER ORIGINAL;
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

saveold "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.males03.dta", replace;




******************************************************************************************************
************************************************ MERGE ***********************************************
******************************************************************************************************;

use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.females03.dta", clear;

merge controlserie nfamilia using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.males03.dta";

count;

count if woman==1;

count if man==1;

ta _merge;


***** Casos em que _merge=1, representam mulheres (master data) fora do intervalo de idade definido (45 a 70 anos);
***** Casos em que _merge=2, representam homens (using data) fora do intervalo de idade definido (45 a 70 anos);
***** Como restringimos nossa amostra a pessoas que tenham entre 45 e 70 anos de idade E, ALÉM DISSO, apenas nos interessa os casais, esses casos não nos interessam, por isso o keep a seguir;

keep if _merge==3;

count;

count if woman==1;

count if man==1;


**** NÃO RESTRINGINDO A AMOSTRA A APENAS OS CASAIS NOS QUAIS AO MENOS UM ESTÁ NA FORÇA DE TRABALHO, TEMOS UMA AMOSTRA MUITO PARECIDA À DO PAPER ORIGINAL;

/* Mantendo apenas os casais com pelo menos um dos dois na força de trabalho durante o ano de referência e aqueles em que, pelo menos um deles está no intervalo de idade de 45 a 70 anos */

egen AtLeastOne_InLF=rownonmiss(man_LF woman_LF);

ta AtLeastOne_InLF, m;

*keep if (AtLeastOne_InLF==1 | AtLeastOne_InLF==2) & (m45_70==1 | f45_70==1);


**** MANTENDO OS CASAIS EM QUE AO MENOS UM ESTÁ NO INTERVALO ETÁRIO DE 45 A 70 ANOS;

*keep if (m45_70==1 | f45_70==1);


count;

saveold "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\pea.03.dta", replace;




******************************************************************************************************
************************************ SUMMARY STATISTICS **********************************************
******************************************************************************************************;

************ CITED STATISTICS ON THE BODY OF THE TEXT (ORIGINAL PAPER: PAGE 8);


/* Couple's mean age differential */


*** Para preencher os parâmetros do teste de médias;

sum agem;

sum agef;

ttesti 16349 56.55624 6.788764 16349 53.48382 6.244924;

	local difAge_03 = r(mu_1) - r(mu_2);

	local sd_difAge_03 = r(sd);


/* % women married with men of the same age or older */

gen agem_MaiorIgual_agef=0;
	replace agem_MaiorIgual_agef=1 if agem>=agef;

sum agem_MaiorIgual_agef;

	local ManSameAgeOrOlder_03 = r(mean)*100;


/* % couples in the same educational group */

gen same_educ=0;
	replace same_educ=1 if greducm==greducf;

sum same_educ;

	local SameEduc_03 = r(mean)*100;



/* % couples formed by partners of the same race */

gen same_race=0;
	replace same_race=1 if colorm==colorf;

sum same_race;

	local SameRace_03 = r(mean)*100;



/* Sample size */

count;

	local SampleSize_03 = r(N);



************* MATRIZ ****************;

mat cited_statistics_03 = 						  ///	
`difAge_03',		`sd_difAge_03'				\ ///
`ManSameAgeOrOlder_03',	`ManSameAgeOrOlder_03'	\ ///
`SameEduc_03',		`SameEduc_03'				\ ///
`SameRace_03', 		`SameRace_03' 				\ ///
`SampleSize_03', 	`SampleSize_03';


mat rown cited_statistics_03 = difAge ManSameAgeOrOlder SameEduc SameRace SampleSize;
mat coln cited_statistics_03 = Value sd_value;

mat list cited_statistics_03;




************ TABLE 1;


/* Husband's age */

sum agem;

	local AgeM_03 = r(mean);

	local sd_AgeM_03 = r(sd);



/* Wife's age */

sum agef;

	local AgeF_03 = r(mean);

	local sd_AgeF_03 = r(sd);



/* Husband's education */

sum educm;
	
	local EducM_03 = r(mean);

	local sd_EducM_03 = r(sd);



/* Wife's education */

sum educf;
	
	local EducF_03 = r(mean);

	local sd_EducF_03 = r(sd);



/* % husbands in LF */

sum actm;

	local ActiveM_03 = r(mean)*100;




/* % wives in LF */

sum actf;

	local ActiveF_03 = r(mean)*100;




/* % husbands retired */

sum aposentadom;

	local AposentM_03 = r(mean)*100;




/* % wives retired */

sum aposentadof;

	local AposentF_03 = r(mean)*100;




/* % husbands with poor health */

sum healthm;

	local HealthM_03 = r(mean)*100; 


/* % wives retired with poor health */

sum healthf;

	local HealthF_03 = r(mean)*100; 



*** MATRIZ ***;

mat Table1_03 = ///	
`AgeM_03',		`sd_AgeM_03'	\ ///
`AgeF_03',		`sd_AgeF_03'	\ ///
`EducM_03',		`sd_EducM_03'	\ ///
`EducF_03', 		`sd_EducF_03' 	\ ///
`ActiveM_03', 		`ActiveM_03' 	\ ///
`ActiveF_03', 		`ActiveF_03' 	\ ///
`AposentM_03', 		`AposentM_03' 	\ ///
`AposentF_03', 		`AposentF_03' 	\ ///
`HealthM_03', 		`HealthM_03' 	\ ///
`HealthF_03', 		`HealthF_03';


mat rown Table1_03 = AgeM AgeF EducM EducF ActiveM ActiveF AposentM AposentF HealthM HealthF;
mat coln Table1_03 = Value sd_value;

mat list Table1_03;




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

drop if gragef==1 | gragem==1;

saveold "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\TABLE2.03.dta", replace;

restore;




************ FIGURES 1 and 2;



/* Husbands in the Labor Force */


preserve;
collapse (sum) man actm, by(agem);
gen pea = actm/man;
gen nopea = 1 - pea;
twoway (line pea agem) (line nopea agem), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "In Labor Force"  2 "Out Labor Force"));
graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH1_03_ago2015.pdf" , replace;
restore;



/* Wifes in the Labor Force */


preserve;
collapse (sum) woman actf, by(agef);
gen pea = actf/woman;
gen nopea = 1 - pea;
twoway (line pea agef) (line nopea agef), ytitle(Probability) xtitle(Age) yscale(range(0 1)) ylabel(0(.2)1) graphregion(fcolor(white)) legend(order(1 "In Labor Force"  2 "Out Labor Force"));
graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH2_03_ago2015.pdf" , replace;
restore;



/* Couples in the Labor Force - joint retirement by husband's age */


preserve;
collapse (sum) couple bothin bothout husbin wifein, by(agem);
gen bin  = bothin/couple;
gen bout = bothout/couple;
gen hin  = husbin/couple;
gen win  = wifein/couple;
twoway (line bin agem) (line bout agem) (line hin agem) (line win agem), ytitle(Probability) xtitle(Husband's Age) yscale(range(0 .65)) ylabel(0(.2).6) graphregion(fcolor(white)) legend(order(1 "Both In"  2 "Both Out" 3 "Husband In" 4 "Wife In"));
graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\GRAPH3_03_ago2015.pdf" , replace;
restore;



******************************************************************************************
************************************ MODELS **********************************************
******************************************************************************************;


****************** Estimating Wages and Benefits ******************;

gen agem2=agem*agem;
gen agef2=agef*agef;

*For MALES - estimating pension benefits (aposentadoria);

replace renapm = . if renapm == - 1;
replace renapm = . if renapm > 15001;
summarize renapm, detail;
gen lnpensionm = log(renapm);
heckman lnpensionm educm agem agem2, select(educm agem agem2 region1m region2m region3m region4m) two;
predict malebenefit;



*For MALES - estimating wages;

replace rendam = . if rendam == - 1;
replace rendam = . if rendam > 70000;
summarize rendam, detail;
gen lnrendam = log(rendam);
heckman lnrendam educm agem agem2, select(educm agem agem2 region1m region2m region3m region4m) two;
predict malewage;


gen rratem = malebenefit/malewage;
summ rratem;



*For FEMALES - estimating pension benefits (aposentadoria);

replace renapf = . if renapf == - 1;
replace renapf = . if renapf > 15001;
summarize renapf, detail;
gen lnpensionf = log(renapf);
heckman lnpensionf educf agef agef2, select(educf agef agef2 region1f region2f region3f region4f) two;
predict femalebenefit;


*For FEMALES - estimating wages;

replace rendaf = . if rendaf == - 1;
replace rendaf = . if rendaf > 70000;
summarize rendaf, detail;
gen lnrendaf = log(rendaf);
heckman lnrendaf educf agef agef2, select(educf agef agef2 region1f region2f region3f region4f) two;
predict femalewage;


gen rratef = femalebenefit/femalewage;
summ rratef;




****************** Sections 6 and 7 ******************;



********** CREATING DUMMY: CHILDREN UNDER 14 IN THE HOUSEHOLD ***********;
gen hhtype=0 if hhtypf==2 | hhtypf==4;
	replace hhtype=1 if hhtypf==1 | hhtypf==3 | hhtypf==5;



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
********** Section 6.1 The Determinants of Couple’s Labor Force Participation - TABLE 5;

*** Multinomial logistic regression comparing: "both retired" (referência) X "both in the labor force" X "at least one in the labor force";
* Control variables: Age difference, husband's and wife's education, husband's and wife's health status (poor=1), dependent children (no=1);

* Dependent variable;

	gen couple_LFP=0 if bothout==1;
		replace couple_LFP=1 if bothin==1;
		replace couple_LFP=2 if wifein==1 | husbin==1;

	gen age_diff=agem-agef;


**************** Output reports Odds ratios;
mlogit couple_LFP age_diff educf educm healthf healthm hhtype, baseoutcome(0) rr;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\mlogit_Table5_03.doc", replace;





********** Section 6.2 The Determinants of Receiving Pension Benefits - TABLE 6 - STOCK of retirees;

*** Univariate probit models - one for husbands and other for wives (present only the model with the best fit, Bernardo selected the best model by comparing deviances from alternative specifications);
* Control variables: Age (5 age groups - 50-54 (baseline)), education (4 groups - 12+ (baseline)), health status (poor=1), dependent children (yes=1);



**************** just analyzing the stock of retirees;
* Husband;
probit aposentadom age0m age2m age3m age4m educ0m educ1m educ2m healthm hhtype;
mfx;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\probit_Table6_03.doc", replace;

* Wife;
probit aposentadof age0f age2f age3f age4f educ0f educ1f educ2f healthf hhtype;
mfx;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\probit_Table6_03.doc", append;





********** Section 7.1 The Impacts of Spouses on Labor Force Status - retirement FLOW;

*** Univariate probit models - one for husbands and other for wives (present only the model with the best fit, I selected the best model by comparing deviances from alternative specifications);
* Dependent variable: estimates of the impact of wives’ labor force status on husbands’ retirement, and vice-versa;
* Control variables: Spouse's status, age, education, dependent children and health status;

* Husband;
dprobit retirem actf;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", replace;
dprobit retirem actf agem;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;
dprobit retirem actf agem educm;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;
dprobit retirem actf agem educm healthm hhtype;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;


* Wife;
dprobit retiref actm;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;
dprobit retiref actm agef;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;
dprobit retiref actm agef educf;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;
dprobit retiref actm agef educf healthf hhtype;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\dprobit_Table7_03.doc", append;



*/
********** Section 7.2 The Determinants of Retirement;

*** Bivariate probit models - one for husbands and other for wives (present only the model with the best fit, I selected the best model by comparing deviances from alternative specifications);
* Control variables: Benefit Rep. Rate (husband and wife), Eligibility Soc. Sec - old age, LS - (husband and wife), Age (husband and wife), education (husband and wife), health status (husband and wife), dependent children (husband and wife) (yes=1), labor status (husband and wife) (formal=1);


biprobit (retirementm= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f) (retirementf=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_retirement_03_ago2015.doc", replace;

biprobit (aposentadom= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f) (aposentadof=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_aposentado_03_ago2015.doc", append;




********** Section 7.3 The Determinants of Retirement transition;

*** Bivariate probit models - one for husbands and other for wives (present only the model with the best fit, I selected the best model by comparing deviances from alternative specifications);
* Dependent variable: uses information on labor force participation during the year preceding the survey and survey’s reference week to measure retirement flows;
* Control variables: Benefit Rep. Rate (husband and wife), Eligibility Soc. Sec - old age, LS - (husband and wife), Age (husband and wife), education (husband and wife), health status (husband and wife), dependent children (husband and wife) (yes=1), labor status (husband and wife) (formal=1);


biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;
	outreg2 using "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit_Table4_03_ago2015.doc", replace;

	
********** Section 7.4 Sensitivity analysis (estimativa do rho, gerado pelo comando biprobit do Stata e o teste de significancia);


biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;
	local coef_none_03 = r(est);
	local erro_none_03 = r(se);

biprobit (retirem) (retiref), robust;
	local coef_all_03 = r(est);
	local erro_all_03 = r(se);

biprobit (retirem= rratem agepm lsm agem educm healthm hhtype pos1m pos1f) (retiref= rratef agepf lsf agef educf healthf hhtype pos1m pos1f), robust;
	local coef_SpouseChar_03 = r(est);
	local erro_SpouseChar_03 = r(se);

biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educf healthm healthf hhtype pos1m pos1f), robust;
	local coef_SpouseEduc_03 = r(est);
	local erro_SpouseEduc_03 = r(se);

biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm hhtype pos1m pos1f), robust;
	local coef_HealthSt_03 = r(est);
	local erro_HealthSt_03 = r(se);

biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf pos1m) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf pos1f), robust;
	local coef_DepChild_03 = r(est);
	local erro_DepChild_03 = r(se);



*** MATRIZ ***;

mat Table10_03 = ///	
`coef_none_03',		`erro_none_03'		\ ///
`coef_all_03',		`erro_all_03'		\ ///
`coef_SpouseChar_03',	`erro_SpouseChar_03'	\ ///
`coef_SpouseEduc_03', 	`erro_SpouseEduc_03' 	\ ///
`coef_HealthSt_03', 	`erro_HealthSt_03' 	\ ///
`coef_DepChild_03', 	`erro_DepChild_03';


mat rown Table10_03 = none all SpouseChar SpouseEduc HealthSt DepChild;
mat coln Table10_03 = Coef StError;

mat list Table10_03;




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
	
	
	
**** Biprobit;



********************** Equalizing the age at retirement for both men and women: 65;


** Old system;
biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;

predict p00_old1_03, p00;
predict p11_old1_03, p11;
predict p01_old1_03, p01;
predict p10_old1_03, p10;

** New system;
biprobit (retirem= rratem rratef agepm lsm agepf1 lsf1 agem agef educm educf healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf1 lsf1 agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;
								
predict p00_new1_03, p00;
predict p11_new1_03, p11;
predict p01_new1_03, p01;
predict p10_new1_03, p10;


*** GRaphs;

** p00;
preserve;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p00_old1_03 agem, bw(.4)) (lowess p00_new1_03 agem, bw(.4)),

title(2003)

ytitle(Prob of both not retired)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;

graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p00_03.pdf" , replace;


** p11;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p11_old1_03 agem, bw(.4)) (lowess p11_new1_03 agem, bw(.4)),

title(2003)

ytitle(Prob of both retired)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;

graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p11_03.pdf" , replace;


** p01;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p01_old1_03 agem, bw(.4)) (lowess p01_new1_03 agem, bw(.4)),

title(2003)

ytitle(Prob of husband retired and wife not)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;

graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p01_03.pdf" , replace;


** p10;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p10_old1_03 agem, bw(.4)) (lowess p10_new1_03 agem, bw(.4)),

title(2003)

ytitle(Prob of husband not retired and wife retired)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;


graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p10_03.pdf" , replace;

restore;




*drop p00_old p11_old p01_old p10_old p00_new p11_new p01_new p10_new;



********************** Rising the age at retirement for both men and women: 68;


** Old system;
biprobit (retirem= rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm lsm agepf lsf agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;

predict p00_old2_03, p00;
predict p11_old2_03, p11;
predict p01_old2_03, p01;
predict p10_old2_03, p10;

** New system;
biprobit (retirem= rratem rratef agepm2 lsm2 agepf2 lsf2 agem agef educm educf healthm healthf hhtype pos1m pos1f) (retiref=rratem rratef agepm2 lsm2 agepf2 lsf2 agem agef educm educf healthm healthf hhtype pos1m pos1f), robust;
								
predict p00_new2_03, p00;
predict p11_new2_03, p11;
predict p01_new2_03, p01;
predict p10_new2_03, p10;


*** GRaphs;

** p00;
preserve;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p00_old2_03 agem, bw(.4)) (lowess p00_new2_03 agem, bw(.4)),

title(2003)

ytitle(Prob of both not retired)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;

graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p00_03.pdf" , replace;


** p11;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p11_old2_03 agem, bw(.4)) (lowess p11_new2_03 agem, bw(.4)),

title(2003)

ytitle(Prob of both retired)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;

graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p11_03.pdf" , replace;


** p01;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p01_old2_03 agem, bw(.4)) (lowess p01_new2_03 agem, bw(.4)),

title(2003)

ytitle(Prob of husband retired and wife not)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;

graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p01_03.pdf" , replace;


** p10;

keep if agef > 54; 

keep if agef < 70;

twoway(lowess p10_old2_03 agem, bw(.4)) (lowess p10_new2_03 agem, bw(.4)),

title(2003)

ytitle(Prob of husband not retired and wife retired)

xtitle(Age) 

legend(order(1 "Old System"  2 "New System"))
;


graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p10_03.pdf" , replace;

graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p10_03.pdf";

	
	
***** Para abrir os gráficos;


graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p00_03.pdf";
graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p11_03.pdf";
graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p10_03.pdf";
graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_p01_03.pdf";

graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p00_03.pdf";
graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p11_03.pdf";
graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p10_03.pdf";
graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p01_03.pdf";



graph combine biprobit1_p00_03 biprobit1_p11_03 biprobit1_p10_03 biprobit1_p01_03 ///
	, col(2) ycom xcom;
	
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit1_03.pdf", replace;

graph use "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_p10_03.pdf";

graph combine biprobit2_p00_03 biprobit2_p11_03 biprobit2_p10_03 biprobit2_p01_03 ///
	, col(2) ycom xcom;
	
	graph save "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Log\ago2015\biprobit2_03.pdf", replace;



restore;
	
saveold "D:\New\Laeticia\UltimoBackup_13.09.2013\MeuU_SEMPRE_ATUALIZAR\Papers\Bernardo\Stata\Bases\Retire_2003.dta", replace;



log c;

