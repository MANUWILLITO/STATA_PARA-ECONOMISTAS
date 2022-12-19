*# ------------- ------- SERIES DE TIEMPO CON STATA 15 ---------------#*
clear all

*1. SIMULACIÓN DE UNA SERIE DE TIEMPO*
input serie1 serie2
gen time=m(2011m1)+_n-1
format time %tm
tsset time
* 1.1 Generar un Ruido Blanco 
set obs 100
gen obs=_n
gen time=m(2000m1)+_n-1
format time %tm
tsset  time
generate ruido_blanco=invnorm(uniform())
line ruido_blanco time

*1.1.1 rudio blanco con constante
gen ruido_noise_drift3 = 3+ruido_blanco
gen ruido_noise_drift5 = 5+ruido_blanco
twoway line ruido_noise_drift3 time ||line ruido_noise_drift5 time
*1.2 Generara paseo aleatorio

forvalues i=1(1)3 {
    gen random_walk_`i'=100
}

*Initial condition: y(0) = 100
*N(0,1) *N(0,5) *N(0,10)
       replace random_walk_1= random_walk_1[_n-1] +    ruido_blanco if _n>=2
       replace random_walk_2= random_walk_2[_n-1] +  5*ruido_blanco if _n>=2
       replace random_walk_3= random_walk_3[_n-1] + 10*ruido_blanco if _n>=2


twoway line random_walk_1 time|| line random_walk_2 time || line random_walk_3 time, ylabel(, nogrid)

*2....... ESTACIONARIEDAD.....*
*2.1 correlograma: prueba estacionariedad
*Funciones ACS y ACP: ruido blanco
ac  ruido_blanco, saving(prueba_normal, replace)
pac ruido_blanco, saving(prueba_parcial, replace)
gr combine prueba_normal.gph  prueba_parcial.gph

ac  ruido_noise_drift3, saving(ruido_noise_drift3ac, replace)
pac ruido_noise_drift3, saving(ruido_noise_drift3pac, replace)
gr combine ruido_noise_drift3ac.gph ruido_noise_drift3pac.gph

*Funciones ACS y ACP: paseo aleatorio
ac random_walk_1 , saving(g1, replace)
pac random_walk_1 , saving(g2, replace)
gr combine g1.gph g2.gph

* 3. Pruebas de estacionariedad
*3.1 Dickey -fuller simple
dfuller ruido_blanco   /*sin intercepto-- constante*/
dfuller AR_11 
dfuller         /*con intercepto y constante*/
                  /*con tendencia*/
				  
*3.2 Dickey-Fuller aumentada
dfuller AR_11 ,lags(2) trend       /*puede ser con interceptoo y tendencia*/

*3.3 Fhilip-Perron
pperron gnp. 
 pperron gnp, lags(4)
 pperron gnp, lags(4) trend
 pperron gnp, lags(4) trend regress.
*3.4  Kwiatkowski, Phillips, Smichdt y Shin (KPSS)..... instalar
* h0= La serie es estacional en tendencia
*h1=La serie no presenta estacionalidad en tendencia
kpss ruido_noise_drift3

*3.5 Andrew- Sivot
ssc desc Zandrews
zandrews [varname] [if exp] [in range] [, maxlags(#) trim(#) break() generate(varname) lagmethod() level(#) graph]
zandrews  ruido_noise_drift3

*4. .... PROCESOS AR(q)....*
local alpha = 15
forvalues i=1(1)3 {
    gen AR_`i'`i'=0
}

      replace AR_11 = `alpha' + 0.87*AR_1[_n-1] +  5*ruido_blanco if _n>=2
      replace AR_22 = `alpha' + 0.90*AR_2[_n-1] +  10*ruido_blanco if _n>=2
      replace AR_33 = `alpha' + 0.30*AR_3[_n-1]+  15*ruido_blanco if _n>=2

twoway line AR_11 time ||line AR_22 time ||line AR_33 time, ylabel(, nogrid) saving(AR, replace)



































