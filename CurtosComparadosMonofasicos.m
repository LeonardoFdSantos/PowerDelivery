%% Estudos de Proteção
clear;
clc;

run("CarregaDados.m");
load("trifasico2awg.mat");

Fim_Linha_T2F(1, :) = string({'tipoCurto' 'Ia_Trif' 'Ib_Trif' 'Ic_Trif' 'Vab_Trif' 'Vbc_Trif' 'Vca_Trif' 'Ia_T2F' 'Ib_T2F' 'Ic_T2F' 'Vab_T2F' 'Vbc_T2F' 'Vca_T2F'});
Meio_Linha_T2F(1, :) = string({'n' 'tipoCurto'  'Ia_Trif' 'Ib_Trif' 'Ic_Trif' 'Vab_Trif' 'Vbc_Trif' 'Vca_Trif' 'Ia_T2F' 'Ib_T2F' 'Ic_T2F' 'Vab_T2F' 'Vbc_T2F' 'Vca_T2F'});

Fim_Linha_Trif(1, :) = string({'tipoCurto' 'Ia_Trif' 'Ib_Trif' 'Ic_Trif' 'Vab_Trif' 'Vbc_Trif' 'Vca_Trif'});
Meio_Linha_Trif(1, :) = string({'n' 'tipoCurto' 'Ia_Trif' 'Ib_Trif' 'Ic_Trif' 'Vab_Trif' 'Vbc_Trif' 'Vca_Trif'});

Fim_Linha_Isolador_Trif(1, :) = string({'tipoCurto' 'Ia_Trif_Ent' 'Ib_Trif_Ent' 'Ic_Trif_Ent' 'Vab_Trif_Ent' 'Vbc_Trif_Ent' 'Vca_Trif_Ent' 'Ia_Trif_Saida' 'Ib_Trif_Saida' 'Ic_Trif_Saida' 'Vab_Trif_Saida' 'Vbc_Trif_Saida' 'Vca_Trif_Saida'});
Meio_Linha_Isolador_Trif(1, :) = string({'n' 'tipoCurto' 'Ia_Trif_Ent' 'Ib_Trif_Ent' 'Ic_Trif_Ent' 'Vab_Trif_Ent' 'Vbc_Trif_Ent' 'Vca_Trif_Ent' 'Ia_Trif_Saida' 'Ib_Trif_Saida' 'Ic_Trif_Saida' 'Vab_Trif_Saida' 'Vbc_Trif_Saida' 'Vca_Trif_Saida'});

Parametros_testes = [1e-4 .1 .25 .5 .75 .99];
SimulacaoTempo = 0.1;
ValoresCurtos = [1e-5 40 100 200 300 400 500 600 700 800 900 1000];

