principal{

    var 
    entero n, curr;
    finvar

    entrada "Introduce numero: " , n;
    
    curr = 2;

    mientras(curr < n){
        var
            entero d;
        finvar

        d = n / curr;

        si ( curr == n){
            salida "valor: ", curr;
            n = n / curr;
            si (n > 1){
                n = n + curr;
            }
        }
    }

    salida "\n";
}