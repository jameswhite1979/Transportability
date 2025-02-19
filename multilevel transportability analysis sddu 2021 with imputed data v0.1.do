***Transporting the effect of the ASSIST school‐based smoking prevention intervention to English adolescents The Smoking, Drinking and Drug Use among Young People in England Survey (2004 to 2021): a secondary analysis of a randomized controlled trial**


***Transportability analysis - SDDU 2021**
use "C:\Users\wppjw\OneDrive - Cardiff University\Papers\Ideas\Transportability\Data\Addiction\assist and sddu 2021 v0.7 12343.dta" 

**Sort by cluster level indicator variable: as1q1trialid and participant ID: as1id***
sort as1q1trialid as1id 

***Generate weights***
**Estimate selection weights using a logit model in an imputed dataset. Run logistic regression to estimate the propensity score and save the estimation results in miest. Study: Outcome (1=Trial population, 0=target population).**
mi estimate, or saving(miest, replace): logit study age i.classonsmoking i.age1stciggg1 girl i.ethnicbin1 i.basesmokingstatus1 smokehouse2

**Predicts the linear predictor from the previous model and stores it in xb_mi**
mi predict xb_mi using miest

**Calculates the propensity score (probability of being in the trial population) using the inverse logit of the linear predictor and stores it in phat.**
quietly mi xeq: generate phat = invlogit(xb_mi)

***Re-estimates the logistic regression model without covariates to get the overall probability of being in the trial population.***
mi estimate, saving(miest, replace): logit study

***Remove the previous xb_mi to avoid conflicts.***
drop xb_mi

****Predicts the linear predictor from a model above without covariates and stores it in xb_mi***
mi predict xb_mi using miest

***Generate predicted probabilities of the dependent variable using the logistic regression model previously estimated. The p option specifies that the predicted probabilities should be stored in the variable num.****
quietly mi xeq: generate num = invlogit(xb_mi)

*Generates a weight variable wt that is used in the subsequent weighted regression. The formula calculates the weight as the inverse of the product of the predicted probabilities of membership of the trial (assist=1) and target population (SDDU=0) groups.*
gen wt=((1-phat)/(phat))*(num/(1-num))

*Sets the weight variable wt to 0 for observations where study=0, effectively removing them from the regression analysis. This is because the analysis focuses on estimating the effect of the intervention in the trial population which is study=1.*
replace wt=0 if study==0

**convert to flong as esample requires flong data**
save "C:\Users\wppjw\OneDrive - Cardiff University\Papers\Ideas\Transportability\Data\Addiction\assist and sddu 2021 v0.4 12343.dta"
mi convert flong
save "C:\Users\wppjw\OneDrive - Cardiff University\Papers\Ideas\Transportability\Data\Addiction\assist and sddu 2021 v0.5 12343.dta"

*Estimates a weighted multuilevel logistic regression model in trial participants with the independent variable i.groupitt indicating the trial arm, using the weight variable wt. esample(esample) is used to creates a variable esample indicating which observations were used in the analysis.|| as1q1trialid:: Specifies a random intercept for the cluster ID.***
mi estimate, saving(miestfile, replace) esample(esample) or cmdok: melogit weeklysmoker4 basesmoker stfsm stsize stprivate stwelsh steng groupitt [pweight=wt]|| as1q1trialid:

***Repeats the analysis but without using the propensity score weights, allowing for comparison between weighted and unweighted results***
drop esample
mi estimate, saving(miestfile, replace) esample(esample) or cmdok: melogit weeklysmoker4 basesmoker stfsm stsize stprivate stwelsh steng groupitt || as1q1trialid:


**Sensitivity analysis to just run in English schools**
drop if steng ==0
mi estimate, saving(miestfile, replace) esample(esample) or cmdok: melogit weeklysmoker4 basesmoker stfsm stsize stprivate stwelsh steng groupitt [pweight=wt]|| as1q1trialid:
