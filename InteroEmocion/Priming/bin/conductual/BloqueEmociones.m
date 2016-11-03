function [log, exit] = BloqueEmociones(bloque, hd)

    exit = false;

    %% CONSTANTES

    KbName('UnifyKeyNames');
    ExitKey = KbName('ESCAPE');
    AfirmativeKey = KbName('LeftArrow');
    NegativeKey = KbName('RightArrow');

    teclas.exit = ExitKey;
    teclas.afirmativo = AfirmativeKey;
    teclas.negativo = NegativeKey;

    %% PREPARO LOG
    log = cell(length(bloque),1);

    %% CORRO EL PARADIGMA
    [log, exit] = CorrerSecuenciaPriming(bloque, hd, teclas, log);

end