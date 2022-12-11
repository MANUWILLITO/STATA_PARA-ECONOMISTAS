
*==============================================
* CURSO COMPLETO ECONOMETRIA CON STATA 
*   Jose Rodney Menezes De la Cruz
*==============================================

* SESIÓN 1 - COMANDOS BÁSICOS DE STATA Y USO DE FACTORES DE EXPANSIÓN 
*=====================================================================
* Se tratarán los siguientes temas:
* 1. Establecimiento de rutas y guardado de bases de datos
* 2. Definición de etiquetas de variables y categorías 
* 3. Tabulados simples y cruzados. Uso de factores de expansión
* 4. Creación de variables
* 5. Exportar e importar bases


* Limpiar la memoria del programa
*=================================
clear all 


* Definición de rutas (carpetas)
*================================
global ruta1 "/Users/JoseRodney/Cursos/Econometria_Stata/Sesión 1/Bases de datos"

* Trabajaremos con la base "base_empleo" para conocer cómo trabajan los comandos:

* Informamos a STATA que a partir de este momento se extraerá la información de la carpeta que denominamos "ruta1"
use "$ruta1/base_empleo.dta",clear
* Esta es una base de datos de individuos con sus respectivas características personales y su estado de empleo en la variable "pea":


* Abriendo base de datos
*========================
use codram sexo edad using "$ruta1/base_empleo.dta", clear	//usando sólo algunas variables
br
use if sexo==1 using "$ruta1/base_empleo.dta", clear	    //usando sólo algunas observaciones según if
br				
use in 1/20 using "$ruta1/base_empleo.dta", clear			//usando sólo algunas observaciones según in 
br
use "$ruta1/base_empleo.dta",clear


* Creando carpeta
*=================
* Creamos tres nuevas carpetas dentro del directorio de trabajo que se llame "Trabajadas", "Resultados" y "Gráficos"
mkdir "$ruta1/Trabajadas"
mkdir "$ruta1/Resultados"
mkdir "$ruta1/Graficos"		
global ruta2 "/Users/JoseRodney/Cursos/Econometria_Stata/Sesión 1/Bases de datos/Trabajadas"

* Vemos dónde está ubicado el directorio por defecto
pwd

* ¿Dónde está el directorio oficial de Stata?
sysdir



* Browse
*========
* Podemos visualizar la base con el comando "browse" o su abreviatura "br"
browse
* Para visualizar solo algunas variables de interés
br sexo edad pea 


* Describe
*==========
* Descripción general de las variables incluidas en la base:
describe
* Solo muestra info de las variables indicadas
describe pea 

*TH: CHEKAR
/*
int 
byte 
*/


* Help
*======
* La herramienta de ayuda de Stata
help describe
h describe


* Codebook
*==========
* El comando "codebook" también brinda información más detallada:
codebook pea edad
codebook pea 
codebook edad, all


* Ordenando variables
*=====================
gen id=_n
order id codram-pesoent


* Tabulate
*==========
/* Podemos apreciar que la variable "pea" tiene valores numéricos, pero sin información adicional no sabemos que representa, por 
lo que resulta necesario ponerle una etiqueta */
tabulate pea
tab pea, m /*tab: forma abreviada de tabulate*/
tab pea, missing
br pea

codebook seguro
tab seguro
tab seguro, missing /*reporta/ cuantifica también los casos perdidos o missing*/


* Labels
*========
/* Etiquetamos la variable: 
label define: para definir la etiqueta 
label values: para colocar la etiqueta a los valores de la variable
label variable: para colocar etiqueta a la variable
*/
label define etiq 1 "Ocupado" 2 "Desempleado" 3 "Inactivo-No PEA"
label values pea etiq

* Verificando el cambio
tab pea
br pea

* Tabla cruzada con etiquetas:
tab pea sexo
tab pea sexo, col row     // reporta porcentajes por columna y fila

* Además, también es posible etiquetar la base de datos:
label data "Sesion 1 del Taller de STATA"
describe


* Conteo
*========
*Contar número de observaciones:
count
count if edad>=20


* Listas
*========
* Visualizar observaciones colocando restricciones:
list sexo edad if pea==3
* Se puede realizar la misma acción utilizando browse
br sexo edad pea if pea==3


* Summarize, Return and display
*===============================
* Ahora obtendremos algunos indicadores resumen de variables seleccionadas con el comando summarize (sum)
summarize  edad ingreso school sexo

* Colocando alguna restricción 
sum edad ingreso school if sexo==0 

* Brinda detalle sobre lo último que fue almacenado en la memoria del programa
return list

*Summarize con más detalle (opción "detail")
sum edad ingreso school sexo, detail
sum edad if sexo==1, detail

* ¿como podriamos acceder a los resultados almacenados?
return list 
display r(mean)
display r(min)


*==============
* Tabulaciones
*==============

* Tabstat
*=========
* Comando tabstat para reportar info resumen:
tabstat ingreso /*solo reporta la media*/
tabstat ingreso, stat(mean variance sd min max) /*reporta información solicitada*/


* Frequencias
*=============
tab sexo 		/*simple*/
tab pea sexo 	/*cruzado*/

* Porcentajes por fila y columna
tab pea sexo, row nofreq
tab pea sexo, col nofreq
tab pea sexo, row col 


* Table
*=======
* Comando table para obtener promedios, u otros estadísticos en tablas cruzadas:
table pea sexo
table pea sexo, content(mean edad)                   // Me da la media de la edad para cada caso
table pea sexo, c(mean edad) f (%10.2f) row col      // f = formato en (10 ENTEROS 2 DECIMALES) 
table pea sexo, c(mean edad mean ingreso) f (%10.2f) // Para cada variable tengo que poner lo que quiero que me asigne


