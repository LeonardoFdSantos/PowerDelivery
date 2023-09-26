%% Estudos de Proteção
clear;
clc;
% run("CarregaDados.m");
Meio_Linha_T2F(1, :) = string({'n' 'tipoCurto'  'Ia_Trif_T2F' 'Ib_Trif_T2F' 'Ic_Trif_T2F' 'Vab_Trif_T2F' 'Vbc_Trif_T2F' 'Vca_Trif_T2F' 'Ia_T2F' 'Ib_T2F' 'Ic_T2F' 'Vab_T2F' 'Vbc_T2F' 'Vca_T2F'});
Meio_Linha_Isolador_Trif(1, :) = string({'n' 'tipoCurto' 'Ia_Trif_Ent' 'Ib_Trif_Ent' 'Ic_Trif_Ent' 'Vab_Trif_Ent' 'Vbc_Trif_Ent' 'Vca_Trif_Ent' 'Ia_Trif_Saida' 'Ib_Trif_Saida' 'Ic_Trif_Saida' 'Vab_Trif_Saida' 'Vbc_Trif_Saida' 'Vca_Trif_Saida'});
Meio_Linha_Isolador_MRT(1, :) = string({'n' 'tipoCurto' 'Ia_Entrada' 'Va_Entrada' 'Ia_Saida' 'Va_Saida'});
Parametros_testes = [0.01:0.01:0.99];
SimulacaoTempo = 0.1;
ValoresCurtos = [1e-5 40 100];
distancias = [60 120 180 240];

for dd = distancias
    %run("CarregaDados20km.m");
    run("CarregaDados.m");
    load("trifasico2awg.mat");
    for ValorCurto = ValoresCurtos  
        c = 1;
        e = 1;
        for n = Parametros_testes
            m1 = n;
            % Casos
            Raf = 1e-5;
            Rbf = 1e-5;
            Rcf = ValorCurto;
            Rmrt = ValorCurto;
            caso = "1";

%             Raf = ValorCurto;
%             Rbf = ValorCurto;
%             Rcf = 1e-5;
%             Rmrt = ValorCurto;
%             caso = "2";

%             Raf = ValorCurto/2;
%             Rbf = ValorCurto/2;
%             Rcf = 1e6;
%             Rmrt = ValorCurto;
%             caso = "3";

%             Raf = 1e-5;
%             Rbf = 1e6;
%             Rcf = ValorCurto;
%             Rmrt = ValorCurto;
%             caso = "4";

%             Raf = 1e6;
%             Rbf = 1e-5;
%             Rcf = ValorCurto;
%             Rmrt = ValorCurto;
%             caso = "5";

            sim('.\SimCurtoCircuitoMeioLinhaSemCompensacao.slx');
            CorrenteEntradaT2F = abs(CorrenteEntradaT2F)/sqrt(2);
            TensaoEntradaT2F = abs(TensaoEntradaT2F)/sqrt(2);
            CorrenteSaidaT2F = abs(CorrenteSaidaT2F)/sqrt(2);
            TensaoSaidaT2F = abs(TensaoSaidaT2F)/sqrt(2);

            sim('.\SimMonofasicoMeioLinhaComIsolador.slx');
            CorrenteIsoladorMRT = abs(CorrenteEntrada)/sqrt(2);
            TensaoIsoladorMRT = abs(TensaoEntrada)/sqrt(2);
            CorrenteSaidaMRT = abs(CorrenteSaida)/sqrt(2);
            TensaoSaidaMRT = abs(TensaoSaida)/sqrt(2);

            sim('.\SimTrifasicoMeioLinhaComIsolador.slx');
            Corrente_Trif_Entrada = abs(CorrenteEntrada)/sqrt(2);
            Tensao_Trif_Entrada = abs(TensaoEntrada)/sqrt(2);
            Corrente_Trif_Saida = abs(CorrenteSaida)/sqrt(2);
            Tensao_Trif_Saida =abs(TensaoSaida)/sqrt(2);

            Meio_Linha_T2F(c+1, :) = [m1 caso CorrenteEntradaT2F TensaoEntradaT2F CorrenteSaidaT2F TensaoSaidaT2F];
            Meio_Linha_Isolador_Trif(c+1, :) = [m1 caso Corrente_Trif_Entrada Tensao_Trif_Entrada Corrente_Trif_Saida Tensao_Trif_Saida];
            Meio_Linha_Isolador_MRT(c+1, :) = [m1 caso CorrenteIsoladorMRT TensaoIsoladorMRT CorrenteSaidaMRT TensaoSaidaMRT];
            c = c + 1;
        end
        Local = '.\Data2\';
        if ValorCurto <= 1
            ValorCurtoNome = 'Franco';
        else
            ValorCurtoNome = string(ValorCurto);
        end
        ValorDistancia = string(dd);

        Meio_T2f = 'PowerDelivery_T2F_Distancia_%s_Valor_%s_meioLinha_Caso_%s.csv';
        Meio_Trif_Isolador = 'PowerDelivery_Trif_Isolador_Distancia_%s_Valor_%s_meioLinha_Caso_%s.csv';
        Meio_MRT = 'PowerDelivery_MRT_Distancia_%s_Valor_%s_meioLinha_Caso_%s.csv';

        NomeMeio_T2F = sprintf(Meio_T2f, ValorDistancia,ValorCurtoNome, caso);
        NomeMeio_Trif_Isolador = sprintf(Meio_Trif_Isolador, ValorDistancia,ValorCurtoNome, caso);
        NomeMeio_MRT = sprintf(Meio_MRT, ValorDistancia,ValorCurtoNome, caso);

        writematrix(Meio_Linha_T2F, strcat(Local, NomeMeio_T2F));
        writematrix(Meio_Linha_Isolador_Trif, strcat(Local, NomeMeio_Trif_Isolador));
        writematrix(Meio_Linha_Isolador_MRT, strcat(Local, NomeMeio_MRT));

        fprintf('Terminado meio de Linha! De Valor Distancia de %d km e Curto-circuito %s \n', dd,  ValorCurtoNome);
    end
end
fprintf('Terminado ensaios! \n');