function [] = Main_13_02_2023()
%% Main Function
clc;
clear all;
close all;
warning off
% load Result;
global S alg n Security Source Dest Packet_loss Trust num_of_sink

analysis = 0; % set 1 to 0 for the reoptimization of clusterheads
if analysis == 1
    %% Initalization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Field Dimensions - x and y maximum (in meters)
    xm=100;
    ym=100;
    x = 50;
    y = 50;
    radius = 25;  
    
%     Number_of_sink_nodes = [3, 4, 5, 8];
    Number_of_sink_nodes = [50, 100, 150, 200];
    
    % x and y Coordinates of the Sink
    for net = 1:length(Number_of_sink_nodes)
        num_of_sink = Number_of_sink_nodes(net);
        varie = 180 / (360 / num_of_sink);
        
        Theta = 0:pi / varie:2 * pi;
        xunit = radius * cos(Theta) + x;
        yunit = radius * sin(Theta) + y;
        
        sink.x = xunit;
        sink.y = yunit;
        
        %Number of Nodes in the field
        n=50;
        
        %Optimal Election Probability of a node
        %to become cluster head
        p=0.1;
        
        
        Packet_loss = randi([0, 5], 1, n);
        
        %Energy Model (all values in Joules)
        %Initial Energy
        Eo=0.5;
        %Eelec=Etx=Erx
        ETX=50*0.000000001;
        ERX=50*0.000000001;
        %Transmit Amplifier types
        Efs=10*0.000000000001;
        Emp=0.0013*0.000000000001;
        %Data Aggregation Energy
        EDA=5*0.000000001;
        
        %Values for Hetereogeneity
        %Percentage of nodes than are advanced
        m=0.1;
        %alpha
        a=1;
        
        %maximum number of rounds
        rmax = 2000;
        
        %Optimization paramateres
        no_sol=10;
        dim_sol=10;
        iteration_count=10;
        
        %% Creation of the random Sensor Network
        figure(1);
        for i=1:1:n
            S_in(i).xd=rand(1,1)*xm;
            XR(i)=S_in(i).xd;
            S_in(i).yd=rand(1,1)*ym;
            YR(i)=S_in(i).yd;
            S_in(i).G=0;
            %initially there are no cluster heads only nodes
            S_in(i).type='N';
            
            temp_rnd0=i;
            %Random Election of Normal Nodes
            if (temp_rnd0>=m*n+1)
                S_in(i).E=Eo;
                S_in(i).ENERGY=0;
                plot(S_in(i).xd,S_in(i).yd,'o', 'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
                axis off
                hold on;
            end
            %Random Election of Advanced Nodes
            if (temp_rnd0<m*n+1)
                S_in(i).E=Eo*(1+a);
                S_in(i).ENERGY=1;
                plot(S_in(i).xd,S_in(i).yd,'h', 'MarkerSize',10,'MarkerEdgeColor','g','MarkerFaceColor','g');
                axis off
                hold on;
                
            end
        end
        
        for sink_iter = 1:num_of_sink
            S_in(n + sink_iter).xd=sink.x(sink_iter);
            S_in(n + sink_iter).yd=sink.y(sink_iter);
            plot(S_in(n + sink_iter).xd,S_in(n + sink_iter).yd,'d', 'MarkerSize',10,'MarkerEdgeColor','m','MarkerFaceColor','m');
        end
        axis off
        
        Trust = randi([1 100], 1, n);
        Security = randi([1 100], 1, n);
        
        save XR XR
        save YR YR
        
        %% Analysis
        %Calling algorithms
        met = {'Jaya','SFO','COA', 'GTO', 'Proposed'};
        for i = 1:length(met)
            alg = met{i};
            MainNodes = randperm(n, 2);
            Source = MainNodes(1);
            Dest = MainNodes(2);
            [y_An, norm_Energy, CLUSTERHS, CH, GM, F, ct, bs, out]=LEACH_alg(n, p, ETX, ERX, Efs, Emp, EDA,...
                rmax, no_sol, dim_sol, iteration_count, S_in, 'objfun_Cluster');
            Result(net,i).y_An = y_An;
            Result(net,i).norm_Energy = norm_Energy;
            Result(net,i).CLUSTERHS = CLUSTERHS;
            Result(net,i).CH = CH;
            Result(net,i).GM = GM;
            Result(net,i).F = F;
            Result(net,i).tm = ct;
            Result(net,i).sol = bs;
            Result(net,i).S = S;
            Result(net,i).out = out;
            save Result Result
        end
    end
end
% PLOT_RESULTS()
end