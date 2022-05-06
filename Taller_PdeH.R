# problema 3 Ejercicios propuestos
Xa=c(17,13,6,5,5,10,8,6,7)  # grupo experimental antes
Xd=c(3,7,2,3,6,2,1,0,2)     # grupo experimental despues

Ya=c(5,8,14,16,6,5,8,10,9)   # grupo control antes
Yd=c(4,9,12,15,4,3,7,6,7)    # grupo control despues


# prueba 1 : Ho: mu_Xa = mu_Xd vs Ha: mu_Xa != mu_Xd, grupos pareados
t.test(Xa,Xd, paired = TRUE) # p-value = 0.003471, rechazo Ho, acepto Ha. las medias son diferentes

# prueba 2 : Ho: mu_Xa = mu_Ya. grupos independientes
var.test(Xa,Ya) # p-value = 0.8599, asumimos que las varianza son iguales
t.test(Xa,Ya, paired = FALSE,var.equal = TRUE) #p-value = 0.8153, asumo que las medias son iguales
# como las medias y las varianza se asumen iguales , los dos grupos son comparables


# prueba 3 : Ho. mu_Ya = mu_Yd, grupos pareados
t.test(Ya,Yd, paired = TRUE) # = 0.008079, son diferentes


# prueba 4 : Ho: mu_Xd = Yd , grupos independientes
var.test(Xd,Yd) #  p-value = 0.1315, no se rechaza Ho, se asumen varianzas iguales
t.test(Xd,Yd, paired = FALSE, var.equal = TRUE) #p-value = 0.008654, rechazamos Ho, las medias son diferentes

de=Xa-Xd # diferencia grupo experimental antes menos despues
dc=Ya-Yd # diferencias grupo control antes menos  despues

var.test(de,dc) #p-value = 0.004229, las varianzas son diferentes
t.test(de,dc, paired = FALSE, var.equal = FALSE) #p-value = 0.01857
t.test(de,dc, paired = FALSE, var.equal = FALSE, alternative = "greater") #p-value = 0.009285


#.........................................................................















  