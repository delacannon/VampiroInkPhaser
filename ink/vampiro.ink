//Vampiro (Ink + Phaser)

INCLUDE externalFunc

VAR current_location = -> Intro
VAR current_name = ""
VAR cuchillo = false
VAR armario = false
VAR llave = false
VAR crucifijo = false
VAR palanca = false
VAR madera = false
VAR ajos = false
VAR estaca = false
VAR traje = true
VAR traje_on = true
VAR ex_fregadero = false
VAR ex_armario = false
VAR ex_cama = false
VAR ex_sabanas = false
VAR armario_open = false
VAR martillo = false

//goto start knot
-> Intro 

=== Intro ===

Despiertas aturdido. Después de unos segundos te incorporas en el frío suelo de piedra y ves que estás en un castillo. ¡Ahora recuerdas! Eres reXXe y tu misión es la de matar al vampiro. TIENES que matar al vampiro que vive en la parte superior del castillo...

    *[Empezar] -> Vestibulo

-> DONE

=== Vestibulo ===
~ current_location = -> Vestibulo
~ current_name = "Vestíbulo"
{hide_image()}
{show_image_bg("vestibulo")}
Estás en el vestíbulo del castillo. El ambiente es muy húmedo y frío.<>
{traje_on==false: 
    <> Ahora que andas desundo lo notas más.
} 
 <> Estás en un pasillo que se extiende hacia el norte. Al sur queda la puerta de entrada al castillo.

    + [Norte] -> Pasillo
    + [Sur] -> Puerta_de_entrada
    
->DONE

=== Puerta_de_entrada ===
~ current_name = "Puerta de entrada"
¡Tu misión es aquí dentro!
    + [Volver] -> current_location
-> DONE

=== Pasillo ===
~ current_location = -> Pasillo
~ current_name = "Pasillo"
{hide_image()}
{show_image_bg("pasillo_bg")}
Te encuentras en medio del pasillo principal de este piso. Al oeste está la cocina y al este la biblioteca. El pasillo sigue hacia el norte.

     +[Norte] -> Escaleras
     +[Este] -> Biblioteca
     +[Oeste] -> Cocina
     +[Sur] -> Vestibulo
     
-> DONE

=== Cocina ===
~ current_location = -> Cocina
~ current_name = "Cocina"
{hide_image()}
{show_image_bg("cocina_bg")}
Estás en la cocina del castillo. Esto está lleno de cacerolas y de cacharros para cocinar. Hay un horno, un fregadero {ex_fregadero: de piedra vacio} y un armario pequeño {ex_armario==true && llave==false: y cerrado}. 

+ [Examinar el horno] -> Cocina_horno
+ [Examinar el fregadero] -> Cocina_fregadero

{ cuchillo==false:
    Puedes ver un cuchillo.
     + [Examinar el cuchillo] -> Cocina_cuchillo
}

{ armario_open && ajos==false:
    Puedes ver una ristra de ajos.
     + [Examinar ristra de ajos] -> Cocina_ajos
}
 
    + [Examinar el armario] -> Cocina_armario

 
 + [Salir de la cocina] -> Pasillo
     
-> DONE

=== Cocina_horno ===
Un simple horno, no tiene ninguna importancia.
    + [Volver] -> current_location

-> DONE

=== Cocina_fregadero ===
~ ex_fregadero = true
{show_image_bg("fregadero_bg")}
Es un fregadero de piedra. El fregadero está vacío.
    + [Volver] -> current_location

-> DONE

=== Cocina_armario ===
~ ex_armario = true
{llave == false: 
    Está cerrado con llave.
    - else:
    {armario_open==false:
    Abres el armario con la llavecita.
    Al examinarlo se te cae al suelo una ristra de ajos que estaba en su interior.
     + [Examinar la ristra de ajos] -> Cocina_ajos
        - else:
        Está vacío
    }
    ~ armario_open = true
}
    + [Volver] -> current_location

->DONE

=== Cocina_ajos ===
{show_image("ristra de ajos")}
Es una ristra entera de ajos que expelen un olor un tanto asqueroso. Es uno de los cuatro elementos que me servirán para derrotar al vampiro.
    { ajos==false:
     * [Recoger] 
            {add_to_inventory("ristra de ajos",true)}
            {snd_fx()}
            ~ ajos = true
            -> current_location
    }
     + [Volver] -> current_location
->DONE

=== Cocina_cuchillo ===
{show_image("cuchillo")}
- Un simple cuchillo de cocina. Pincha.
    
    { cuchillo==false:
     * [Recoger] 
            {add_to_inventory("cuchillo",true)}
            {snd_fx()}
            ~ cuchillo = true
            -> current_location
    }
    + [Volver] -> current_location
    
-> DONE