for ValorCurto = ValoresCurtos

    for b = [1:1:1]
        if b == 1
            Raf = 1e-5;
            Rbf = 1e6;
            Rcf = ValorCurto;
            TrifTestA = 1e-5;
            TrifTestB = 1e6;
            TrifTestC = 1e6;
            TrifTerra = ValorCurto;
            tipoCurto = 1;
        elseif b == 2
            Raf = 1e6;
            Rbf = 1e-5;
            Rcf = ValorCurto;
            TrifTestA = 1e6;
            TrifTestB = 1e-5;
            TrifTestC = 1e6;
            TrifTerra = ValorCurto;
            tipoCurto = 2;
        end
    
        sim('.\SimCurtoCircuitoSemCompensacao.slx');
        CorrenteEntradaT2F = abs(CorrenteEntradaT2F)/sqrt(2);
        TensaoEntradaT2F = abs(TensaoEntradaT2F)/sqrt(3);
        CorrenteSaidaT2F = abs(CorrenteSaidaT2F)/sqrt(2);
        TensaoSaidaT2F = abs(TensaoSaidaT2F)/sqrt(3);
    
        sim('.\SimTrifasicoFimLinhaMonofasico.slx');
        CorrenteTrif = abs(CorrenteTrifasico)/sqrt(3);
        TensaoTrif = abs(TensaoTrifasico)/sqrt(3);

        sim('.\SimTrifasicoFimLinhaComIsoladorMonofasico.slx');
        Corrente_Trif_Entrada = abs(CorrenteEntrada)/sqrt(3);
        Tensao_Trif_Entrada = abs(TensaoEntrada)/sqrt(3);
        Corrente_Trif_Saida = abs(CorrenteSaida)/sqrt(3);
        Tensao_Trif_Saida =abs(TensaoSaida)/sqrt(3);
        
        Fim_Linha_T2F(b+1, :) = [tipoCurto CorrenteEntradaT2F TensaoEntradaT2F CorrenteSaidaT2F TensaoSaidaT2F];
        Fim_Linha_Trif(b+1, :) = [tipoCurto CorrenteTrif TensaoTrif];
        Fim_Linha_Isolador_Trif(b+1, :) = [tipoCurto Corrente_Trif_Entrada Tensao_Trif_Entrada Corrente_Trif_Saida Tensao_Trif_Saida];    
    end
    
    fprintf('Terminado fim de Linha! De Valor %d\n', ValorCurto);
    
    b = 0;
    c = 1;
    e = 1;
    
    for n = Parametros_testes
        m1 = n;
        for b = [1:1:1]
            if b == 1
                Raf = 1e-5;
                Rbf = 1e6;
                Rcf = ValorCurto;
                TrifTestA = 1e-5;
                TrifTestB = 1e6;
                TrifTestC = 1e6;
                TrifTerra = ValorCurto;
                tipoCurto = 1;
            elseif b == 2
                Raf = 1e6;
                Rbf = 1e-5;
                Rcf = ValorCurto;
                TrifTestA = 1e6;
                TrifTestB = 1e-5;
                TrifTestC = 1e6;
                TrifTerra = ValorCurto;
                tipoCurto = 2;
            end
    
            sim('.\SimCurtoCircuitoMeioLinhaSemCompensacao.slx');
            CorrenteEntradaT2F = abs(CorrenteEntradaT2F)/sqrt(2);
            TensaoEntradaT2F = abs(TensaoEntradaT2F)/sqrt(3);
            CorrenteSaidaT2F = abs(CorrenteSaidaT2F)/sqrt(2);
            TensaoSaidaT2F = abs(TensaoSaidaT2F)/sqrt(3);
            
            sim('.\SimTrifasicoMeioLinhaMonofasico.slx');
            CorrenteTrif = abs(CorrenteTrifasico)/sqrt(3);
            TensaoTrif = abs(TensaoTrifasico)/sqrt(3);

            sim('.\SimTrifasicoMeioLinhaComIsoladorMonofasico.slx');
            Corrente_Trif_Entrada = abs(CorrenteEntrada)/sqrt(3);
            Tensao_Trif_Entrada = abs(TensaoEntrada)/sqrt(3);
            Corrente_Trif_Saida = abs(CorrenteSaida)/sqrt(3);
            Tensao_Trif_Saida = abs(TensaoSaida)/sqrt(3);
            
            Meio_Linha_T2F(c+1, :) = [m1 tipoCurto CorrenteEntradaT2F TensaoEntradaT2F CorrenteSaidaT2F TensaoSaidaT2F];
            Meio_Linha_Trif(c+1, :) = [m1 tipoCurto CorrenteTrif TensaoTrif];
            Meio_Linha_Isolador_Trif(c+1, :) = [m1 tipoCurto Corrente_Trif_Entrada Tensao_Trif_Entrada Corrente_Trif_Saida Tensao_Trif_Saida];
            c = c + 1;
        end
    end
    
    fprintf('Terminado meio de Linha! De Valor %d\n', ValorCurto);
    
    Local = '.\DataNovo\';
    if ValorCurto <= 1
        ValorCurtoNome = 'Franco';
    else
        ValorCurtoNome = string(ValorCurto);
    end

    Fim_T2F = 'Dissertacao_T2F_%s_fimLinha.csv';
    Fim_Trif_Isolador = 'Dissertacao_Trif_Isolador_%s_fimLinha.csv';
    Fim_Trif = 'Dissertacao_Trif_%s_fimLinha.csv';
    Meio_T2f = 'Dissertacao_T2F_%s_meioLinha.csv';
    Meio_Trif_Isolador = 'Dissertacao_Trif_Isolador_%s_meioLinha.csv';
    Meio_Trif = 'Dissertacao_Trif_%s_meioLinha.csv';
    
    NomeFim_T2F = sprintf(Fim_T2F, ValorCurtoNome);
    NomeFim_Trif_Isolador = sprintf(Fim_Trif_Isolador, ValorCurtoNome);
    NomeFim_Trif = sprintf(Fim_Trif, ValorCurtoNome);
    NomeMeio_T2F = sprintf(Meio_T2f, ValorCurtoNome);
    NomeMeio_Trif_Isolador = sprintf(Meio_Trif_Isolador, ValorCurtoNome);
    NomeMeio_Trif = sprintf(Meio_Trif, ValorCurtoNome);
    
    writematrix(Fim_Linha_T2F, strcat(Local, NomeFim_T2F));
    writematrix(Fim_Linha_Isolador_Trif, strcat(Local, NomeFim_Trif_Isolador));
    writematrix(Fim_Linha_Trif, strcat(Local, NomeFim_Trif));
    writematrix(Meio_Linha_T2F, strcat(Local, NomeMeio_T2F));
    writematrix(Meio_Linha_Isolador_Trif, strcat(Local, NomeMeio_Trif_Isolador));
    writematrix(Meio_Linha_Trif, strcat(Local, NomeMeio_Trif));
end

fprintf('Terminado ensaios! \n');