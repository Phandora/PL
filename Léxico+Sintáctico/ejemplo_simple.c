principal {
    var 
    real base;
    entero potencia ; 
    finvar
    
    real Potencia (real base, entero exponente){
        var
        real aux; 
        entero indice; 
        finvar
        indice = 0;
        aux = base;

        mientras (indice < base){
            aux = aux * base;
            indice = indice + 1;
        }

        devolver aux;
    }

    entero RangoMatriz3x3 (entero M){
        var
        entero derechaIzquierda, izquierdaDerecha, result;
        finvar

       
        derechaIzquierda = M[0,0] + M[1,1] + M[2,2] 
                         + M[0,1] + M[1,2] + M[2,0]
                         + M[0,2] + M[1,0] + M[2,1];

        izquierdaDerecha = M[0,2] + M[1,1] + M[2,0]
                         + M[0,1] + M[1,0] + M[2,2]
                         + M[0,0] + M[1,2] + M[2,1];
        
        result = derechaIzquierda - izquierdaDerecha;
        
        si(result != 0){
            salida "Es de rango 3";
        }sino{
            salida "No es de rango 3";
        }
    }

    booleano QuienEsMayor(entero vector, entero limite, entero tamanio){
        var
        booleano vector[tamanio];
        entero indx;
        finvar

        indx = 0;

        mientras(indx != tamanio){

            si(vector[indx] < limite){
                vector[indx] = verdadero;
            }sino{
                vector[indx] = falso;
            }

            indx = ++indx;
        }

        devolver vector;
    }

    salida Potencia(base, potencia);
}