=== Biblioteca ===
~ current_location = -> Biblioteca
~ current_name = "Biblioteca"
{hide_image()}
{show_image_bg("biblioteca")}
Te hallas en la biblioteca del castillo. Obviamente está llena de libros interesantes, pero desgraciadamente no tienes tiempo para leerlos.
    {crucifijo && palanca:
        <> Además, ya has recogido todo lo que necesitabas de esta habitación.
    }

    {crucifijo==false:Puedes ver un crucifijo plateado. }
    {palanca==false: 
        {crucifijo:
            - Ves una palanca. 
            -else: 
            <>También ves una palanca.
    } 
   }
    
    {crucifijo == false: 
     + [Examinar crucifijo] -> Biblioteca_cucifijo
    }
     {palanca == false: 
     + [Examinar palanca] -> Biblioteca_palanca
    }
    + [Salir de la biblioteca] -> Pasillo
    
->DONE

=== Biblioteca_palanca ===
{show_image("palanca")}
Es una palanca de acero toledano. Sirve para forzar cosas.
 { palanca==false:
     * [Recoger] 
            {add_to_inventory("palanca",true)}
            {snd_fx()}
            ~ palanca = true
            -> current_location
    }
    + [Volver] -> current_location
->DONE

=== cuchillo_obj ===
Un simple cuchillo de cocina. Pincha.
    + [Volver] -> current_location
-> DONE

=== llavecita_obj ===
Esta pequeña llavecita tiene la pinta de abrir un armario o algo así.
+ [Volver]->current_location
-> DONE

=== crucifijo_obj ===
Es un pequeño crucifijo plateado. Es uno de los cuatro elementos que nos servirán para derrotar al vampiro.
    + [Volver] -> current_location
-> DONE

=== ristra_de_ajos_obj ===
Es una ristra entera de ajos que expelen un olor un tanto asqueroso. Es uno de los cuatro elementos que me servirán para derrotar al vampiro.
     + [Volver] -> current_location
-> DONE

=== trozo_de_madera_obj ===
Un trozo de madera, cilíndrico y alargado
{cuchillo:
    + [Afilar] -> crear_estaca
}
    + [Volver] -> current_location
-> DONE

=== palanca_obj ===
Es una palanca de acero toledano. Sirve para forzar cosas.
    + [Volver] -> current_location
-> DONE

=== estaca_obj ===
Un cacho de madera cilíndrico y alargado, uno de sus extremos está afilado cuidadosamente.
+ [Volver] -> current_location
-> DONE

=== martillo_obj ===
Un martillo grande. Es uno de los elementos que me permitirán acabar con el vampiro.
    + [Volver] -> current_location
-> DONE

=== Biblioteca_cucifijo ===
{show_image("crucifijo")}
Es un pequeño crucifijo plateado. Es uno de los cuatro elementos que nos servirán para derrotar al vampiro.
 { crucifijo ==false:
     * [Recoger] 
            {add_to_inventory("crucifijo",true)}
            {snd_fx()}
            ~ crucifijo = true
            -> current_location
    }
    + [Volver] -> current_location
->DONE

=== Escaleras ===
~ current_location = -> Escaleras
~ current_name = "Escaleras"
{hide_image()}
{show_image_bg("escaleras")}
Te hallas en el final del pasillo. Delante de ti ves unas escaleras que suben y otras que bajan. Al oeste está el dormitorio y al este la sala de estar.
 
 + [Subir las escaleras] -> Escaleras_superiores
 + [Bajar las escaleras] -> Sotano
 + [Este] -> Sala_de_estar
 + [Oeste] -> Dormitorio
 + [Sur] -> Pasillo
 
-> DONE

=== Dormitorio ===
~ current_location = -> Dormitorio
~ current_name = "Dormitorio"
{hide_image()}
{show_image_bg("dormitorio")}
Estás en un dormitorio no muy grande ni tampoco muy pequeño. Es bastante austero. Solo hay una cama y un armario.
    
    +[Examinar cama] -> Dormitorio_Cama
    +[Salir del dormitorio] -> Escaleras

-> DONE

=== Dormitorio_Cama ===

Está cubierta de sábanas.
    + [Examinar sábanas] -> Dormitorio_Cama.Sabanas
    + [Volver]->current_location

= Sabanas   
Sábanas corrientes y molientes.
{llave==false:
    Entre ellas encuentras una pequeña llavecita.
    + [Examinar llavecita] ->Dormitorio_Cama.Llavecita
 - else:
    Rebuscas entre las sábanas pero no encuentras nada más.
}
+ [Volver]->current_location

= Llavecita
{show_image("llavecita")}
Esta pequeña llavecita tiene la pinta de abrir un armario o algo así.
{ llave==false:
     * [Recoger] 
            {add_to_inventory("llavecita",true)}
            {snd_fx()}
            ~ llave = true
            -> current_location
    }
+ [Volver]->current_location

-> DONE

