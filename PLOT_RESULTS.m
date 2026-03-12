function[] = PLOT_RESULTS()
clc;
clear all;
close all;

load Fit;
load Fit_2;

ConvergenceTable();
Plot_Cluster_results();

%% Convergence Graph
Nodes = [50, 100,150, 200];
an = 1;
if an == 1
    for n = 1 : 4 % For all Node variations
%         for j = 1 : 5 % For all algorithms
%             val(j,:) = statistical_Analysis(Fit{n, j});
%             val_2(j,:) = statistical_Analysis(Fit_2{n, j});
%         end
%         disp('Statistical Analysis :')
%         fprintf('Nodes : %d\n ',Nodes(n));
%         ln = {'BEST','WORST','MEAN','MEDIAN','STANDARD DEVIATION'};
%         T = table(val(1, :)', val(2, :)', val(3, :)',val(4, :)', val(5, :)','Rownames',ln);
%         T.Properties.VariableNames = {'Jaya','SFO','COA', 'GTO', 'Proposed'};
%         disp(T)
        
%         disp('Computation Time :')
%         fprintf('Nodes : %d\n ',Nodes(n));
%         ln = {'Time'};
%         T = table(Time(n,1), Time(n,2), Time(n,3), Time(n,4), Time(n,5),'Rownames',ln);
%         T.Properties.VariableNames = {'Jaya','SFO','COA', 'GTO', 'Proposed'};
%         disp(T)
        
        figure,
        plot(Fit{n, 1},'r', 'LineWidth', 2)
        hold on;
        plot(Fit{n, 2},'g', 'LineWidth', 2)
        plot(Fit{n, 3},'b', 'LineWidth', 2)
        plot(Fit{n, 4},'m', 'LineWidth', 2)
        plot(Fit{n, 5},'k', 'LineWidth', 2)
        set(gca,'fontsize',20);
        xlabel('Max Iterations','fontsize',16);
        ylabel('Cost Function','fontsize',16);
        h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
        set(h,'fontsize',12,'Location','Best')
        print('-dtiff','-r300',['.\Results\', 'Cluster-Convergence-',num2str(n)])
        
        figure,
        plot(Fit_2{n, 1},'r', 'LineWidth', 2)
        hold on;
        plot(Fit_2{n, 2},'g', 'LineWidth', 2)
        plot(Fit_2{n, 3},'b', 'LineWidth', 2)
        plot(Fit_2{n, 4},'m', 'LineWidth', 2)
        plot(Fit_2{n, 5},'k', 'LineWidth', 2)
        set(gca,'fontsize',20);
        xlabel('Max Iterations','fontsize',16);
        ylabel('Cost Function','fontsize',16);
        h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
        set(h,'fontsize',12,'Location','Best')
        print('-dtiff','-r300',['.\Results\', 'Routing-Convergence-',num2str(n)])
    end
end

an = 1;
if an == 1
    load FinRes;
    
    %% Energy consumption
    X = (50:50:200);
    figure,
    bar(X, FinRes.En_consumption')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Energy consumption', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Energy consumption'])
    
    
    %% Inter cluster distance
    X = 50:50:200;
    figure,
    bar(X, FinRes.Inter_cluster_distance')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Inter cluster distance', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Inter cluster distance'])
    
    %% Intra cluster distance
    X = 50:50:200;
    figure,
    bar(X, FinRes.Intra_cluster_distance')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Intra cluster distance', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Intra cluster distance'])
    
    %% Density
    X = 50:50:200;
    figure,
    bar(X, FinRes.Density')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Density', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Density'])
    
    %% Latency
    X = 50:50:200;
    figure,
    bar(X, FinRes.Delay')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Latency', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Latency'])
    
    %% Throughput
    X = 50:50:200;
    figure,
    bar(X, FinRes.Throughput')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Throughput', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Throughput'])
    
    %% Path Scalability
    X = 50:50:200;
    figure,
    bar(X, FinRes.Path_Scalability')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Path Scalability', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Path Scalability'])
    
    %% Path Reliability
    X = 50:50:200;
    figure,
    bar(X, FinRes.Path_Reliability')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Path Reliability', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Path Reliability'])
    
    %% Packet delivery ratio
    X = 50:50:200;
    figure,
    bar(X, FinRes.Packetdeliveryratio')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Packet delivery ratio', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Packet delivery ratio'])
    
    %% Path Loss
    X = 50:50:200;
    figure,
    bar(X, FinRes.Path_Loss')
    set(gca, 'FontSize', 14);
    xlabel('Number Of Nodes', 'FontSize', 14);
    ylabel('Path Loss', 'FontSize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['.\Results\', 'Path Loss'])
    
end
end

function [] = Plot_Cluster_results()
load Results_c;
Stats = {'BEST', 'WORST', 'MEAN', 'MEDIAN', 'STD'};
Terms = {'Energy consuption' 'Intra Cluster Distance' 'Inter Cluster Distance' 'Density'};
% Terms = {'Euclidian Distance' 'Mean Energy' 'Intra Cluster Distance' 'Inter Cluster Distance' 'Delay' 'Throughput'};
% Terms = {'Euclidian Distance' 'Mean Energy' 'Residual Energy' 'Intra Cluster Distance' 'Inter Cluster Distance' 'Delay' 'Throughput'};
num_of_nodes = [50, 100, 150 200];

for n = 1:size(Results_c, 1)
    for i = 1:size(Results_c, 2)
        Alivenodes(i, :) = Results_c(n, i).y_An;
    end
    
    [a, b] = max(Alivenodes(:, end));
    x = Alivenodes(b, :);
    y = Alivenodes(end, :);
    Alivenodes(end, :) = x;
    Alivenodes(b, :) = y;
    
    for i = 1:size(Alivenodes, 1)
        for j = 1:size(Alivenodes, 2) - 1
            Alivenode(i, j) = abs(Alivenodes(i, j) - Alivenodes(i, j + 1));
        end
        Alive_Stats(i, 1) = min(Alivenode(i, :));
        Alive_Stats(i, 2) = max(Alivenode(i, :));
        Alive_Stats(i, 3) = mean(Alivenode(i, :));
        Alive_Stats(i, 4) = median(Alivenode(i, :));
        Alive_Stats(i, 5) = std(Alivenode(i, :));
    end
%     disp(strcat("-------------------- Number of node - ", num2str(num_of_nodes(n)), " - Dead node Statistical Report --------------------"))
%     T = table(char(Stats), Alive_Stats(1, :)', Alive_Stats(2, :)', Alive_Stats(3, :)', Alive_Stats(4, :)', Alive_Stats(5, :)');
%     T.Properties.VariableNames = {'Statistics', 'DHOA','Jaya','CMBO', 'DSO', 'Proposed'};
%     disp(T)
    
    figure,
    plot(Alivenodes(1, :), 'r', 'LineWidth', 2)
    hold on;
    plot(Alivenodes(2, :), 'g', 'LineWidth', 2)
    plot(Alivenodes(3, :), 'b', 'LineWidth', 2)
    plot(Alivenodes(4, :), 'm', 'LineWidth', 2)
    plot(Alivenodes(5, :), 'k', 'LineWidth', 2)
    set(gca, 'fontsize', 14);
    xlim([0 2000])
    ylim([0 n * 50])
    grid on;
    xlabel('Number of rounds', 'fontsize', 14);
    ylabel('Number of nodes alive', 'fontsize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'Best')
    print('-dtiff', '-r300', ['.\Results\', 'alive nodes-', num2str(n)])
    
    for i = 1:size(Results_c, 2)
        Normalized_Energy(i, :) = Results_c(n, i).norm_Energy;
    end
    
    [a, b] = max(Normalized_Energy(:, end));
    x = Normalized_Energy(b, :);
    y = Normalized_Energy(end, :);
    Normalized_Energy(end, :) = x;
    Normalized_Energy(b, :) = y;
    
    for i = 1:size(Normalized_Energy, 1)
        for j = 1:size(Normalized_Energy, 2) - 1
            norm_energy(i, j) = abs(Normalized_Energy(i, j) - Normalized_Energy(i, j + 1));
        end
        Norm_Stats(i, 1) = min(norm_energy(i, :));
        Norm_Stats(i, 2) = max(norm_energy(i, :));
        Norm_Stats(i, 3) = mean(norm_energy(i, :));
        Norm_Stats(i, 4) = median(norm_energy(i, :));
        Norm_Stats(i, 5) = std(norm_energy(i, :));
    end
%     disp(strcat("-------------------- Number of node - ", num2str(num_of_nodes(n)), " - Normalized Energy Statistical Report --------------------"))
%     T = table(char(Stats), Norm_Stats(1, :)', Norm_Stats(2, :)', Norm_Stats(3, :)', Norm_Stats(4, :)', Norm_Stats(5, :)');
%     T.Properties.VariableNames = {'Statistics', 'DHOA','Jaya','CMBO', 'DSO', 'Proposed'};
%     disp(T)
    
    figure,
    plot(Normalized_Energy(1, :), 'r', 'LineWidth', 2)
    hold on;
    plot(Normalized_Energy(2, :), 'g', 'LineWidth', 2)
    plot(Normalized_Energy(3, :), 'b', 'LineWidth', 2)
    plot(Normalized_Energy(4, :), 'm', 'LineWidth', 2)
    plot(Normalized_Energy(5, :), 'k', 'LineWidth', 2)
    set(gca, 'fontsize', 14);
    xlim([0 2000])
    grid on;
    xlabel('Number of rounds', 'fontsize', 14);
    ylabel('Normalized Energy', 'fontsize', 14);
    h = legend('JA','SFO','COA', 'GTO', 'M-GTO');
    set(h, 'fontsize', 12, 'Location', 'Best')
    print('-dtiff', '-r300', ['.\Results\', 'norm-energy-', num2str(n)])
end
end

%% ConvergenceTable
function[] = ConvergenceTable()
load Fit;
load Fit_2;
Nodes = [50, 100,150, 200];
for n = 4 : 4 % For all Node variations
        for j = 1 : 5 % For all algorithms
            val(j,:) = statistical_Analysis(Fit{n, j});
            val_2(j,:) = statistical_Analysis(Fit_2{n, j});
        end
        
        disp('Statistical Analysis for Cluster head selection :')
%         fprintf('Nodes : %d\n ',Nodes(n));
        ln = {'BEST','WORST','MEAN','MEDIAN','STANDARD DEVIATION'};
        T = table(val(1, :)', val(2, :)', val(3, :)',val(4, :)', val(5, :)','Rownames',ln);
        T.Properties.VariableNames = {'JA','SFO','COA', 'GTO', 'M-GTO'};
        disp(T)
        
        disp('Statistical Analysis for Routing :')
%         fprintf('Nodes : %d\n ',Nodes(n));
        ln = {'BEST','WORST','MEAN','MEDIAN','STANDARD DEVIATION'};
        T = table(val_2(1, :)', val_2(2, :)', val_2(3, :)',val_2(4, :)', val_2(5, :)','Rownames',ln);
        T.Properties.VariableNames = {'JA','SFO','COA', 'GTO', 'M-GTO'};
        disp(T)

end
end

function[a] = statistical_Analysis(val)
a(1) = min(val);
a(2) = max(val);
a(3) = mean(val);
a(4) = median(val);
a(5) = std(val);
end
