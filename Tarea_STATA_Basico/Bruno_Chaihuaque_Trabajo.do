/*******************************************************************************
**** Curso: 		STATA Básico
**** Tarea: 		Trabajo aplicativo STATA Básico
**** Autor: 		Bruno Chaihuaque Dueñas
**** Fecha: 		31/01/2021
**** URL  :         https://github.com/bchaihuaque/STATA/blob/master/Tarea_STATA_Basico/Bruno_Chaihuaque_Trabajo.do
*******************************************************************************/
**** configurando path
cls
clear all
if ("`c(username)'"  ==  "bchai"){
		global	tarea   	"D:/Estudiando/Stata/Stata Basico/Tarea"
		}
**** configurando folder structure

		global	do-files  	"${tarea}/do-files"
		global	bases		"${tarea}/bases"

********************************************************************************
**** PARTE 1: CUADROS PARA EL AÑO 2019
********************************************************************************
**** 1.1 generar la base de datos 
use "${tarea}/bases/enaho01a-2019-400", clear /*módulo 400 año 2019 */
merge 1:1 conglome vivienda hogar codperso using "${tarea}/bases/enaho01a-2019-300"
/*
Result                           # of obs.
    -----------------------------------------
    not matched                         5,033
        from master                     5,033  (_merge==1)
        from using                          0  (_merge==2)

    matched                           116,590  (_merge==3)
    -----------------------------------------

*/
gsort -_m // ordenamos de mayor a menor
keep if _merge==3 
*quitamos los valores que no hacen matched
save "${tarea}/bases/unidos-2019", replace
rename a*o enaho

**** 1.2 trabajando con la base
keep enaho conglome vivienda hogar codperso ///
ubigeo p207 p208a p301a /// sexo edad año o grado de estudios
p4191 p4192 p4193 p4194 p4195 p4196 p4197 p4198 // seguro de algún tipo

**** 1.3 renombrar variables
rename p208a edad // renombramos la variable edad
rename p207 sexo // renombramos la variable sexo

**** 1.4 filtrar valores según enunciado
keep if (p4191 == 1 | p4192 == 1 | p4193 == 1 | p4194 == 1 | p4195 == 1 | ///
p4196 == 1 | p4197 == 1 | p4198 == 1) // si tienen algún seguro
keep if (p301a == 3 | p301a == 4 | p301a == 5 | p301a == 6) // si tienen básica regular
 
**** 1.5 generar la variable departamento
gen 	dep=real(substr(ubigeo,1,2))
gen 	prov=real(substr(ubigeo,3,2))
replace dep = 15 if (dep == 15 & prov == 1)
replace dep = 15 if dep==7 // poner 15 si es Callao, porque 15 es para Lima Metropolitana
replace dep = 26 if (dep == 15 & prov > 1)
lab var dep "Departamento"
lab def dep 1 "Amazonas" 2 "Ancash" 3 "Apurimac" /// 
4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 8 "Cusco" ///
9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" ///
13 "Libertad" 14 "Lambayeque" 15 "Lima Metropolitana" 16 "Loreto" ///
17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" ///
21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" ///
25 "Ucayali" 26 "Lima Provincias"
lab val dep dep

**** 1.6 Tabulación
table dep sexo enaho, contents(freq)

********************************************************************************
**** PARTE 2: CUADROS DESDE EL AÑO 2015 al 2019
********************************************************************************
cls
clear all

**** 1.1 generar las bases de datos
forvalues 		i=2015/2019{
use 			"${tarea}/bases/enaho01a-`i'-400", clear //módulo 400
merge 			1:1 conglome vivienda hogar codperso ///
				using "${tarea}/bases/enaho01a-`i'-300" //módulo 300
keep if 		_merge==3
save 			"${tarea}/bases/unidos-`i'", replace
}

**** 1.2 fusión vertical
use "${tarea}/bases/unidos-2015", clear
append using "${tarea}/bases/unidos-2016"
append using "${tarea}/bases/unidos-2017"
append using "${tarea}/bases/unidos-2018"
append using "${tarea}/bases/unidos-2019"

save "${tarea}/bases/unidos-completo", replace
rename 			a*o enaho
**** 1.3 trabajando con la base
keep 			enaho conglome vivienda hogar codperso ///
				ubigeo p207 p208a p301a ///
				p4191 p4192 p4193 p4194 p4195 p4196 p4197 p4198 // seguro de algún tipo

**** 1.4 renombrar variables
rename p208a edad // renombramos la variable edad
rename p207 sexo // renombramos la variable sexo

**** 1.5 filtrar valores según enunciado
keep if (p4191 == 1 | p4192 == 1 | p4193 == 1 | p4194 == 1 | p4195 == 1 | ///
p4196 == 1 | p4197 == 1 | p4198 == 1) // si tienen algún seguro
keep if (p301a == 3 | p301a == 4 | p301a == 5 | p301a == 6) // si tienen básica regular
 
**** 1.6 generar la variable departamento
gen 	dep=real(substr(ubigeo,1,2))
gen 	prov=real(substr(ubigeo,3,2))
replace dep = 15 if (dep == 15 & prov == 1)
replace dep = 15 if dep==7 // poner 15 si es Callao, porque 15 es para Lima Metropolitana
replace dep = 26 if (dep == 15 & prov > 1)
lab var dep "Departamento"
lab def dep 1 "Amazonas" 2 "Ancash" 3 "Apurimac" /// 
4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 8 "Cusco" ///
9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" ///
13 "Libertad" 14 "Lambayeque" 15 "Lima Metropolitana" 16 "Loreto" ///
17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" ///
21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" ///
25 "Ucayali" 26 "Lima Provincias"
lab val dep dep

**** 1.7 Tabulación
table dep sexo enaho, contents(freq)
 