function [ObjVal,cluster_center, out]=objfun_Cluster(soln)
global S n Security Source Dest Packet_loss Trust
for col=1:size(soln, 1) 
    CH=round(soln(col, :));
    CH = check_obj(n,CH);
    CH = bound_check(CH,1,n);
    Path = unique(CH);
    vn = find(Path == Source);
    if isempty(vn); vn = find(Path == Path(end)); end
    a = Path(1); b = Path(vn(1));
    Path(vn) = a; Path(1) = b;  % Swap the source in the first place
    vn = find(Path == Dest);  % Remove the nodes after destination node reached
    short_path = Path(1:vn);  % the path with source and dest
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
    %Finding distance matrix
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
    %Finding fitness-distance
    
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
    %Finding Residual-energy
    
    E_mat=cell2mat(E);
    CH_E=E_mat(CH, :);
    [E_CH_min_value, E_CH_index_val]=min(CH_E, [], 1);
    
    [E_node_min_value, E_node_index_val]=min(E_mat, [], 1);
    phi=20.72;
    
    tou_value=-phi*(E_CH_min_value/(abs(E_node_min_value-E_CH_min_value)+1e-10));
    f_energy_b=1-exp(tou_value);
    
    f_energy=abs(f_energy_b/exp(sum(count)));
    % QOS
    f_qos_b=max(count)+1;
    f_qos=1/f_qos_b;
    % Delay
    Delay = 1/sum(Packet_loss(short_path));
    % Security
    Secr = sum(Security(short_path));
    % Trust
    T = sum(Trust(short_path));

    % Distance
    Distance = sum(Idist)/10;
    
    % density
    load XR;
    load YR;
    
    image=randi(50,2);
    k = 2;
    xr = int32([XR]);
    yr = int32([YR]);
    a = reshape(xr,50,1);
    b = reshape(yr,50,1);
    c = [a b];
    [L U] = Kmeans(c,10);
    [uni m] = unique(U);
    d = m / 1000;
    density = mean(d);
    
    
    
    
    %Applying normalization before unification
    alpha = 0.5;
    beta = 0.5;
%     alpha = 0.2;
%     beta = 0.2;
%     gamma = 0.2;
%     delta = 0.2;
%     epsilon = 0.2;
    
%     F1 = alpha * (Idist) + (1-alpha) * (1 / f_energy);
%     F2 = beta * F1 + (1-beta) * (Delay);
%     F3 = gamma * F2 + (1-gamma) * (1 / Secr);
%     F4 = delta * F3 + (1-delta) * (1 / f_qos);
%     F5 = epsilon * F4 + (1-epsilon) * (1 / T);

%     ObjVal(col) = 1 / F5;
%     out = [Idist f_energy Delay Secr f_qos T];
%     Energy = gamma * (1/Idist) + (1-gamma) * f_energy; 
    F1 = alpha * f_energy + (1 - alpha) * Distance;
    Fitness = beta * F1 + (1 - beta) * density;
    ObjVal(col) = 1/Fitness;
    out = [Distance density ];
    
end
end

function s = bound_check(s,LB,UB)
ns_tmp=s;
ns_tmp(isnan(ns_tmp))=1;
I=ns_tmp<LB;
ns_tmp(I)=LB;
J=ns_tmp>UB;
ns_tmp(J)=UB;
s=ns_tmp;
end