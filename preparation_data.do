insheet using  "D:\MAG2\S2\Stata\project\prix_logement.csv",  clear
log using preparation_data.log
browse


/*On va effacer des collones qu'on n'utilise pas     */
keep location time value 
save "D:\MAG2\S2\Stata\project\prix_logement.dta"
reshape wide value, i(location) j(time)
keep location
rename location CountryCode
save "D:\MAG2\S2\Stata\project\list_country.dta", replace



/* variable GDP par tête   */
import excel  "D:\MAG2\S2\Stata\project\gdp_capita.xlsx", firstrow  clear
browse
drop SeriesName SeriesCode CountryName

sort CountryCode
/*before commencer avec l'étape reshape entre wide et long, on a vu qu'il y a des duplicata pour le countrycode 
(ce sont les missing value de "countrycode", donc que dans cette étape je dois éffacer 5 lignes en duplicata)    */ 
drop in 1/5
save "D:\MAG2\S2\Stata\project\gdp_per_capita_full.dta"
use "D:\MAG2\S2\Stata\project\list_country.dta", clear
sort CountryCode
merge m:1 CountryCode using "D:\MAG2\S2\Stata\project\gdp_per_capita_full.dta" 

drop in 50/269
drop if inlist(CountryCode, "OECD", "EA", "EA17")
drop _merge
tab _merge

gsort CountryCode 
reshape long YR, i(CountryCode) j(year)
rename YR GDP_per_capita
save "D:\MAG2\S2\Stata\project\gdp_per_capita46.dta"


/* variable GDP_growth   */
import excel  "D:\MAG2\S2\Stata\project\gdp_growth.xlsx", firstrow  clear
browse
drop SeriesName SeriesCode CountryName

sort CountryCode
/* dans cette étape je dois éffacer 5 lignes en duplicata)    */ 
drop in 1/5
save "D:\MAG2\S2\Stata\project\gdp_growth_full.dta"
use "D:\MAG2\S2\Stata\project\list_country.dta", clear
sort CountryCode
merge m:1 CountryCode using "D:\MAG2\S2\Stata\project\gdp_growth_full.dta" 

drop in 50/269
drop if inlist(CountryCode, "OECD", "EA", "EA17")
drop _merge
tab _merge

gsort CountryCode 
reshape long YR, i(CountryCode) j(year)
rename YR GDP_growth
save "D:\MAG2\S2\Stata\project\gdp_growth46.dta"



/* variable inflation   */
import excel  "D:\MAG2\S2\Stata\project\inflation.xlsx", firstrow  clear
browse
drop SeriesName SeriesCode CountryName

sort CountryCode
/* dans cette étape je dois éffacer 5 lignes en duplicata)    */ 
drop in 1/5
save "D:\MAG2\S2\Stata\project\inflation_full.dta"
use "D:\MAG2\S2\Stata\project\list_country.dta", clear
sort CountryCode
merge m:1 CountryCode using "D:\MAG2\S2\Stata\project\inflation_full.dta" 

drop in 50/269
drop if inlist(CountryCode, "OECD", "EA", "EA17")
drop _merge


gsort CountryCode 
reshape long YR, i(CountryCode) j(year)
rename YR Taux_inflation
save "D:\MAG2\S2\Stata\project\inflation46.dta"
use "D:\MAG2\S2\Stata\project\inflation46.dta" , clear


/* variable population   */
import excel  "D:\MAG2\S2\Stata\project\population.xlsx", firstrow  clear
browse
drop SeriesName SeriesCode CountryName

sort CountryCode
/* dans cette étape je dois éffacer 5 lignes en duplicata)    */ 
drop in 1/5
save "D:\MAG2\S2\Stata\project\population_full.dta"
use "D:\MAG2\S2\Stata\project\list_country.dta", clear
sort CountryCode
merge m:1 CountryCode using "D:\MAG2\S2\Stata\project\population_full.dta" 

drop in 50/269
drop if inlist(CountryCode, "OECD", "EA", "EA17")
drop _merge
drop time_stata


gsort CountryCode 
reshape long YR, i(CountryCode) j(year)
rename YR Total_population
save "D:\MAG2\S2\Stata\project\population46.dta"






/* variable taux d'intérêt   */
import excel  "D:\MAG2\S2\Stata\project\taux_interet.xlsx", firstrow  clear
browse
drop SeriesName SeriesCode CountryName

sort CountryCode
/* dans cette étape je dois éffacer 5 lignes en duplicata)    */ 
drop in 1/5
save "D:\MAG2\S2\Stata\project\taux_interet_full.dta"
use "D:\MAG2\S2\Stata\project\list_country.dta", clear
sort CountryCode
merge m:1 CountryCode using "D:\MAG2\S2\Stata\project\taux_interet_full.dta" 

drop in 50/269
drop if inlist(CountryCode, "OECD", "EA", "EA17")
drop _merge
 /* Attention: cette table a beaucoup des values manquants   */


gsort CountryCode 
reshape long YR, i(CountryCode) j(year)
rename YR Taux_interet
save "D:\MAG2\S2\Stata\project\taux_interet46.dta"



/* merge toutes variables dans une base de donnée    */
use "D:\MAG2\S2\Stata\project\prix_logement.dta", clear
rename location CountryCode
rename value Prix_logement
rename time year
drop if inlist(CountryCode, "OECD", "EA", "EA17")
save "D:\MAG2\S2\Stata\project\prix_logement46.dta"
/*merge  with GdP per capita  */
use "D:\MAG2\S2\Stata\project\gdp_per_capita46.dta", clear
sort CountryCode
merge 1:1 CountryCode year using "D:\MAG2\S2\Stata\project\prix_logement46.dta"
drop _merge
save "D:\MAG2\S2\Stata\project\BDD_before.dta"

/*merge  with GdP growth */
use "D:\MAG2\S2\Stata\project\gdp_growth46.dta", clear
sort CountryCode
merge 1:1 CountryCode year using "D:\MAG2\S2\Stata\project\BDD_before.dta"
drop _merge
save "D:\MAG2\S2\Stata\project\BDD_before.dta", replace


/*merge  with Inflation */
use "D:\MAG2\S2\Stata\project\inflation46.dta", clear
sort CountryCode
merge 1:1 CountryCode year using "D:\MAG2\S2\Stata\project\BDD_before.dta"
drop _merge
save "D:\MAG2\S2\Stata\project\BDD_before.dta", replace

/*merge  with total Population */
use "D:\MAG2\S2\Stata\project\population46.dta", clear
sort CountryCode
merge 1:1 CountryCode year using "D:\MAG2\S2\Stata\project\BDD_before.dta"
drop _merge
save "D:\MAG2\S2\Stata\project\BDD_before.dta", replace

/*merge  with total Taux d'intérêt */
use "D:\MAG2\S2\Stata\project\taux_interet46.dta", clear
sort CountryCode
merge 1:1 CountryCode year using "D:\MAG2\S2\Stata\project\BDD_before.dta"
drop _merge
save "D:\MAG2\S2\Stata\project\BDD_before.dta", replace


describe
