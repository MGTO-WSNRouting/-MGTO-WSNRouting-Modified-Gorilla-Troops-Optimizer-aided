function [GlobalMin, fitness, GlobalParams,time] = COA(coyotes, FOBJ, lu, Uu, nfevalMAX)
%% ------------------------------------------------------------------------
% Coyote Optimization Algorithm (COA) for Global Optimization.
% A nature-inspired metaheuristic proposed by Juliano Pierezan and
% Leandro dos Santos Coelho (2018).
%
% Pierezan, J. and Coelho, L. S. "Coyote Optimization Algorithm: A new
% metaheuristic for global optimization problems", Proceedings of the IEEE
% Congress on Evolutionary Computation (CEC), Rio de Janeiro, Brazil, July
% 2018, pages 2633-2640.
%
% Example:
% FOBJ        = @(x) sum(x.^2);         % Optimization problem
% D           = 30;                     % Problem dimension
% lu          = [zeros(1,D);ones(1,D)]; % Seach space
% nfevalMAX   = 10000*D;                % Stopping criteria
% Np          = 10;                     % Number of packs
% Nc          = 10;                     % Number of coyotes
% [GlobalParams,GlobalMin] = COA(FOBJ, lu, nfevalMAX,Np,Nc);
%
% Federal University of Parana (UFPR), Curitiba, Parana, Brazil.
% juliano.pierezan@ufpr.br
%% ------------------------------------------------------------------------
%% Optimization problem variables
D           = size(lu,2);
VarMin      = lu(1,:);
VarMax      = Uu(1,:);
[pop_total,n_packs] = size(coyotes);
n_coy = 4;
fitness = zeros(1, nfevalMAX);
%% Algorithm parameters
if n_coy < 3, error('At least 3 coyotes per pack!');
end
p_leave     = 0.005*n_coy^2;
Ps          = 1/D;
%% Packs initialization (Eq. 2)
% pop_total   = n_packs*n_coy;
costs = zeros(pop_total,1);
ages        = zeros(pop_total,1);
coypack     = repmat(n_coy,n_packs,1);
%% Evaluate coyotes adaptation (Eq. 3)
for c=1:pop_total
    costs(c,1) = feval(FOBJ, coyotes(c,:));
end
%nfeval = pop_total;
nfeval = 1;
%% Output variables
[GlobalMin,ibest]   = min(costs);
GlobalParams        = coyotes(ibest,:);

%% Main loop
year=0;
tic;
while nfeval<=nfevalMAX % Stopping criteria
    
    %% Update the years counter
    year = year + 1;
    %% Execute the operations inside each pack
    for p=1:pop_total
        coyotes_aux = coyotes;
        costs_aux   = costs;
        ages_aux    = ages;
        n_coy_aux   = coypack;
        
        % Detect alphas according to the costs (Eq. 5)
        [costs_aux,inds] = sort(costs_aux,'ascend');
        coyotes_aux      = coyotes_aux(inds,:);
        ages_aux         = ages_aux(inds,:);
        c_alpha          = coyotes_aux(1,:);
        
        % Compute the social tendency of the pack (Eq. 6)
        tendency         = median(coyotes_aux,1);
        
        % Update coyotes' social condition
        new_coyotes      = zeros(pop_total,D);
        for c=1:n_coy_aux
            rc1 = c;
            while rc1==c
                rc1 = randi(pop_total);
            end
            rc2 = c;
            while rc2==c || rc2 == rc1
                rc2 = randi(pop_total);
            end
            
            % Try to update the social condition according to the alpha and
            % the pack tendency (Eq. 12)
            new_c = coyotes_aux(c,:) + rand*(c_alpha - coyotes_aux(rc1,:))+ ...
                rand*(tendency  - coyotes_aux(rc2,:));
            
            % Keep the coyotes in the search space (optimization problem
            % constraint)
            new_coyotes(c,:) = min(max(new_c,VarMin),VarMax);
            
            % Evaluate the new social condition (Eq. 13)
            new_cost = feval(FOBJ, new_coyotes(c,:));
            %nfeval   = nfeval+1;
            
            % Adaptation (Eq. 14)
            if new_cost < costs_aux(c,1)
                costs_aux(c,1)      = new_cost;
                coyotes_aux(c,:)    = new_coyotes(c,:);
            end
        end
        
        %% Birth of a new coyote from random parents (Eq. 7 and Alg. 1)
        parents         = randperm(pop_total,2);
        prob1           = (1-Ps)/2;
        prob2           = prob1;
        pdr             = randperm(D);
        p1              = zeros(1,D);
        p2              = zeros(1,D);
        p1(pdr(1))      = 1; % Guarantee 1 charac. per individual
        p2(pdr(2))      = 1; % Guarantee 1 charac. per individual
        r               = rand(1,D-2);
        p1(pdr(3:end))  = r < prob1;
        p2(pdr(3:end))  = r > 1-prob2;
        
        % Eventual noise
        n  = ~(p1|p2);
        
        % Generate the pup considering intrinsic and extrinsic influence
        pup =   p1.*coyotes_aux(parents(1),:) + ...
            p2.*coyotes_aux(parents(2),:) + ...
            n.*(VarMin + rand(1,D).*(VarMax-VarMin));
        
        % Verify if the pup will survive
        pup_cost    = feval(FOBJ, pup);
        %nfeval      = nfeval + 1;
        worst       = find(pup_cost<costs_aux==1);
        if ~isempty(worst)
            [~,older]               = sort(ages_aux(worst),'descend');
            which                   = worst(older);
            coyotes_aux(which(1),:) = pup;
            costs_aux(which(1),1)   = pup_cost;
            ages_aux(which(1),1)    = 0;
        end
        
        %% Update the pack information
        coyotes(p,:) = coyotes_aux(p, :);
        costs(p)   = costs_aux(p);
        ages(p)    = ages_aux(p);
    end
    
    %% A coyote can leave a pack and enter in another pack (Eq. 4)
    
    %% Update coyotes ages
    ages = ages + 1;
    
    %% Output variables (best alpha coyote among all alphas)
    [GlobalMin,ibest]   = min(costs);
    GlobalParams        = coyotes(ibest,:);
    fitness(nfeval) = GlobalMin;
    nfeval = nfeval + 1;
end
time = toc;
end
