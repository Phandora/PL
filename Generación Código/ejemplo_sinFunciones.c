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

        si (d*curr == n){
            salida "valor: ", curr;
            n = n / curr;
        }sino{
            curr = curr + 1;
        }
    }

    salida "\n";
}