* Factores de expansión
*=======================
* Factores de expansión para bases de datos de encuestas representativas (ENAHO, ENDES, etc.)
* Existe el llamado "factor de expansión poblacional. En este caso dicha variable se llama "pesoper"

sum pesoper

* Cuando se requiere generalizar el resumen a nivel poblacional, es necesario utilizar un factor de expansión
table pea sexo, row col                 // conteo de la muestra
table pea sexo [iw=pesoper],row col     // sería el conteo a nivel poblacional

table pea sexo, content(mean edad sd edad) f (%10.2f)
table pea sexo [iw=pesoper], content(mean edad sd edad) f (%10.2f) /*ver las diferencias*/

* Tablas separadas según algún criterio:
table pea [iw=pesoper], c(mean edad mean ingreso) f(%12.2f) row col
bysort sexo: table pea [iw=pesoper], c(mean edad mean ingreso)  f(%12.2f) row col /*tablas separadas seg˙n sexo*/


*========================
* Creación de variables: 
*========================

* Gen
*=====
* Generar logaritmo del ingreso 
generate ling=ln(ingreso)         // función "ln" para crear logaritmos
gen ling10=ln(ingreso+10)
sum ling ling10

* Dummy de hombre:
gen hombre=1 if sexo==1
replace hombre=0 if sexo==0

gen male=(sexo==1)

	
* Egen and replace
*==================	

* Generar ingreso promedio por edad:
egen ingr_promedio=mean(ingreso), by(edad)
br edad ingr_promedio

* Remplazar valores de acuerdo a condiciones (comando "replace")
replace ingr_promedio=0 if edad==14

* Generar ingreso por sexo y edad
egen ing_se=mean(inc), by(sexo edad)

* Comando "egen" (funciones más complejas):
egen ingr_max=max(ingreso)
egen ingr_mean=mean(ingreso), by(sexo)
tab ingr_mean sexo

*Etiquetar las variables y categorias creadas:
label var ling "Logaritmo del ingreso"
label var hombre "Dummy de hombre"
label var ingr_promedio "Ingreso promedio por edad"


* Rename
*========
* Renombrar variables
rename ling log_ingreso


* Recode
*=========
* Creamos una variable de grupos de edad (recodificando por categorías con el comando "recode")
gen grupo_edad=edad
recode grupo_edad 0/14=1 15/25=2 26/54=3 55/max=4
* Alternativamente, puede usarse: recode edad 0/14=1 15/25=2 26/54=3 55/max=4, gen(grupo_edad)

*Etiquetamos los valores
label define etiq_edad 1 "De 0 a 14" 2 "De 15 a 25" 3 "De 26 a 54" 4 "De 55 a m·s" 
label values grupo_edad etiq_edad

tab grupo_edad
tab grupo_edad, nolabel // Permite visualizar los valores de las variables categóricas


* Dummy
*=======
*Generar variables dummy en conjunto
tab pea, g(categ_pea)


* Sort: Orden
*=============
*Ordenar los datos segun alguna variable
sort ingreso
br ingreso

sort sexo edad // más de una variable
br sexo edad


* Matriz de correlaciones (varianzas y covarianzas)
*===================================================
corr edad ingreso


* Drop
*=======
* Borramos alguns variables de la base, que no podrían ser interés con el comando "drop":
drop actecon anho afilsind


* Save
*=======
* Guardamos la base de datos (recordar que programamos la "carpeta2").
save "$ruta2/base_trabajada.dta",replace


* Export
*=========
* También es posible guardarla en formato excel:
export excel using "$ruta2/base_trabajada_excel.xlsx", firstrow(variables) replace


* Eliminando archivos
*=====================
erase "$ruta2/base_trabajada_excel.xlsx"					//borramos los archivos outsheet creados

clear all


* Import
*========
* Convertimos data de excel a .dta
import excel "$ruta1/pwt80.xlsx", sheet("Data") firstrow
save "$ruta2/pwt80.dta", replace


* Keep 
*======
* Se tienen datos para 167 países desde 1950 al 2011
keep if year>=1960 & year <=1970
keep year countrycode rgdpo hc pop csh_g


* Tostring
*==========
* Cambiar de tipo de numérico a tipo string, ignorando valores missing (los deja igual)
tostring pop, replace force


* Destring
*==========
* Cambiar de tipo de string a numÈrico (Celdas vacÌas para string no numÈricos, es decir, missing)
destring pop, replace force

compress
save "$ruta2/pwt80 s1.dta", replace
clear all


* Log Files
*===========
* En ocasiones deseamos guardar los resultados o tablas obtenidas en un archivo. Para ello utilizaremos el comando "log":
* En esta ocasión guardaremos dicho archivo en la ruta2 "Trabajadas":

log using "$ruta2/primera bitácora.txt", replace  			//comando 1: para iniciar el log. 

sysuse auto, clear 									//cargamos la base auto usando el sysuse
help describe 										//usamos el comando help de describe
describe price weight 								//comando describe sin opciones
d price weight, numbers 							//comando describe con opción numbers

help tabulate 										//usamos el comando help de tabulate
tabulate price in 1/20 								//comando tabulate de las observaciones 1 al 20
tabulate rep78 in 1/20, missing						//comando tabulate de las observaciones 1 al 20 mostrando missings

* Se cierra la sesión de los resultados obtenidos con log close. Luego visualizar el archivo
log close


