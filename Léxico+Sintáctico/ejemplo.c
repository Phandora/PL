booleano es_a_mayor_que_b(entero numero_a , entero numero_b){
	booleano  salidas=falso;
	
	si (numero_a > numero_b){
		
		salidas=verdadero;
		
	}
	
	devolver salidas;
}

entero principal(){
	
	entero valor_a = 1000;
	entero valor_b = 20;
	entero suma= valor_a+valor_b;
	
	salida  suma;
	
	real a;
	entrada a;
	
	mientras(a > 0){
		
		salida "El valor de a es " a;
		a=a-1;
	}
	
	caracter cadena='hola';
	
	salida es_a_mayor_que_b(valor_a ,valor_b);
	
	
}
