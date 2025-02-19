***Transporting the effect of the ASSIST school‐based smoking prevention intervention to English adolescents The Smoking, Drinking and Drug Use among Young People in England Survey (2004 to 2021): a secondary analysis of a randomized controlled trial**

***Complete case analysis**
use "C:\Users\wppjw\OneDrive - Cardiff University\Papers\Ideas\Transportability\Data\Addiction\complete case combined 2021 v0.3.dta", clear

***Generate weights. Study: Outcome (1=Trial population, 0=target population).***
logit study age i.classonsmoking i.age1stciggg girl i.as1ethnic i.basesmokingstatus smokehouse2, or 

*Generates predicted probabilities of the dependent variable study using the logistic regression model estimated in the previous line. The p option specifies that the predicted probabilities should be stored in the variable ps.*
predict ps, p

***Re-estimates the logistic regression model without covariates to get the overall probability of being in the trial population.***
quietly logit study

*Generates predicted probabilities of the dependent variable using the logistic regression model estimated in the previous line. The p option specifies that the predicted probabilities should be stored in the variable num.*
predict num, p

*Generates a weight variable wt that is used in the subsequent weighted regression. The formula calculates the weight as the inverse of the product of the predicted probabilities of membership of the trial (assist=1) and target population (SDDU=0) groups.*
gen wt=((1-ps)/(ps))*(num/(1-num))


*Sets the weight variable wt to 0 for observations where study=0, effectively removing them from the regression analysis. This is because the analysis focuses on estimating the effect of the intervention in the trial population which is study=1.*
replace wt=0 if study==0

*Estimates a weighted multilevel logistic regression model with the dependent variable study and the independent variable i.groupitt, using the weight variable wt. || as1q1trialid:: Specifies a random intercept for the cluster ID.*
melogit weeklysmoker4 basesmoker stfsm stsize stprivate stwelsh steng groupitt [pweight=wt]|| as1q1trialid:, or 


**********************************
