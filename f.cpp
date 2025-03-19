#include <iostream>
#include <vector>
using namespace std;

struct Fecha{
    int dia;
    int mes;
    int año;
};
struct Jugador{
    string nombre;
    int camiseta_num;
};
struct Equipo{
    string nombre;
    vector<Jugador> jugadores;
    int g_contra;
    int g_fav;
    vector<char> hist;
};
struct Partido{
    string equipo_vis;
    string equipo_loc;
    int goles_vis;
    int goles_loc;
    Fecha fecha;
    string estadio;
};

vector<Partido> partido_jugado(vector<Equipo> &equipos){
    vector<Partido> partidos;
    Partido partido;
    char loop='y';
    while(loop=='y'){
        cout<<"ingresar nombre de los equipos"<<endl;
        //se fija que los nombres puestos sean iguales a los de los equipos.
        bool a=true;
        string name1;
        while(a==true){
            cout<<"ingrese equipo visitante con nombre valido"<<endl;
            cin>>name1;
            for(int i=0;i<equipos.size();i++){
                if(name1==equipos[i].nombre){
                    name1=partido.equipo_vis;
                    a=false;
                }
            }
        }
        bool b=true;
        string name2;
        while(b==true){
            cout<<"ingrese equipo local con nombre valido"<<endl;
            cin>>name2;
            for(int i=0;i<equipos.size();i++){
                if(name2==equipos[i].nombre){
                    name2=partido.equipo_loc;
                    b=false;
                }
            }
        }
        cout<<"goles visitantes"<<endl;
        cin>>partido.goles_vis;
        cout<<"goles locales"<<endl;
        cin>>partido.goles_loc;
        cout<<"fecha del partido"<<endl;
        cout<<"dia"<<endl;
        cin>>partido.fecha.dia;
        cout<<"mes"<<endl;
        cin>>partido.fecha.mes;
        cout<<"año"<<endl;
        cin>>partido.fecha.año;
        cout<<"estadio"<<endl;
        cin>>partido.estadio;
        partidos.push_back(partido);
        if(partido.goles_loc>partido.goles_vis){
            for(int i){

            }
        }
        cout<<"añadir otro partido? y/n"<<endl;
        cin>>loop;
    }
}

int main(){
    Equipo equipo;
    vector<Equipo> equipos;
    int loop=0;
    while(loop<25){
        cout<<"ingresar nombre del equipo"<<endl;
        cin>>equipo.nombre;
        cout<<"ingresar jugadores"<<endl;
        int i=0;
        while(equipo.jugadores.size()<11){
            if(i==0){
                cout<<"ingrese arquero"<<endl;
                cout<<"nombre"<<endl;
                cin>>equipo.jugadores[i].nombre;
                cout<<"numero de camiseta"<<endl;
                cin>>equipo.jugadores[i].camiseta_num;
            }
            else{
                cout<<"ingrese jugador"<<endl;
                cout<<"nombre"<<endl;
                cin>>equipo.jugadores[i].nombre;
                cout<<"numero de camiseta"<<endl;
                cin>>equipo.jugadores[i].camiseta_num;
            }
            i++;
        }
        loop++;
    }
}