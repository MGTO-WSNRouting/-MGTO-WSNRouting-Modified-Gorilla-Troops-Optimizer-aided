function [ObjVal,cluster_center, out]=objfun_Routing(soln)
global S n Source Dest Packet_loss  
for col=1:size(soln, 1)
     CH=round(soln(col, :));
    CH = check_obj(n,CH);
    CH = bound_check(CH,1,n);
    Path = unique(CH);
    short_path = [Source, Path, Dest];  % the path with source and dest
    xx=S;
    y2=struct2cell(xx);
    xd=reshape(y2(1,1,:), [size(y2, 3), 1]);
    yd=reshape(y2(2,1,:), [size(y2, 3), 1]);
    G=reshape(y2(3,1,:), [size(y2, 3), 1]);
    type=reshape(y2(4,1,:), [size(y2, 3), 1]);
    E=reshape(y2(5,1,:), [size(y2, 3), 1]);
    Energy=reshape(y2(6,1,:), [size(y2, 3), 1]);
    cl=reshape(y2(7,1,:), [size(y2, 3), 1]);
    
    distance_Ch_node=zeros(size(y2, 3)-1, size(CH, 2));
    
    loca_data=[cell2mat(xd) cell2mat(yd)];
    cluster_center=loca_data(CH, :);
    
    %% Distance Constraints
    %Finding distance matrix of inter Cluster 
    for i=1:size(loca_data, 1)-1
        for j=1:size(CH, 2)
            
            distance_Ch_node(i,j)=dist(cluster_center(j,:), loca_data(i, :)');
            
        end
    end
    
    for j=1:size(CH, 2)
        distance_CH_base(j, 1)=dist(cluster_center(j,:), loca_data(end, :)');
        
    end
    a = cluster_center(:,1);
    b = cluster_center(:,2);
    for l = 1:size(a,1)
        for m = 1:size(b,1)
            distn(m) = dist(a(l),b(m));
        end
        Idist(l) = sum(distn);
    end
    Idist = sum(Idist)/10;
    
    %Finding distance matrix of intra Cluster 
    
    [min_value, index_val]=min(distance_Ch_node, [], 2);
    count=zeros(size(CH, 2), 1);
    
    for i=1:size(loca_data, 1)-1
        
        for j=1:size(CH, 2)
            
            if(j==index_val(i))
                f_dist_b= distance_CH_base(j, 1)+distance_Ch_node(i,j);
                count(j,1)=count(j,1)+1;
                
            end
        end
    end
    
    
    f_dist=1/f_dist_b;
    %Finding mean of Energy
    
    E_mat=cell2mat(E);
    CH_E=E_mat(CH, :);
    [E_CH_min_value, E_CH_index_val]=min(CH_E, [], 1);
    
    [E_node_min_value, E_node_index_val]=min(E_mat, [], 1);
    phi=20.72;
    
    tou_value=-phi*(E_CH_min_value/(abs(E_node_min_value-E_CH_min_value)+1e-10));
    f_energy_b=1-exp(tou_value);
    
    m_energy=mean(abs(f_energy_b/exp(sum(count))));
    
    
    %Finding Residual-energy
    
    E_mat=cell2mat(E);
    CH_E=E_mat(CH, :);
    [E_CH_min_value, E_CH_index_val]=min(CH_E, [], 1);
    
    [E_node_min_value, E_node_index_val]=min(E_mat, [], 1);
    phi=20.72;
    
    tou_value=-phi*(E_CH_min_value/(abs(E_node_min_value-E_CH_min_value)+1e-10));
    f_energy_b=1-exp(tou_value);
    
    f_energy=abs(f_energy_b/exp(sum(count)));
    
    % Packet loss Ratio
    PKT_Loss_Ratio = sum(Packet_loss(short_path)) / Total_Packets;
    packet_delivery_ratio = PKT_Loss_Ratio - 1
    
    % Path Loss
    path_loss = A * log10(Distance) + B * log10(f) + Ndf;
    Path_loss = abs(path_loss);
    
    % Delay
    Delay = 1/sum(Packet_loss(short_path));
    
    % Latency
    latency = Delay
    
    % Throughput
    Throughput = 1/ sum(Packet_loss * 100);
    
    % Intra Cluster
    IN_Cluster = Idist;
    
    % Packet_Delivery_Ratio
%     packet_delivery_ratio = (Total_Packets - PKT_Loss_Ratio) / Total_Packets;
    
    %Applying normalization before unification
    alpha = 0.25
    beta = 0.25
    gamma = 0.25
    delta = 0.25
    
%     f_ICWA = alpha * (1/f_dist) + (1-alpha) * f_energy; 
%     F1 = beta * f_ICWA + (1-beta) * (1/f_dist);   % Euclidian Distance
%     F2 = gamma * F1 + (1-gamma) * (1/ m_energy);   % Mean Energy
%     F3 = delta * F2 + (1-delta) * (1/ f_energy); % Residual Energy
%     F4 = omega * F3 + (1-omega) * (1/Idist);     % intra Cluster Distance
%     F5 = epsilon * F4 + (1-epsilon) * (1/IN_Cluster);     % inter Cluster Distance  
%     F6 = Zeta * F5 + (1-Zeta) * (Delay);  % Delay
%     F7 = Eta * F6 + (1-Eta) * (1/ Throughput);  % Throughput
    
    F3 = alpha * latency + (1 - alpha) * Throughput
    F4 = beta * F3 + (1 - beta) * path_scalability_reliability
    F5 = gamma * F4 + (1 - gamma) * packet_delivery_ratio
    Fitness = delta * F5 + (1 - delta) * Path_loss
        
    ObjVal(col) = 1/Fitness;
    out = [Throughput path_scalability_reliability packet_delivery_ratio Path_loss];

end
end

function s = bound_check(s,LB,UB)
ns_tmp=s;
ns_tmp(isnan(ns_tmp)) = 1;
I=ns_tmp<LB;
ns_tmp(I)=LB;
J=ns_tmp>UB;
ns_tmp(J)=UB;
s=ns_tmp;
end