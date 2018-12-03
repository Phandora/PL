principal {
	var
		entero ve, b,c,g 
		real vf, n, m ;
		caracter vc ;
		booleano vl ;

	finvar
	
	entero funcionA (entero a1, real a2, caracter a3){
		var
			entero x1, x2 ;
		finvar

		caracter funcionB (caracter b1, booleano b2){
			var
			real xf, x2 ;
			finvar
			real funcionC (booleano c1, entero c2){
				var
				real x1 ;
				finvar
				x1= 1.3 ;
				si (c2>10)
				c2= c2-1 ;
				sino
				x1= 3.1 ;
				devolver x1 ;
			}
			
			xf= functionC (true, 10);
			x2= xf*(funcionC(false,1)-funcionC(true,23))/10.0;
			
			mientras (x2*funcionC(false,1)-xf<10.0)
				x2= x2*xf ;
		}
		
		real funcionD (real d1){
			var
				caracter dato ;
				entero valor ;
			finvar
			
			caracter funcionE (caracter e1, caracter e2){
				entrada "enteroroduzca dos caracteres: ", e1, e2 ;
				si (e1=='a')
					devolver e1 ;
				sino 
					si (e1=='b')
						devolver e2 ;
					sino
						devolver ' ';
			}
			entrada "enteroroduzca un valor entero: ", valor ;
		
			si (d1>0.0+++){
				var
					entero dato ;
				finvar
			
				dato= 2) ;
				dato= valor*20/dato ;
			}
			sino {
				valor= valor * 100 ;
				d1= d1/1000.0 ;
			}
		
			devolver d1 ;
		}

		devolver d2;
	}

b=0;

}
