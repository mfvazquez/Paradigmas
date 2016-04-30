function OnSetTime = PresentarSituacion(texto, textura, mensaje)

    global window;
    global pportobj;
    global pportaddr;
   
    DibujarSituacion(texto, textura, mensaje);
    OnSetTime = blink();
    
    EsperarBoton(pportobj,pportaddr);
    
end