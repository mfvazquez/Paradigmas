function [log, exit] = BloqueEmociones(datos, corrida, hd, log)

    exit = false;

    %% CONSTANTES

    KbName('UnifyKeyNames');
    ExitKey = KbName('ESCAPE');
    AfirmativeKey = KbName('LeftArrow');
    NegativeKey = KbName('RightArrow');

    teclas.exit = ExitKey;
    teclas.afirmativo = AfirmativeKey;
    teclas.negativo = NegativeKey;
    
    %% CORRO EL PARADIGMA
    [log, exit] = CorrerSecuenciaPriming(datos.bloques{corrida}, datos.instrucciones, hd, teclas, log);

end