=== Sala_de_estar ===
~ current_location = -> Sala_de_estar
~ current_name = "Sala de estar"
{hide_image()}
{show_image_bg("sala_de_estar")}
 { stopping:
    - Es la sala más acogedora de todo el castillo. En la chimenea los últimos restos de algún fuego chisporrotean alegremente. Hay una mesa grande con una silla al lado. De la pared cuelgan bastantes trofeos de caza y adornos varios.
    - Los rescoldos del fuego languidecen por momentos. Hay una mesa grande con una silla al lado. De la pared cuelgan bastantes trofeos de caza y adornos varios.
    - Cada vez te siente menos agusto en esta sala. El silencio y el frio empiezan a pesar. Hay una mesa grande con una silla al lado. De la pared cuelgan bastantes trofeos de caza y adornos varios.
}

    + [Examinar mesa]Una mesa de caoba, bastante grande.-> current_location
    + [Examinar silla]Parece una silla cómoda.-> current_location
    + [Examinar chimenea]-> Sala_de_estar_chimenea
    + [Examinar trofeos de caza]Insignificantes trofeos. -> current_location
    + [Examinar adornos]Adornan. -> current_location
    + [Salir de la sala de estar] -> Escaleras 

-> DONE

=== Sala_de_estar_chimenea ===
Es una chimenea hecha de ladrillos y muy elegante.
{madera == false:
Entre los restos del fuego encuentras un trozo de madera.
+[Examinar trozo de madera] -> Sala_de_estar_chimenea_madera
}
+[Volver] -> current_location
-> DONE

=== Sala_de_estar_chimenea_madera ===
{show_image("trozo de madera")}
Un trozo de madera, cilíndrico y alargado.
{ madera==false:
     * [Recoger]  
            {add_to_inventory("trozo de madera",true)}
            {snd_fx()}
            ~ madera = true
            -> current_location
    }
    + [Volver] -> current_location
->DONE

=== Sotano ===
~ current_location = -> Sotano
~ current_name = "Sótano"
{hide_image()}
{show_image_bg("sotano")}
En este pequeño sótano hace mucho calor, sientes una sensación de recogimiento. Está todo muy sucio. Hay un barril aquí, también hay unas escaleras que suben.

+ [Examinar barril] -> Sotano_barril
+ [Subir las escaleras] -> Escaleras

-> DONE

=== Sotano_barril ===
{martillo:
    Está vacio.
    +[Volver] -> current_location
-else:
{palanca:
    ¡Clack! - Haciendo palanca logras abrir el barril.
    Dentro hay un martillo.
    +[Examinar martillo] -> Sotano_barril_martillo
    +[Volver] -> current_location
    -else :
Intentas abrirlo, pero no tienes la suficiente fuerza.
+ [Volver] -> current_location
}
}
-> DONE

=== Sotano_barril_martillo ===
{show_image("martillo")}
Un martillo grande. Es uno de los elementos que me permitirán acabar con el vampiro.
{ martillo==false:
     * [Recoger]  
            {add_to_inventory("martillo",true)}
            {snd_fx()}
            ~ martillo = true
            -> current_location
    }
    + [Volver] -> current_location 
->DONE

=== Escaleras_superiores ===
~ current_location = -> Escaleras_superiores
~ current_name = "Escaleras superiores"
{hide_image()}
{show_image_bg("escaleras_superiores")}
Estás en el piso superior del castillo. Aquí hace aún más frío que abajo. Detrás de ti están las escaleras que bajan y hacia el oeste está la habitación del vampiro.

    +[Bajar las escaleras] -> Escaleras
    +[Oeste] -> Habitacion_vampiro
-> DONE

=== Habitacion_vampiro ===
~ current_location = -> Habitacion_vampiro
~ current_name = "Habitación del vampiro"
{hide_image()}
{show_image_bg("vampiro_bg")}
Estás en una habitación desnuda. Unicamente hay un altar en el centro. Encima del altar puedes ver un ataúd.
    
    +[Examinar ataúd] -> Habitacion_vampiro_ataud
    +[Salir de la habitación del vampiro] -> Escaleras_superiores
    
-> DONE

=== Habitacion_vampiro_ataud ===
Una sencilla caja de pino.
    +[Abrir] 
    {ajos==true && estaca==true && crucifijo == true && martillo==true:
        -> Habitacion_vampiro_ataud_.abierto
        -else:
        -> Habitacion_vampiro_ataud_.cerrado
    }
    +[Volver] -> current_location 
    
= Habitacion_vampiro_ataud_
    - (abierto)
        Abres el ataúd. Dentro contemplas la horrible cara del vampiro. Protegido por los ajos y el crucifijo empiezas tu horrible tarea. Le clavas la estaca en el pecho y de un terrible golpe de martillo la hundes en lo más profundo de su ser. Con un grito de agonía se deshace en polvo y tú acabas tu misión aquí.
Por ahora...

-> END

    - (cerrado)
        Necesito cuatro cosas antes de poner fin a la 'vida' del vampiro. A saber: un crucifijo, una ristra de ajos, una estaca afilada y un martillo.
         +[Volver] -> current_location 
-> DONE

=== crear_estaca ===
~ estaca = true
{change_inventory_state("trozo de madera","estaca")}
Afilas la madera con el cuchillo ¡y obtienes una estaca!
* [Volver] -> current_location
-> DONE

=== examinar_estaca ===
Un cacho de madera rectangular y alargado, uno de sus extremos está afilado cuidadosamente.
+ [Volver] -> current_location
-> DONE
    