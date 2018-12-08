principal {
	var
		entero ve; 
		real vf;
		caracter vc ;
		booleano vl ;
		entero d[3,3];
		entero a[10,20];
		entero b[20,40];
		entero c[10, 40];
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
			
			xf= funcionC (verdadero, 10);
			x2= xf*(funcionC(falso,1)-funcionC(verdadero,23))/10.0;
			
			mientras (x2*funcionC(falso,1)-xf<10.0)
				x2= x2*xf ;
				
		}
		
		real funcionD (real d1){
			var
				caracter dato ;
				entero valor ;
			finvar
			
			caracter funcionE (caracter e1, caracter e2){
				entrada "introduzca dos caracteres: ", e1, e2 ;
				si (e1=='a')
					devolver e1 ;
				sino 
					si (e1=='b')
						devolver e2 ;
					sino
						devolver ' ';
			}

			entrada "Introduzca un valor entero: ", valor ;
		
			si (d1>0.0){
				var
					entero dato ;
				finvar

				dato= 2;
				dato= valor*20/dato;
			}
			sino {
				valor= valor * 100 ;
				d1= d1/1000.0 ;
			}
		
			devolver d1 ;
		}

		x1=0;
	}

vf=0;
c=a**b;
d = {1,2,3 ; 1, 2,3};
}
