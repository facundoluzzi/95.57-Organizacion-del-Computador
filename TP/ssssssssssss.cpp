#include <iostream>

using namespace std;

int main()
{
	int x = 0;
	int y = 0;
	int inicial = 0;
	
	// Cantidad de veces que debo sumar/restar, cuando es 0, invierto la coordenada, y reseteo el timer
	int timer = 1;
	// Contador de vueltas (al llegar a 2, debe reiniciarse, e invertirse el signo)
	int vueltas = 0;
	// Coordenada a sumar/restar (0-x, 1-y)
	int coordenada = 0;
	// SIGNO ->       0-Negativo 1-Positivo //
	int signo = 1;  
	// Numero ingresado por teclado
	int numero;
	// Cantidad de vueltas totales dadas 
	int cantVueltas = 0;
		
	cout << "Ingrese un numero, y le dire las coordenadas (x, y) " << endl;
	cin >> numero;

	// Copia del timer;
	int copiaTimer = timer;
	
	while(numero > 0)
	{
		// Verifico el timer, e invierto la coordenada
		if(copiaTimer == 0)
		{
			if(coordenada == 1)
			{
				coordenada = 0;
			}
			else
			{
				coordenada = 1;
			}
			copiaTimer = timer;
			vueltas++;
		}
		// Verifico el signo
		if(vueltas == 2)
		{
			vueltas = 0;
			cantVueltas++;
			timer = 1 + cantVueltas;
			copiaTimer = timer;
			// Invierto el signo
			if(signo == 0)
			{
				signo = 1;
			}
			else
			{
				signo = 0;
			}
		}

		
		// Resto
		if(signo == 0)
		{
			// Resto a coordenada X
			if(coordenada == 0)
			{
				x--;
			}
			// Resto a coordenada Y
			if(coordenada == 1)
			{
				y--;
			}
			copiaTimer--;
		}
		// Sumo
		if(signo == 1)
		{
			// Sumo a coordenada X
			if(coordenada == 0)
			{
				x++;
			}
			// Sumo a coordenada Y
			if(coordenada == 1)
			{
				y++;
			}
			copiaTimer--;
		}
		cout << "CopiaTimer: " << copiaTimer << endl;
		cout << "Signo: " << signo << endl;
		cout << "Vueltas: " << vueltas << endl;
		cout << "CantVueltas: " << cantVueltas << endl;
		cout << "Timer: " << timer << endl;
		
		numero--;
	}

	
	cout << "(" << x << ", " << y << ")" << endl;
	system("pause");
	return 0;
}
